import 'package:stasisly/core/observability/conversation_observability.dart';
import 'package:stasisly/features/conversations/application/state/conversation_application_states.dart';
import 'package:stasisly/features/conversations/application/state/conversation_result_mapping.dart';
import 'package:stasisly/features/conversations/application/use_cases/conversation_use_cases.dart';
import 'package:stasisly/features/conversations/domain/entities/conversation.dart';
import 'package:stasisly/features/conversations/domain/results/conversation_results.dart';

class ConversationListController {
  ConversationListController({
    required ListOwnConversations listOwnConversations,
    this.pageSize = 20,
    this.observability = const NoOpConversationObservabilitySink(),
    this.observedEnvironment = ConversationObservedEnvironment.unknown,
    void Function(ConversationListState)? onStateChanged,
  }) : _listOwnConversations = listOwnConversations,
       _onStateChanged = onStateChanged;

  final ListOwnConversations _listOwnConversations;
  final int pageSize;
  final ConversationObservabilitySink observability;
  final ConversationObservedEnvironment observedEnvironment;
  final void Function(ConversationListState)? _onStateChanged;

  ConversationListState state = const ConversationListState();
  int _generation = 0;
  bool _loadingMore = false;
  bool _disposed = false;

  Future<void> loadInitial() => _loadFresh(refresh: false);

  Future<void> refresh() => _loadFresh(refresh: true);

  Future<void> changeFilter(ConversationListFilter filter) async {
    if (_disposed || filter == state.filter) return;
    _generation += 1;
    _emit(ConversationListState(filter: filter));
    await _loadFresh(refresh: false);
  }

  Future<void> loadMore() async {
    if (_disposed || _loadingMore || !state.hasMore) return;
    _loadingMore = true;
    final generation = _generation;
    final filter = state.filter;
    final cursor = state.nextCursor;
    final stopwatch = Stopwatch()..start();
    _record(
      ConversationObservabilityEventName.paginationRequested,
      ConversationObservationResult.requested,
    );
    _emit(
      state.copyWith(phase: ConversationListPhase.loadingMore, error: null),
    );
    final result = await _listOwnConversations(
      status: _domainFilter(filter),
      limit: pageSize,
      cursor: cursor,
    );
    _loadingMore = false;
    if (!_isCurrent(generation, filter)) {
      return;
    }
    switch (result) {
      case ConversationListSuccess(:final page):
        if (!_validPage(page, filter)) {
          _recordFailure(
            stopwatch,
            ConversationApplicationErrorCode.contractViolation,
            pagination: true,
          );
          _emitFailure(
            ConversationApplicationErrorCode.contractViolation,
            preserveData: true,
          );
          return;
        }
        final merged = <Conversation>[];
        final seen = <String>{};
        for (final item in [...state.conversations, ...page.items]) {
          if (seen.add(item.conversationId.value)) merged.add(item);
        }
        _emit(
          state.copyWith(
            phase: merged.isEmpty
                ? ConversationListPhase.empty
                : ConversationListPhase.data,
            conversations: merged,
            nextCursor: _cursor(page.nextCursor),
            error: null,
          ),
        );
        _recordSuccess(stopwatch, page.items.length, pagination: true);
      case ConversationListFailure(:final status):
        final error = mapConversationError(status);
        _recordFailure(stopwatch, error, pagination: true);
        _emitFailure(error, preserveData: true);
    }
  }

  Future<void> _loadFresh({required bool refresh}) async {
    if (_disposed) return;
    final generation = ++_generation;
    final filter = state.filter;
    final stopwatch = Stopwatch()..start();
    _record(
      ConversationObservabilityEventName.conversationListRequested,
      ConversationObservationResult.requested,
    );
    _emit(
      state.copyWith(
        phase: refresh && state.conversations.isNotEmpty
            ? ConversationListPhase.refreshing
            : ConversationListPhase.loading,
        conversations: refresh ? state.conversations : const [],
        nextCursor: null,
        error: null,
      ),
    );
    final result = await _listOwnConversations(
      status: _domainFilter(filter),
      limit: pageSize,
    );
    if (!_isCurrent(generation, filter)) {
      return;
    }
    switch (result) {
      case ConversationListSuccess(:final page):
        if (!_validPage(page, filter)) {
          _recordFailure(
            stopwatch,
            ConversationApplicationErrorCode.contractViolation,
          );
          _emitFailure(ConversationApplicationErrorCode.contractViolation);
          return;
        }
        final deduplicated = <Conversation>[];
        final seen = <String>{};
        for (final item in page.items) {
          if (seen.add(item.conversationId.value)) deduplicated.add(item);
        }
        _emit(
          state.copyWith(
            phase: deduplicated.isEmpty
                ? ConversationListPhase.empty
                : ConversationListPhase.data,
            conversations: deduplicated,
            nextCursor: _cursor(page.nextCursor),
            error: null,
          ),
        );
        _recordSuccess(stopwatch, page.items.length);
      case ConversationListFailure(:final status):
        final error = mapConversationError(status);
        _recordFailure(stopwatch, error);
        _emitFailure(error, preserveData: refresh);
    }
  }

  void _emitFailure(
    ConversationApplicationErrorCode error, {
    bool preserveData = false,
  }) {
    final phase = switch (error) {
      ConversationApplicationErrorCode.unauthenticated =>
        ConversationListPhase.unauthenticated,
      ConversationApplicationErrorCode.environmentBlocked =>
        ConversationListPhase.environmentBlocked,
      _ => ConversationListPhase.error,
    };
    _emit(
      state.copyWith(
        phase: preserveData && state.conversations.isNotEmpty
            ? ConversationListPhase.data
            : phase,
        error: error,
        nextCursor: preserveData ? state.nextCursor : null,
      ),
    );
  }

  void _record(
    ConversationObservabilityEventName event,
    ConversationObservationResult result, {
    ConversationDurationBucket? duration,
    ConversationItemCountBucket? itemCount,
    ConversationSafeErrorCode? error,
  }) {
    try {
      observability.record(
        ConversationObservation(
          event: event,
          category: ConversationObservationCategory.list,
          result: result,
          environment: observedEnvironment,
          duration: duration,
          itemCount: itemCount,
          error: error,
        ),
      );
    } on Object {
      // Observability is diagnostic and must never alter Product behavior.
    }
  }

  void _recordSuccess(
    Stopwatch stopwatch,
    int itemCount, {
    bool pagination = false,
  }) {
    stopwatch.stop();
    _record(
      pagination
          ? ConversationObservabilityEventName.paginationCompleted
          : ConversationObservabilityEventName.conversationListSucceeded,
      itemCount == 0
          ? ConversationObservationResult.empty
          : ConversationObservationResult.success,
      duration: conversationDurationBucket(stopwatch.elapsed),
      itemCount: conversationItemCountBucket(itemCount),
    );
  }

  void _recordFailure(
    Stopwatch stopwatch,
    ConversationApplicationErrorCode error, {
    bool pagination = false,
  }) {
    stopwatch.stop();
    _record(
      error == ConversationApplicationErrorCode.contractViolation
          ? ConversationObservabilityEventName.contractViolationDetected
          : error == ConversationApplicationErrorCode.environmentBlocked
          ? ConversationObservabilityEventName.environmentBlocked
          : pagination
          ? ConversationObservabilityEventName.paginationCompleted
          : ConversationObservabilityEventName.conversationListFailed,
      _safeResult(error),
      duration: conversationDurationBucket(stopwatch.elapsed),
      error: _safeError(error),
    );
  }

  bool _validPage(ConversationPage page, ConversationListFilter filter) {
    final expected = filter == ConversationListFilter.active
        ? ConversationStatus.active
        : ConversationStatus.archived;
    return page.items.every((item) => item.status == expected) &&
        (page.nextCursor == null || page.nextCursor!.trim().isNotEmpty);
  }

  String? _cursor(String? value) => value?.trim();

  bool _isCurrent(int generation, ConversationListFilter filter) =>
      !_disposed && generation == _generation && filter == state.filter;

  void _emit(ConversationListState next) {
    if (_disposed) return;
    state = next;
    _onStateChanged?.call(next);
  }

  void dispose() {
    _disposed = true;
    _generation += 1;
  }
}

ConversationSafeErrorCode _safeError(ConversationApplicationErrorCode error) =>
    ConversationSafeErrorCode.values.byName(error.name);

ConversationObservationResult _safeResult(
  ConversationApplicationErrorCode error,
) => ConversationObservationResult.values.byName(switch (error) {
  ConversationApplicationErrorCode.notFound => 'notFoundOpaque',
  ConversationApplicationErrorCode.unauthorized => 'unknownFailure',
  _ => error.name,
});

ConversationStatusFilter _domainFilter(ConversationListFilter filter) =>
    switch (filter) {
      ConversationListFilter.active => ConversationStatusFilter.active,
      ConversationListFilter.archived => ConversationStatusFilter.archived,
    };
