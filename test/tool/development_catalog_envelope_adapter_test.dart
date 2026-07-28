import 'package:flutter_test/flutter_test.dart';

import '../../tool/development_catalog_envelope_adapter.dart';

void main() {
  const adapter = DevelopmentCatalogEnvelopeAdapter();

  group('explicit envelope adaptation', () {
    test('supports the canonical Product items envelope', () {
      final result = adapter.adapt(
        payload: {
          'items': [
            {'id': 'one'},
          ],
        },
        sourceCategory: CatalogEnvelopeSourceCategory.productItemsEnvelope,
      );

      expect(result.status, CatalogEnvelopeStatus.supportedEnvelope);
      expect(result.page!.items, hasLength(1));
      expect(result.page!.nextCursor, isNull);
      expect(result.page!.hasMore, isFalse);
      expect(result.page!.contractVersion, catalogEnvelopeContractVersion);
    });

    test('supports raw lists only for the explicit diagnostic source', () {
      final raw = [
        {'id': 'one'},
      ];
      expect(
        adapter
            .adapt(
              payload: raw,
              sourceCategory:
                  CatalogEnvelopeSourceCategory.diagnosticDirectRawList,
            )
            .status,
        CatalogEnvelopeStatus.supportedEnvelope,
      );
      expect(
        adapter
            .adapt(
              payload: raw,
              sourceCategory:
                  CatalogEnvelopeSourceCategory.productItemsEnvelope,
            )
            .status,
        CatalogEnvelopeStatus.unsupportedEnvelope,
      );
    });

    test('reproduced divergent shapes resolve to one canonical page', () {
      final items = [
        {'id': 'canonical'},
      ];
      final functional = adapter.adapt(
        payload: {'items': items},
        sourceCategory: CatalogEnvelopeSourceCategory.productItemsEnvelope,
      );
      final diagnostic = adapter.adapt(
        payload: items,
        sourceCategory: CatalogEnvelopeSourceCategory.diagnosticDirectRawList,
      );

      expect(functional.status, CatalogEnvelopeStatus.supportedEnvelope);
      expect(diagnostic.status, CatalogEnvelopeStatus.supportedEnvelope);
      expect(functional.page!.items, diagnostic.page!.items);
    });

    test('rejects unsupported, ambiguous and malformed objects', () {
      expect(
        adapter
            .adapt(
              payload: {'data': <Object?>[]},
              sourceCategory:
                  CatalogEnvelopeSourceCategory.productItemsEnvelope,
            )
            .status,
        CatalogEnvelopeStatus.malformedEnvelope,
      );
      expect(
        adapter
            .adapt(
              payload: {'items': <Object?>[], 'data': <Object?>[]},
              sourceCategory:
                  CatalogEnvelopeSourceCategory.productItemsEnvelope,
            )
            .status,
        CatalogEnvelopeStatus.ambiguousEnvelope,
      );
      expect(
        adapter
            .adapt(
              payload: {'items': <Object?>[], 'unknown': true},
              sourceCategory:
                  CatalogEnvelopeSourceCategory.productItemsEnvelope,
            )
            .status,
        CatalogEnvelopeStatus.malformedEnvelope,
      );
    });

    test('rejects missing, null, scalar, object and invalid items', () {
      for (final payload in [
        <String, Object?>{},
        {'items': null},
        {'items': 1},
        {'items': <String, Object?>{}},
      ]) {
        final status = adapter
            .adapt(
              payload: payload,
              sourceCategory:
                  CatalogEnvelopeSourceCategory.productItemsEnvelope,
            )
            .status;
        expect(
          status,
          payload.isEmpty
              ? CatalogEnvelopeStatus.malformedEnvelope
              : CatalogEnvelopeStatus.itemsTypeInvalid,
        );
      }
      expect(
        adapter
            .adapt(
              payload: {
                'items': ['invalid'],
              },
              sourceCategory:
                  CatalogEnvelopeSourceCategory.productItemsEnvelope,
            )
            .status,
        CatalogEnvelopeStatus.itemsTypeInvalid,
      );
    });

    test('accepts empty, one and multiple bounded items', () {
      for (final count in [0, 1, 2]) {
        final result = adapter.adapt(
          payload: {
            'items': List.generate(count, (index) => {'index': index}),
          },
          sourceCategory: CatalogEnvelopeSourceCategory.productItemsEnvelope,
        );
        expect(result.status, CatalogEnvelopeStatus.supportedEnvelope);
        expect(result.page!.items, hasLength(count));
      }
    });

    test('blocks oversized and full pages without pagination metadata', () {
      for (final count in [20, 21]) {
        final result = adapter.adapt(
          payload: {
            'items': List.generate(count, (index) => {'index': index}),
          },
          sourceCategory: CatalogEnvelopeSourceCategory.productItemsEnvelope,
        );
        expect(
          result.status,
          count == 20
              ? CatalogEnvelopeStatus.pageLimitReached
              : CatalogEnvelopeStatus.paginationInvalid,
        );
      }
    });
  });

  group('canonical pagination', () {
    CanonicalSelectableSpecialistPage page({
      String? cursor,
      bool hasMore = false,
      String version = catalogEnvelopeContractVersion,
    }) => CanonicalSelectableSpecialistPage(
      items: const [],
      nextCursor: cursor,
      hasMore: hasMore,
      contractVersion: version,
      sourceCategory: CatalogEnvelopeSourceCategory.productItemsEnvelope,
    );

    test('no next page is supported', () {
      expect(
        page().validateBoundedSelection(
          maximumItems: 20,
          currentPage: 1,
          maximumPages: 1,
        ),
        CatalogEnvelopeStatus.supportedEnvelope,
      );
    });

    test('hasMore and cursor must agree', () {
      for (final value in [
        page(hasMore: true),
        page(cursor: 'cursor'),
        page(cursor: '', hasMore: true),
      ]) {
        expect(
          value.validateBoundedSelection(
            maximumItems: 20,
            currentPage: 1,
            maximumPages: 2,
          ),
          CatalogEnvelopeStatus.paginationInvalid,
        );
      }
    });

    test('additional page, page limit and cursor cycle block selection', () {
      final value = page(cursor: 'cursor', hasMore: true);
      expect(
        value.validateBoundedSelection(
          maximumItems: 20,
          currentPage: 1,
          maximumPages: 2,
        ),
        CatalogEnvelopeStatus.paginationRequiresAdditionalPage,
      );
      expect(
        value.validateBoundedSelection(
          maximumItems: 20,
          currentPage: 1,
          maximumPages: 1,
        ),
        CatalogEnvelopeStatus.pageLimitReached,
      );
      expect(
        value.validateBoundedSelection(
          maximumItems: 20,
          currentPage: 1,
          maximumPages: 2,
          seenCursors: const {'cursor'},
        ),
        CatalogEnvelopeStatus.cursorCycle,
      );
    });

    test('unsupported contract version blocks', () {
      expect(
        page(version: 'unsupported').validateBoundedSelection(
          maximumItems: 20,
          currentPage: 1,
          maximumPages: 1,
        ),
        CatalogEnvelopeStatus.contractVersionUnsupported,
      );
    });
  });
}
