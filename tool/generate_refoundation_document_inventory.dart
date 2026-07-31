import 'dart:io';

const outputPath =
    'docs/stasisly_refoundation/inventories/DOCUMENT_INVENTORY.md';

void main() {
  final docs = Directory('docs');
  if (!docs.existsSync()) {
    stderr.writeln('REFOUNDATION_DOCUMENT_ROOT_MISSING');
    exitCode = 1;
    return;
  }

  final paths =
      docs
          .listSync(recursive: true, followLinks: false)
          .whereType<File>()
          .map((file) => file.path)
          .where((path) => !path.endsWith('.DS_Store'))
          .toSet()
        ..add('README.md')
        ..add(outputPath);
  final ordered = paths.toList()..sort();

  final buffer = StringBuffer()
    ..writeln('# Document Inventory')
    ..writeln()
    ..writeln('Generated deterministically by')
    ..writeln('`tool/generate_refoundation_document_inventory.dart`.')
    ..writeln()
    ..writeln('```text')
    ..writeln('Documents inventoried: ${ordered.length}')
    ..writeln('Files moved: 0')
    ..writeln('Files removed: 0')
    ..writeln('```')
    ..writeln()
    ..writeln(
      '| CURRENT_PATH | DOCUMENT_TYPE | CURRENT_STATUS | NEW_STATUS | '
      'TARGET_PATH | MIGRATION_ACTION | REASON |',
    )
    ..writeln('|---|---|---|---|---|---|---|');

  for (final path in ordered) {
    final record = classify(path);
    buffer.writeln(
      '| `$path` | ${record.type} | ${record.currentStatus} | '
      '${record.newStatus} | `${record.target}` | ${record.action} | '
      '${record.reason} |',
    );
  }

  File(outputPath)
    ..createSync(recursive: true)
    ..writeAsStringSync(buffer.toString());
  stdout.writeln('REFOUNDATION_DOCUMENT_INVENTORY_GENERATED:${ordered.length}');
}

InventoryRecord classify(String path) {
  final type = path.contains('/decisions/ADR-') || path.contains('/adr/ADR-')
      ? 'ADR'
      : path.contains('/inventories/')
      ? 'INVENTORY'
      : path.endsWith('.json')
      ? 'MANIFEST_OR_STRUCTURED_DOCUMENT'
      : path.contains('/status/')
      ? 'STATUS_OR_CATALOG_CONTRACT'
      : 'DOCUMENTATION';

  if (path.startsWith('docs/stasisly_refoundation/')) {
    return InventoryRecord(
      type: type,
      currentStatus: 'REFOUNDATION_CURRENT',
      newStatus: 'NORMATIVE_OR_SUPPORTING_CURRENT',
      target: path,
      action: 'KEEP_NORMATIVE',
      reason: 'Current Re-foundation baseline',
    );
  }
  if (path == 'README.md') {
    return InventoryRecord(
      type: 'DOCUMENTATION_ENTRY_POINT',
      currentStatus: 'REFOUNDATION_CURRENT',
      newStatus: 'NORMATIVE_ROUTER',
      target: path,
      action: 'KEEP_NORMATIVE',
      reason: 'Repository entry point to current source of truth',
    );
  }
  if (path.startsWith('docs/archive/discovery/')) {
    return InventoryRecord(
      type: type,
      currentStatus: 'DISCOVERY_LEGACY',
      newStatus: 'READ_ONLY_REFERENCE_NON_NORMATIVE',
      target: path,
      action: 'ARCHIVE_DISCOVERY',
      reason: 'Already preserved in Discovery archive',
    );
  }
  if (path.startsWith('docs/stasisly_foundation/')) {
    final suffix = path.substring('docs/stasisly_foundation/'.length);
    return InventoryRecord(
      type: type,
      currentStatus: 'FOUNDATION_LEGACY',
      newStatus: 'PRESERVED_EVIDENCE_NON_NORMATIVE',
      target: 'docs/archive/foundation-legacy/$suffix',
      action: 'ARCHIVE_FOUNDATION_LEGACY',
      reason: 'Target only; no move in this package',
    );
  }
  return InventoryRecord(
    type: type,
    currentStatus: 'REQUIRES_REVIEW',
    newStatus: 'REQUIRES_REVIEW',
    target: path,
    action: 'REVIEW_REQUIRED',
    reason: 'Outside classified documentary roots',
  );
}

final class InventoryRecord {
  const InventoryRecord({
    required this.type,
    required this.currentStatus,
    required this.newStatus,
    required this.target,
    required this.action,
    required this.reason,
  });

  final String type;
  final String currentStatus;
  final String newStatus;
  final String target;
  final String action;
  final String reason;
}
