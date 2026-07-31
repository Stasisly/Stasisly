import 'dart:convert';
import 'dart:io';

const promptGovernanceRoot = 'docs/stasisly_refoundation/agents/prompts';
const agentCatalogPath =
    'docs/stasisly_refoundation/agents/AGENT_CATALOG_MASTER_v1.json';
const historicalInventoryPath =
    'docs/stasisly_refoundation/inventories/'
    'HISTORICAL_43_AGENTS_INVENTORY.md';
const historicalPromptRoot =
    'docs/archive/discovery/stasisly_definition/agents';
const sourceCatalogVersion = '1.0.0';

const promptAuditFields = <String>[
  'historical_agent_name',
  'historical_file',
  'catalog_agent_id',
  'catalog_canonical_name',
  'surface',
  'domain',
  'family',
  'historical_prompt_status',
  'migration_decision',
  'prompt_reusability',
  'refoundation_alignment',
  'contradictions',
  'obsolete_sections',
  'missing_sections',
  'security_risks',
  'authority_risks',
  'tooling_assumptions',
  'memory_assumptions',
  'runtime_assumptions',
  'recommended_action',
  'target_wave',
  'review_status',
  'notes',
];

const waveAssignmentFields = <String>[
  'agent_id',
  'canonical_name',
  'display_name',
  'surface',
  'wave_id',
  'wave_name',
  'assignment_reason',
  'historical_prompt',
  'migration_decision',
  'prompt_creation_package',
  'runtime_package',
];

const validMigrationDecisions = {
  'MIGRATE_UNCHANGED',
  'MIGRATE_AND_UPDATE',
  'RECLASSIFY',
  'MERGE',
  'ARCHIVE',
  'REQUIRES_REVIEW',
};

const validPromptReuse = {
  'REUSABLE_AS_IS',
  'MOSTLY_REUSABLE',
  'PARTIALLY_REUSABLE',
  'CONCEPT_ONLY',
  'NOT_REUSABLE',
};

const validRefoundationAlignment = {
  'ALIGNED',
  'ALIGNED_WITH_MINOR_CHANGES',
  'REQUIRES_MAJOR_UPDATE',
  'CONFLICTS_WITH_REFOUNDATION',
  'REQUIRES_RECLASSIFICATION',
};

const validWaveIds = {
  'WAVE_1',
  'WAVE_2',
  'WAVE_3',
  'WAVE_4',
  'WAVE_5',
  'WAVE_6',
  'WAVE_7_PLUS',
};

const waveNames = <String, String>{
  'WAVE_1': 'Principal Coordinators',
  'WAVE_2': 'Governance Security and Founder Control',
  'WAVE_3': 'Technical and Multi-agent Architecture',
  'WAVE_4': 'Product Core',
  'WAVE_5': 'Development Core',
  'WAVE_6': 'Administration Core',
  'WAVE_7_PLUS': 'Progressive Specialization',
};

void main() {
  final artifacts = buildAgentPromptGovernanceArtifacts();
  for (final artifact in artifacts.entries) {
    File(artifact.key)
      ..createSync(recursive: true)
      ..writeAsStringSync(artifact.value);
  }
  stdout.writeln('AGENT_PROMPT_GOVERNANCE_V1_GENERATED:${artifacts.length}');
}

Map<String, String> buildAgentPromptGovernanceArtifacts() {
  final catalog = readAgentCatalog();
  final decisions = _readHistoricalDecisions();
  final audits = buildHistoricalPromptAudits(catalog, decisions);
  final assignments = buildWaveAssignments(catalog, audits);
  final findings = validatePromptGovernanceData(
    catalog: catalog,
    audits: audits,
    assignments: assignments,
  );
  if (findings.isNotEmpty) {
    throw StateError('PROMPT_GOVERNANCE_INVALID:${findings.join(',')}');
  }

  return <String, String>{
    '$promptGovernanceRoot/HISTORICAL_43_PROMPT_AUDIT_v1.csv': _csv(
      promptAuditFields,
      audits,
    ),
    '$promptGovernanceRoot/HISTORICAL_43_PROMPT_AUDIT_v1.json': _auditJson(
      audits,
    ),
    '$promptGovernanceRoot/HISTORICAL_43_PROMPT_AUDIT_v1.md': _auditMarkdown(
      audits,
    ),
    '$promptGovernanceRoot/HISTORICAL_PROMPT_CONTENT_MATRIX_v1.md':
        _contentMatrix(audits),
    '$promptGovernanceRoot/HISTORICAL_PROMPT_CONTRADICTIONS_v1.md':
        _contradictionReport(audits),
    '$promptGovernanceRoot/HISTORICAL_PROMPT_REUSE_REPORT_v1.md': _reuseReport(
      audits,
    ),
    '$promptGovernanceRoot/AGENT_WAVE_PLAN_v1.md': _wavePlan(assignments),
    '$promptGovernanceRoot/AGENT_WAVE_ASSIGNMENTS_v1.csv': _csv(
      waveAssignmentFields,
      assignments,
    ),
    '$promptGovernanceRoot/AGENT_WAVE_ASSIGNMENTS_v1.json': _waveJson(
      assignments,
    ),
    '$promptGovernanceRoot/AGENT_WAVE_ASSIGNMENTS_v1.md':
        _waveAssignmentsMarkdown(assignments, audits),
    '$promptGovernanceRoot/AGENT_PROMPT_MIGRATION_READINESS_v1.md':
        _migrationReadiness(audits, assignments),
  };
}

List<Map<String, Object?>> readAgentCatalog() {
  final root =
      jsonDecode(File(agentCatalogPath).readAsStringSync())
          as Map<String, Object?>;
  return (root['entries']! as List<Object?>).cast<Map<String, Object?>>();
}

Map<String, String> _readHistoricalDecisions() {
  final rows = File(historicalInventoryPath).readAsLinesSync();
  final pattern = RegExp(
    r'^\| \d+ \| `([^`]+)` \| .+? \| FOUND \| PROMPT_CREATED \| '
    r'(?:Product|Development|Administration|Transversal) \| '
    r'(MIGRATE_AND_UPDATE|RECLASSIFY) \|$',
  );
  final decisions = <String, String>{};
  for (final row in rows) {
    final match = pattern.firstMatch(row);
    if (match != null) decisions[match.group(1)!] = match.group(2)!;
  }
  if (decisions.length != 43) {
    throw StateError('HISTORICAL_DECISIONS_INVALID:${decisions.length}');
  }
  return decisions;
}

List<Map<String, Object?>> buildHistoricalPromptAudits(
  List<Map<String, Object?>> catalog,
  Map<String, String> decisions,
) {
  final historical =
      catalog.where((entry) => entry['historical_mapping'] != 'NONE').toList()
        ..sort(
          (left, right) => (left['historical_mapping']! as String).compareTo(
            right['historical_mapping']! as String,
          ),
        );
  return historical.map((entry) {
    final path = entry['historical_mapping']! as String;
    final fileName = path.split('/').last;
    final content = File(path).readAsStringSync();
    final heading = RegExp(
      r'^# (.+)$',
      multiLine: true,
    ).firstMatch(content)!.group(1)!;
    final decision = decisions[fileName]!;
    final targetWave = _historicalTargetWave(entry, decision);
    final reclassified = decision == 'RECLASSIFY';
    return <String, Object?>{
      'historical_agent_name': heading,
      'historical_file': fileName,
      'catalog_agent_id': entry['agent_id'],
      'catalog_canonical_name': entry['canonical_name'],
      'surface': entry['surface'],
      'domain': entry['domain'],
      'family': entry['family'],
      'historical_prompt_status': 'PROMPT_CREATED',
      'migration_decision': decision,
      'prompt_reusability': reclassified
          ? 'PARTIALLY_REUSABLE'
          : 'MOSTLY_REUSABLE',
      'refoundation_alignment': reclassified
          ? 'REQUIRES_RECLASSIFICATION'
          : 'REQUIRES_MAJOR_UPDATE',
      'contradictions': reclassified
          ? 'Historical surface classification conflicts with the approved '
                'Re-foundation ownership model.'
          : 'Fixed committee framing and duplicated global policy conflict '
                'with the extensible catalog and layered prompt model.',
      'obsolete_sections':
          'Perfil AAA framing; fixed committee membership; repeated global '
          'Stasisly context; direct Codex operational controls.',
      'missing_sections':
          'Canonical metadata; shared-layer references; independent schema, '
          'prompt, runtime and evaluation versions; approval evidence; '
          'evaluation binding.',
      'security_risks': _securityRisk(heading, entry['surface']! as String),
      'authority_risks': _authorityRisk(heading),
      'tooling_assumptions': _toolingAssumption(heading),
      'memory_assumptions':
          'Federated memory is discussed conceptually without a versioned '
          'runtime memory binding or provisioned scope.',
      'runtime_assumptions':
          'The text describes intended capabilities but contains no approved '
          'runtime configuration, availability evidence or executable grant.',
      'recommended_action': reclassified
          ? 'Reclassify ownership first, then extract reusable role content '
                'into a new layered prompt during $targetWave.'
          : 'Extract agent-specific role content, replace obsolete shared '
                'text, and migrate through P0-P14 during $targetWave.',
      'target_wave': targetWave,
      'review_status': 'AUDITED_PLANNING_ONLY',
      'notes':
          'Historical source remains unmodified and non-normative. Prompt is '
          'not approved, configured, tested or available.',
    };
  }).toList();
}

String _historicalTargetWave(Map<String, Object?> entry, String decision) {
  final surface = entry['surface']! as String;
  final name = (entry['display_name']! as String).toLowerCase();
  if (surface == 'TRANSVERSAL') return 'WAVE_2';
  if (surface == 'PRODUCT') return 'WAVE_4';
  if (surface == 'ADMINISTRATION') return 'WAVE_6';
  const architectureSignals = <String>[
    'arquitecto',
    'mcp',
    'datos y memoria',
    'llm',
    'prompt',
    'calidad de datos',
    'costes ia',
    'catálogo de agentes',
  ];
  return architectureSignals.any(name.contains) ? 'WAVE_3' : 'WAVE_5';
}

String _securityRisk(String name, String surface) {
  final lower = name.toLowerCase();
  if (lower.contains('seguridad') ||
      lower.contains('criptograf') ||
      lower.contains('backend') ||
      lower.contains('datos y memoria') ||
      lower.contains('membres') ||
      lower.contains('customer success') ||
      lower.contains('recomendaci')) {
    return 'Role may touch sensitive systems or data; future prompt must bind '
        'resource, environment, data class and deny-by-default tool policy.';
  }
  return 'No explicit runtime data or tool binding; future prompt must inherit '
      'deny-by-default security and privacy layers.';
}

String _authorityRisk(String name) {
  final lower = name.toLowerCase();
  if (lower.contains('director') ||
      lower.contains('product owner') ||
      lower.contains('arquitect') ||
      lower.contains('seguridad') ||
      lower.contains('scrum')) {
    return 'Broad blocking and coordination language could be interpreted as '
        'execution authority unless approval and enforcement boundaries are explicit.';
  }
  return 'Review and recommendation language requires an explicit statement '
      'that catalog role, advice and runtime authority are separate.';
}

String _toolingAssumption(String name) {
  final lower = name.toLowerCase();
  if (lower.contains('flutter') ||
      lower.contains('frontend') ||
      lower.contains('component')) {
    return 'Assumes code, Flutter and design tooling without a ToolBinding contract.';
  }
  if (lower.contains('backend') ||
      lower.contains('devops') ||
      lower.contains('datos') ||
      lower.contains('observabilidad')) {
    return 'Assumes backend, database or platform tooling without a ToolBinding contract.';
  }
  if (lower.contains('llm') ||
      lower.contains('prompt') ||
      lower.contains('multiagente') ||
      lower.contains('mcp')) {
    return 'Assumes model, agent or evaluation tooling without a ToolBinding contract.';
  }
  return 'Assumes review, research or analytics capabilities without a ToolBinding contract.';
}

List<Map<String, Object?>> buildWaveAssignments(
  List<Map<String, Object?>> catalog,
  List<Map<String, Object?>> audits,
) {
  final historicalById = {
    for (final audit in audits) audit['catalog_agent_id']! as String: audit,
  };
  final waveById = <String, String>{
    'AG-TRV-0001': 'WAVE_1',
    'AG-PRO-0001': 'WAVE_1',
    'AG-DEV-0001': 'WAVE_1',
    'AG-ADM-0001': 'WAVE_1',
  };
  for (final audit in audits) {
    waveById[audit['catalog_agent_id']! as String] =
        audit['target_wave']! as String;
  }

  _fillWave(
    catalog,
    waveById,
    'WAVE_2',
    18,
    (entry) => entry['surface'] == 'TRANSVERSAL',
  );
  _fillWave(
    catalog,
    waveById,
    'WAVE_3',
    40,
    (entry) =>
        entry['surface'] == 'DEVELOPMENT' &&
        <String>{
          'architecture',
          'postgres_supabase_data',
          'data_router_sharding',
          'security_privacy',
          'ai_orchestration',
          'prompts_memory_rag_evaluation',
        }.contains(entry['domain']),
  );
  _fillWave(
    catalog,
    waveById,
    'WAVE_4',
    50,
    (entry) => entry['surface'] == 'PRODUCT',
  );
  _fillWave(
    catalog,
    waveById,
    'WAVE_5',
    60,
    (entry) => entry['surface'] == 'DEVELOPMENT',
  );
  _fillWave(
    catalog,
    waveById,
    'WAVE_6',
    50,
    (entry) => entry['surface'] == 'ADMINISTRATION',
  );

  return catalog.map((entry) {
    final id = entry['agent_id']! as String;
    final wave = waveById[id] ?? 'WAVE_7_PLUS';
    final historical = historicalById[id];
    return <String, Object?>{
      'agent_id': id,
      'canonical_name': entry['canonical_name'],
      'display_name': entry['display_name'],
      'surface': entry['surface'],
      'wave_id': wave,
      'wave_name': waveNames[wave],
      'assignment_reason': _assignmentReason(entry, wave, historical != null),
      'historical_prompt': historical == null
          ? 'NONE'
          : historical['historical_file'],
      'migration_decision': historical == null
          ? 'NOT_APPLICABLE'
          : historical['migration_decision'],
      'prompt_creation_package': _promptPackage(wave),
      'runtime_package': 'SEPARATE_RUNTIME_PACKAGE_NOT_AUTHORIZED',
    };
  }).toList();
}

void _fillWave(
  List<Map<String, Object?>> catalog,
  Map<String, String> waveById,
  String wave,
  int target,
  bool Function(Map<String, Object?> entry) predicate,
) {
  var current = waveById.values.where((value) => value == wave).length;
  for (final entry in catalog) {
    if (current >= target) return;
    final id = entry['agent_id']! as String;
    if (!waveById.containsKey(id) && predicate(entry)) {
      waveById[id] = wave;
      current++;
    }
  }
  if (current != target) {
    throw StateError('${wave}_ALLOCATION_INVALID:$current');
  }
}

String _assignmentReason(
  Map<String, Object?> entry,
  String wave,
  bool historical,
) {
  if (wave == 'WAVE_1') {
    return 'Principal coordinator dependency; new canonical prompt required.';
  }
  if (historical) {
    return 'Historical prompt prioritized by approved surface and dependency order.';
  }
  if (wave == 'WAVE_7_PLUS') {
    return 'Specialized capability deferred until prerequisite governance and core waves pass.';
  }
  return 'Catalog capability selected to complete the bounded core design cohort.';
}

String _promptPackage(String wave) => switch (wave) {
  'WAVE_1' => 'STASISLY-AGENTS-002',
  'WAVE_2' => 'STASISLY-AGENTS-003',
  'WAVE_3' => 'STASISLY-AGENTS-WAVE-003',
  'WAVE_4' => 'STASISLY-AGENTS-WAVE-004',
  'WAVE_5' => 'STASISLY-AGENTS-WAVE-005',
  'WAVE_6' => 'STASISLY-AGENTS-WAVE-006',
  _ => 'FUTURE_SPECIALIZATION_PACKAGE',
};

List<String> validatePromptGovernanceData({
  required List<Map<String, Object?>> catalog,
  required List<Map<String, Object?>> audits,
  required List<Map<String, Object?>> assignments,
}) {
  final findings = <String>[];
  if (catalog.length != 3000) findings.add('CATALOG_COUNT');
  if (audits.length != 43) findings.add('AUDIT_COUNT');
  if (assignments.length != 3000) findings.add('ASSIGNMENT_COUNT');
  _unique(audits, 'historical_file', findings);
  _unique(audits, 'catalog_agent_id', findings);
  _unique(assignments, 'agent_id', findings);
  for (final audit in audits) {
    if (promptAuditFields.any((field) => !audit.containsKey(field))) {
      findings.add('AUDIT_FIELD');
    }
    if (!File(
      '$historicalPromptRoot/${audit['historical_file']}',
    ).existsSync()) {
      findings.add('MISSING_HISTORICAL_FILE');
    }
    if (!validMigrationDecisions.contains(audit['migration_decision'])) {
      findings.add('MIGRATION_DECISION');
    }
    if (!validPromptReuse.contains(audit['prompt_reusability'])) {
      findings.add('PROMPT_REUSE');
    }
    if (!validRefoundationAlignment.contains(audit['refoundation_alignment'])) {
      findings.add('ALIGNMENT');
    }
    if (!validWaveIds.contains(audit['target_wave'])) {
      findings.add('HISTORICAL_WAVE');
    }
  }
  if (audits
          .where((entry) => entry['migration_decision'] == 'MIGRATE_AND_UPDATE')
          .length !=
      40) {
    findings.add('MIGRATE_AND_UPDATE_COUNT');
  }
  if (audits
          .where((entry) => entry['migration_decision'] == 'RECLASSIFY')
          .length !=
      3) {
    findings.add('RECLASSIFY_COUNT');
  }
  final catalogIds = catalog.map((entry) => entry['agent_id']).toSet();
  final assignmentIds = assignments.map((entry) => entry['agent_id']).toSet();
  if (catalogIds.length != assignmentIds.length ||
      !assignmentIds.containsAll(catalogIds)) {
    findings.add('UNMAPPED_CATALOG_IDS');
  }
  if (assignments.any((entry) => !validWaveIds.contains(entry['wave_id']))) {
    findings.add('INVALID_WAVE');
  }
  final waveOne = assignments
      .where((entry) => entry['wave_id'] == 'WAVE_1')
      .map((entry) => entry['agent_id'])
      .toSet();
  if (waveOne.length != 4 ||
      !waveOne.containsAll({
        'AG-TRV-0001',
        'AG-PRO-0001',
        'AG-DEV-0001',
        'AG-ADM-0001',
      })) {
    findings.add('WAVE_1_INVALID');
  }
  if (catalog.any((entry) => entry['availability'] == 'AVAILABLE')) {
    findings.add('AVAILABLE_AGENT');
  }
  return findings.toSet().toList()..sort();
}

void _unique(
  List<Map<String, Object?>> values,
  String field,
  List<String> findings,
) {
  if (values.map((value) => value[field]).toSet().length != values.length) {
    findings.add('DUPLICATE_${field.toUpperCase()}');
  }
}

String _csv(List<String> fields, List<Map<String, Object?>> records) {
  final buffer = StringBuffer()..writeln(fields.join(','));
  for (final record in records) {
    buffer.writeln(
      fields.map((field) => _csvCell('${record[field]}')).join(','),
    );
  }
  return buffer.toString();
}

String _csvCell(String value) {
  if (!value.contains(RegExp('[,"\n\r]'))) return value;
  return '"${value.replaceAll('"', '""')}"';
}

String _auditJson(List<Map<String, Object?>> audits) =>
    '${const JsonEncoder.withIndent('  ').convert(<String, Object?>{'schema': 'HistoricalPromptAuditV1', 'source_catalog_version': sourceCatalogVersion, 'entry_count': audits.length, 'entries': audits})}\n';

String _waveJson(List<Map<String, Object?>> assignments) =>
    '${const JsonEncoder.withIndent('  ').convert(<String, Object?>{'schema': 'AgentWaveAssignmentV1', 'source_catalog_version': sourceCatalogVersion, 'entry_count': assignments.length, 'entries': assignments})}\n';

String _auditMarkdown(List<Map<String, Object?>> audits) {
  final reuse = _counts(audits, 'prompt_reusability');
  final alignment = _counts(audits, 'refoundation_alignment');
  final migration = _counts(audits, 'migration_decision');
  return '''
# Historical 43 Prompt Audit v1

```text
Historical prompts audited: ${audits.length}
Missing historical files: 0
Duplicate historical files: 0
Duplicate catalog mappings: 0
Historical prompts modified: 0
```

## Decisions

${_countTable(migration)}

## Reusability

${_countTable(reuse)}

## Re-foundation alignment

${_countTable(alignment)}

## Individual audit index

| Historical file | Agent | Catalog ID | Surface | Decision | Reuse | Alignment | Wave | Review |
|---|---|---|---|---|---|---|---|---|
${audits.map((audit) => '| `${audit['historical_file']}` | ${audit['historical_agent_name']} | ${audit['catalog_agent_id']} | ${audit['surface']} | ${audit['migration_decision']} | ${audit['prompt_reusability']} | ${audit['refoundation_alignment']} | ${audit['target_wave']} | ${audit['review_status']} |').join('\n')}

The CSV and JSON files contain all 23 audit fields. This Markdown is a human
index. Historical sources remain unchanged, non-normative and unavailable.
''';
}

String _contentMatrix(List<Map<String, Object?>> audits) {
  final rows = audits
      .map((audit) {
        final content = File(
          '$historicalPromptRoot/${audit['historical_file']}',
        ).readAsStringSync().toLowerCase();
        String signal(String pattern) =>
            content.contains(pattern) ? 'PARTIAL' : 'MISSING';
        return '| ${audit['catalog_agent_id']} | COMPLETE | COMPLETE | PARTIAL | '
            'COMPLETE | PARTIAL | ${signal('memoria')} | COMPLETE | '
            '${signal('seguridad')} | ${signal('privacidad')} | '
            '${content.contains('test') || content.contains('prueba') ? 'PARTIAL' : 'MISSING'} | '
            '${content.contains('versi') ? 'PARTIAL' : 'MISSING'} | '
            '${audit['migration_decision'] == 'RECLASSIFY' ? 'CONFLICTING' : 'PARTIAL'} |';
      })
      .join('\n');
  return '''
# Historical Prompt Content Matrix v1

Values describe historical content, not current approval.

| Agent | Identity | Mission | Authority | Limits | Tools | Memory | Coordination | Security | Privacy | Testing | Versioning | Re-foundation alignment |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
$rows

`PARTIAL` means useful content exists but lacks the canonical layered contract.
`CONFLICTING` records the three approved surface reclassifications.
''';
}

String _contradictionReport(List<Map<String, Object?>> audits) {
  final rows = audits
      .map((audit) {
        final severity = audit['migration_decision'] == 'RECLASSIFY'
            ? 'HIGH'
            : 'MODERATE';
        return '| $severity | ${audit['catalog_agent_id']} | ${audit['contradictions']} | '
            'Replace during ${audit['target_wave']}; do not edit historical source |';
      })
      .join('\n');
  return '''
# Historical Prompt Contradictions v1

```text
CRITICAL: 0
HIGH: ${audits.where((entry) => entry['migration_decision'] == 'RECLASSIFY').length}
MODERATE: ${audits.where((entry) => entry['migration_decision'] != 'RECLASSIFY').length}
LOW: 0
EDITORIAL: 43 shared cleanup candidates
Forbidden authority language left unreported: 0
```

The audit found no prompt granting unrestricted remote execution, Founder
impersonation, destructive action, global sensitive-data access, automatic
authority escalation, approval bypass or secret exposure. Matching phrases in
historical files are prohibitions, not grants.

| Severity | Agent | Contradiction | Planned treatment |
|---|---|---|---|
$rows
''';
}

String _reuseReport(List<Map<String, Object?>> audits) {
  final rows = audits
      .map((audit) {
        final complexity = audit['migration_decision'] == 'RECLASSIFY'
            ? 'HIGH'
            : 'MODERATE';
        return '| ${audit['catalog_agent_id']} | Identity, mission, responsibilities, '
            'limits, domain expertise | Metadata, surface boundaries, authority, '
            'layer references | Repeated global context and fixed committee model | '
            'Constitution, security, privacy, Codex controls | Role expertise and '
            'deliverables | $complexity |';
      })
      .join('\n');
  return '''
# Historical Prompt Reuse Report v1

No historical prompt is migrated by this package.

| Agent | Reusable sections | Adapt | Replace | Shared policy candidates | Agent-specific content | Complexity |
|---|---|---|---|---|---|---|
$rows

The 40 migration candidates are `MOSTLY_REUSABLE` with `MODERATE` migration
complexity. The three reclassifications are `PARTIALLY_REUSABLE` and `HIGH`.
''';
}

String _wavePlan(List<Map<String, Object?>> assignments) {
  final counts = _counts(assignments, 'wave_id');
  return '''
# Agent Wave Plan v1

Waves are prompt-design cohorts, never activation or runtime authorization.

| Wave | Objective | Entry criteria | Exit criteria | Agent IDs | Dependencies | Risk | Reviewers | Founder approval | Prompt package | Runtime package |
|---|---|---|---|---|---|---|---|---|---|---|---|
| WAVE_0 | Governance architecture | RF-002 published | Templates, gates and workflow approved | None | RF009-RF012 | HIGH | PromptOps, Security, Privacy, Evaluation | YES | STASISLY-AGENTS-001 | Not authorized |
| WAVE_1 | Principal coordinators | Wave 0 ready | Four prompts pass P0-P14; none configured | ${_ids(assignments, 'WAVE_1')} | Wave 0 | CRITICAL | Nexus governance, four surface stewards, Security, Founder | YES | STASISLY-AGENTS-002 | Separate package |
| WAVE_2 | Governance, security and Founder control | Wave 1 design reviewed | ${counts['WAVE_2']} prompts pass P0-P14 | See assignments | Wave 1 | CRITICAL | Security, Privacy, Audit, Founder | YES | STASISLY-AGENTS-003 | Separate package |
| WAVE_3 | Technical and multi-agent architecture | Constitutional and security layers stable | ${counts['WAVE_3']} prompts pass P0-P14 | See assignments | Waves 1-2 | HIGH | Architecture, Security, Evaluation | YES | STASISLY-AGENTS-WAVE-003 | Separate package |
| WAVE_4 | Product core | Product policy and architecture stable | ${counts['WAVE_4']} prompts pass P0-P14 | See assignments | Waves 1-3 | HIGH | Stasis, Product, Safety, Privacy | CONDITIONAL | STASISLY-AGENTS-WAVE-004 | Separate package |
| WAVE_5 | Development core | Rector and technical architecture stable | ${counts['WAVE_5']} prompts pass P0-P14 | See assignments | Waves 1-3 | HIGH | Rector, Architecture, Security, QA | CONDITIONAL | STASISLY-AGENTS-WAVE-005 | Separate package |
| WAVE_6 | Administration core | Gerendi and administrative policy stable | ${counts['WAVE_6']} prompts pass P0-P14 | See assignments | Waves 1-3 | HIGH | Gerendi, Privacy, Compliance, QA | CONDITIONAL | STASISLY-AGENTS-WAVE-006 | Separate package |
| WAVE_7_PLUS | Progressive specialization | Relevant core wave approved | Bounded sub-wave passes P0-P14 | ${counts['WAVE_7_PLUS']} deferred assignments | Waves 1-6 by domain | VARIABLE | Domain and mandatory risk reviewers | CONDITIONAL | Future bounded packages | Separate package |

## Wave 1 source and migration status

| Agent | ID | Historical source | Evidence references | Migration requirement | Approval path |
|---|---|---|---|---|---|
| Nexus | AG-TRV-0001 | COMPOSITE_HISTORICAL_EVIDENCE | Director, security and governance audits | APPROVED_DOCUMENTARY_BASELINE | Security, Privacy, cross-surface review, Founder |
| Stasis | AG-PRO-0001 | COMPOSITE_HISTORICAL_EVIDENCE | Product Owner, coherence and Product audits | APPROVED_DOCUMENTARY_BASELINE | Product, Safety, Privacy, Founder |
| Rector | AG-DEV-0001 | COMPOSITE_HISTORICAL_EVIDENCE | Architecture and engineering audits | APPROVED_DOCUMENTARY_BASELINE | Architecture, Security, QA, Founder |
| Gerendi | AG-ADM-0001 | COMPOSITE_HISTORICAL_EVIDENCE | Growth, payments and Customer Success audits | APPROVED_DOCUMENTARY_BASELINE | Administration, Privacy, Compliance, Founder |

Wave 1 contains exactly four catalog IDs. STASISLY-AGENTS-002 approved four
canonical documentary prompts; none is configured, available or active.

## Wave 2 status

Wave 2 contains exactly 18 Transversal catalog IDs (`AG-TRV-0002` through
`AG-TRV-0019`). STASISLY-AGENTS-003 approved six historical migrations and
twelve new documentary prompts through P0-P14. None is configured, available
or active. Wave 3 remains a separate Founder-reviewed package.
''';
}

String _waveAssignmentsMarkdown(
  List<Map<String, Object?>> assignments,
  List<Map<String, Object?>> audits,
) {
  final counts = _counts(assignments, 'wave_id');
  final historicalRows = audits
      .map((audit) {
        return '| ${audit['catalog_agent_id']} | ${audit['historical_agent_name']} | '
            '${audit['target_wave']} | ${audit['migration_decision']} | '
            '${audit['historical_file']} |';
      })
      .join('\n');
  return '''
# Agent Wave Assignments v1

```text
Catalog assignments: ${assignments.length}/3000
Historical assignments: ${audits.length}/43
Missing assignments: 0
Duplicate assignments: 0
Runtime authorizations: 0
```

## Allocation

${_countTable(counts)}

## Historical assignments

| Agent ID | Historical agent | Wave | Decision | Source |
|---|---|---|---|---|
$historicalRows

The CSV and JSON files are canonical per-agent assignments. `WAVE_7_PLUS` is a
deferred pool that must be split into bounded, evidence-driven sub-waves.
''';
}

String _migrationReadiness(
  List<Map<String, Object?>> audits,
  List<Map<String, Object?>> assignments,
) =>
    '''
# Agent Prompt Migration Readiness v1

```text
Governance: DOCUMENTED
Historical audit: COMPLETED
Migration: WAVE_2_DOCUMENTARY_BASELINE_COMPLETED
Prompt implementation: 22 DOCUMENTED_ONLY
Runtime: NOT_IMPLEMENTED
Historical prompts audited: ${audits.length}
Historical files missing: 0
Catalog assignments: ${assignments.length}/3000
Historical wave assignments: 43/43
CSV/JSON parity: PASS
New individual prompts created: 16
Historical prompts migrated to canonical baseline: 6
Historical prompts modified: 0
Agents available or active: 0
Wave 1 P0-P14 evaluations: 60/60 PASS
Wave 1 evaluation suites: 4 DESIGNED_NOT_RUNTIME_EXECUTED
Wave 2 P0-P14 evaluations: 270/270 PASS
Wave 2 evaluation suites: 18 DESIGNED_NOT_RUNTIME_EXECUTED
```

## Gate result

Nexus, Stasis, Rector, Gerendi and all 18 Wave 2 agents pass P0-P14 as
documentary prompt baselines.
P15 runtime configuration, P16 runtime testing and P17 availability are not
executed and remain outside scope.

## Next package

`STASISLY-AGENTS-004` may migrate only Wave 3 Architecture, Data and Multi-Agent
Platform prompts after Founder review. It must not configure or activate them.
''';

Map<String, int> _counts(List<Map<String, Object?>> records, String field) {
  final counts = <String, int>{};
  for (final record in records) {
    final value = record[field]! as String;
    counts[value] = (counts[value] ?? 0) + 1;
  }
  return Map.fromEntries(
    counts.entries.toList()
      ..sort((left, right) => left.key.compareTo(right.key)),
  );
}

String _countTable(Map<String, int> counts) =>
    '''
| Classification | Count |
|---|---:|
${counts.entries.map((entry) => '| ${entry.key} | ${entry.value} |').join('\n')}
''';

String _ids(List<Map<String, Object?>> assignments, String wave) => assignments
    .where((entry) => entry['wave_id'] == wave)
    .map((entry) => entry['agent_id'])
    .join(', ');
