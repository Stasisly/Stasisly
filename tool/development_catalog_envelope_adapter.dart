const catalogEnvelopeContractVersion = 'FOUNDATION-019A-R2G-CATALOG-v1';
const catalogAdapterSharedGuard = 'CATALOG_ADAPTER_SHARED';

enum CatalogEnvelopeSourceCategory {
  productItemsEnvelope,
  diagnosticDirectRawList,
}

enum CatalogEnvelopeStatus {
  supportedEnvelope,
  unsupportedEnvelope,
  ambiguousEnvelope,
  malformedEnvelope,
  contractVersionUnsupported,
  itemsTypeInvalid,
  paginationInvalid,
  paginationRequiresAdditionalPage,
  cursorCycle,
  pageLimitReached,
}

final class CanonicalSelectableSpecialistPage {
  const CanonicalSelectableSpecialistPage({
    required this.items,
    required this.nextCursor,
    required this.hasMore,
    required this.contractVersion,
    required this.sourceCategory,
  });

  final List<Map<String, Object?>> items;
  final String? nextCursor;
  final bool hasMore;
  final String contractVersion;
  final CatalogEnvelopeSourceCategory sourceCategory;

  CatalogEnvelopeStatus validateBoundedSelection({
    required int maximumItems,
    required int currentPage,
    required int maximumPages,
    Set<String> seenCursors = const {},
  }) {
    if (contractVersion != catalogEnvelopeContractVersion) {
      return CatalogEnvelopeStatus.contractVersionUnsupported;
    }
    if (maximumItems < 1 ||
        currentPage < 1 ||
        maximumPages < 1 ||
        items.length > maximumItems) {
      return CatalogEnvelopeStatus.paginationInvalid;
    }
    final cursor = nextCursor;
    if (hasMore != (cursor != null)) {
      return CatalogEnvelopeStatus.paginationInvalid;
    }
    if (cursor != null) {
      if (cursor.isEmpty) return CatalogEnvelopeStatus.paginationInvalid;
      if (seenCursors.contains(cursor)) {
        return CatalogEnvelopeStatus.cursorCycle;
      }
      if (currentPage >= maximumPages) {
        return CatalogEnvelopeStatus.pageLimitReached;
      }
      return CatalogEnvelopeStatus.paginationRequiresAdditionalPage;
    }
    return CatalogEnvelopeStatus.supportedEnvelope;
  }
}

final class CatalogEnvelopeAdaptation {
  const CatalogEnvelopeAdaptation(this.status, [this.page]);

  final CatalogEnvelopeStatus status;
  final CanonicalSelectableSpecialistPage? page;

  bool get isSupported =>
      status == CatalogEnvelopeStatus.supportedEnvelope && page != null;
}

final class DevelopmentCatalogEnvelopeAdapter {
  const DevelopmentCatalogEnvelopeAdapter({
    this.maximumItems = 20,
    this.maximumPages = 1,
  });

  final int maximumItems;
  final int maximumPages;

  CatalogEnvelopeAdaptation adapt({
    required Object? payload,
    required CatalogEnvelopeSourceCategory sourceCategory,
  }) {
    if (maximumItems < 1 || maximumPages != 1) {
      return const CatalogEnvelopeAdaptation(
        CatalogEnvelopeStatus.paginationInvalid,
      );
    }
    final Object? rawItems;
    switch (sourceCategory) {
      case CatalogEnvelopeSourceCategory.productItemsEnvelope:
        if (payload is! Map) {
          return const CatalogEnvelopeAdaptation(
            CatalogEnvelopeStatus.unsupportedEnvelope,
          );
        }
        final keys = payload.keys.toSet();
        if (keys.contains('items') && keys.contains('data')) {
          return const CatalogEnvelopeAdaptation(
            CatalogEnvelopeStatus.ambiguousEnvelope,
          );
        }
        if (keys.length != 1 || !keys.contains('items')) {
          return const CatalogEnvelopeAdaptation(
            CatalogEnvelopeStatus.malformedEnvelope,
          );
        }
        rawItems = payload['items'];
      case CatalogEnvelopeSourceCategory.diagnosticDirectRawList:
        if (payload is! List) {
          return const CatalogEnvelopeAdaptation(
            CatalogEnvelopeStatus.unsupportedEnvelope,
          );
        }
        rawItems = payload;
    }
    if (rawItems is! List) {
      return const CatalogEnvelopeAdaptation(
        CatalogEnvelopeStatus.itemsTypeInvalid,
      );
    }
    if (rawItems.length > maximumItems) {
      return const CatalogEnvelopeAdaptation(
        CatalogEnvelopeStatus.paginationInvalid,
      );
    }
    final items = <Map<String, Object?>>[];
    for (final value in rawItems) {
      if (value is! Map) {
        return const CatalogEnvelopeAdaptation(
          CatalogEnvelopeStatus.itemsTypeInvalid,
        );
      }
      try {
        items.add(Map<String, Object?>.from(value));
      } on Object {
        return const CatalogEnvelopeAdaptation(
          CatalogEnvelopeStatus.itemsTypeInvalid,
        );
      }
    }

    // Both current external contracts cap their source query at 20 and expose
    // no cursor. A full page cannot prove completeness, so exact-one selection
    // must fail closed until a versioned pagination contract exists.
    final page = CanonicalSelectableSpecialistPage(
      items: List.unmodifiable(items),
      nextCursor: null,
      hasMore: false,
      contractVersion: catalogEnvelopeContractVersion,
      sourceCategory: sourceCategory,
    );
    if (items.length == maximumItems) {
      return CatalogEnvelopeAdaptation(
        CatalogEnvelopeStatus.pageLimitReached,
        page,
      );
    }
    final status = page.validateBoundedSelection(
      maximumItems: maximumItems,
      currentPage: 1,
      maximumPages: maximumPages,
    );
    return CatalogEnvelopeAdaptation(status, page);
  }
}
