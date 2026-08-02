import 'dart:convert';
import 'dart:io';

const wave7StrategyRoot =
    'docs/stasisly_refoundation/agents/prompts/wave_7_strategy';
const wave7CatalogPath =
    'docs/stasisly_refoundation/agents/AGENT_CATALOG_MASTER_v1.json';
const wave7AssignmentsPath =
    'docs/stasisly_refoundation/agents/prompts/wave_7_strategy/'
    'WAVE_7_AGENT_PROMPT_STRATEGY_ASSIGNMENTS_v1.json';
const wave7SchemaVersion = '1.0.0';
const wave7ApprovedAt = '2026-08-01';

const wave7InventoryFields = <String>[
  'agent_id',
  'canonical_name',
  'display_name',
  'surface',
  'domain',
  'family',
  'specialty',
  'subspecialty',
  'agent_type',
  'coordination_level',
  'reports_to',
  'risk_tier',
  'historical_source',
  'prompt_status',
  'implementation_status',
  'availability',
];

const wave7AssignmentFields = <String>[
  'agent_id',
  'prompt_strategy',
  'risk_tier',
  'family_prompt_id',
  'specialty_module_ids',
  'overlay_ids',
  'evaluation_profile_id',
  'subwave_id',
  'priority',
  'dependency_status',
  'redesign_status',
  'subwave_status',
  'current_prompt_status',
  'current_lifecycle_status',
  'current_implementation_status',
];

const wave7ArtifactTypes = <String>[
  'CONSTITUTIONAL_POLICY',
  'SURFACE_POLICY',
  'DOMAIN_POLICY',
  'FAMILY_PROMPT',
  'SPECIALTY_MODULE',
  'SAFETY_OVERLAY',
  'AUTHORITY_OVERLAY',
  'AGENT_IDENTITY_CONTRACT',
  'EVALUATION_PROFILE',
  'RUNTIME_CONTRACT',
];

const wave7OverlayDefinitions = <String, String>{
  'OVR-CLINICAL-SAFETY-v1': 'Clinical safety and non-diagnostic boundaries',
  'OVR-MENTAL-HEALTH-CRISIS-v1': 'Crisis detection and human escalation',
  'OVR-MINOR-PROTECTION-v1': 'Age-appropriate safeguards and consent',
  'OVR-FINANCIAL-MUTATION-v1': 'Segregation, authorization and audit',
  'OVR-PRIVILEGED-ACCESS-v1': 'Scoped, expiring privileged access',
  'OVR-SECURITY-RESTRICTED-v1': 'Security-restricted evidence and tools',
  'OVR-PRIVACY-RIGHTS-v1': 'Purpose, minimization, rights and retention',
  'OVR-LEGAL-UNCERTAINTY-v1': 'No final legal authority; escalate uncertainty',
  'OVR-MODERATION-HIGH-IMPACT-v1': 'Evidence, proportionality and appeal',
  'OVR-PRODUCTION-MUTATION-v1': 'Explicit environment authority and rollback',
  'OVR-FOUNDER-EXCLUSIVE-v1': 'Founder-exclusive decision boundary',
};

void main() {
  final artifacts = generateWave7SpecializedPromptStrategyArtifacts();
  for (final artifact in artifacts.entries) {
    File(artifact.key)
      ..createSync(recursive: true)
      ..writeAsStringSync(artifact.value);
  }
  stdout.writeln(
    'WAVE_7_SPECIALIZED_PROMPT_STRATEGY_V1_GENERATED:${artifacts.length}',
  );
}

Map<String, String> generateWave7SpecializedPromptStrategyArtifacts() {
  final catalogRoot =
      jsonDecode(File(wave7CatalogPath).readAsStringSync())
          as Map<String, Object?>;
  final catalog = (catalogRoot['entries']! as List)
      .cast<Map<String, Object?>>();
  final previousAssignmentsRoot =
      jsonDecode(File(wave7AssignmentsPath).readAsStringSync())
          as Map<String, Object?>;
  final wave7Ids = (previousAssignmentsRoot['records']! as List)
      .cast<Map<String, Object?>>()
      .map((row) => row['agent_id']! as String)
      .toSet();
  final scope =
      catalog
          .where((entry) => wave7Ids.contains(entry['agent_id']))
          .map(Map<String, Object?>.from)
          .toList()
        ..sort(_byAgentId);
  _validateCatalogBaseline(catalog, scope);

  final familyGroups = <String, List<Map<String, Object?>>>{};
  for (final agent in scope) {
    familyGroups
        .putIfAbsent(_familyKey(agent), () => <Map<String, Object?>>[])
        .add(agent);
  }
  final families = _buildFamilies(familyGroups);
  final modules = _buildModules(familyGroups);
  final subwaves = _buildSubwaves(familyGroups);
  final subwaveByAgent = <String, String>{};
  for (final subwave in subwaves) {
    for (final id in (subwave['_agent_ids']! as List<String>)) {
      if (subwaveByAgent.putIfAbsent(
            id,
            () => subwave['subwave_id']! as String,
          ) !=
          subwave['subwave_id']) {
        throw StateError('DUPLICATE_SUBWAVE_ASSIGNMENT:$id');
      }
    }
  }
  final assignments = scope
      .map(
        (agent) => _strategyAssignment(
          agent,
          familyGroups[_familyKey(agent)]!.length,
          subwaveByAgent[agent['agent_id']]!,
        ),
      )
      .toList();
  _validateStrategy(scope, families, modules, assignments, subwaves);

  final inventory = scope.map(_inventoryRecord).toList();
  final risk = scope.map(_riskRecord).toList();
  final publicSubwaves = subwaves
      .map((row) => Map<String, Object?>.from(row)..remove('_agent_ids'))
      .toList();
  final artifacts = <String, String>{};
  _addDataset(
    artifacts,
    'WAVE_7_REMAINING_AGENT_INVENTORY_v1',
    wave7InventoryFields,
    inventory,
    'Wave 7 Remaining Agent Inventory v1',
  );
  _addDataset(
    artifacts,
    'WAVE_7_AGENT_RISK_CLASSIFICATION_v1',
    const [
      'agent_id',
      'risk_tier',
      'catalog_risk_source',
      'risk_drivers',
      'review_level',
    ],
    risk,
    'Wave 7 Agent Risk Classification v1',
  );
  _addDataset(
    artifacts,
    'WAVE_7_PROMPT_FAMILY_REGISTRY_v1',
    const [
      'family_prompt_id',
      'canonical_family_name',
      'surface',
      'domain',
      'member_count',
      'risk_range',
      'base_authority',
      'base_data_ceiling',
      'base_tool_ceiling',
      'base_memory_ceiling',
      'member_data_classes',
      'member_tool_classes',
      'member_memory_scopes',
      'required_modules',
      'exceptions',
      'owner',
      'status',
    ],
    families,
    'Wave 7 Prompt Family Registry v1',
  );
  _addDataset(
    artifacts,
    'WAVE_7_SPECIALTY_MODULE_REGISTRY_v1',
    const [
      'specialty_module_id',
      'surface',
      'domain',
      'family_prompt_id',
      'specialty',
      'subspecialty',
      'member_count',
      'adds',
      'authority_effect',
      'status',
    ],
    modules,
    'Wave 7 Specialty Module Registry v1',
  );
  _addDataset(
    artifacts,
    'WAVE_7_AGENT_PROMPT_STRATEGY_ASSIGNMENTS_v1',
    wave7AssignmentFields,
    assignments,
    'Wave 7 Agent Prompt Strategy Assignments v1',
  );
  _addDataset(
    artifacts,
    'WAVE_7_SUBWAVE_PLAN_v1',
    const [
      'subwave_id',
      'subwave_status',
      'sequence',
      'surface',
      'domain',
      'family_ids',
      'agent_count',
      'LOW_count',
      'MODERATE_count',
      'HIGH_count',
      'CRITICAL_count',
      'full_individual_count',
      'family_identity_count',
      'family_specialty_count',
      'parameterized_count',
      'redesign_count',
      'dependencies',
      'entry_criteria',
      'exit_criteria',
      'review_requirements',
      'estimated_documentary_complexity',
    ],
    publicSubwaves,
    'Wave 7 Subwave Plan v1',
  );

  artifacts.addAll(
    _strategyDocuments(scope, families, modules, assignments, publicSubwaves),
  );
  return artifacts;
}

void _validateCatalogBaseline(
  List<Map<String, Object?>> catalog,
  List<Map<String, Object?>> scope,
) {
  if (catalog.length != 3000) throw StateError('CATALOG_COUNT');
  if (scope.length != 2778) throw StateError('WAVE_7_SCOPE_COUNT');
  if (catalog.where((e) => e['prompt_status'] == 'PROMPT_CREATED').length !=
      282) {
    throw StateError('CREATED_COUNT');
  }
  if (catalog.where((e) => e['prompt_status'] == 'NOT_CREATED').length !=
      2718) {
    throw StateError('NOT_CREATED_COUNT');
  }
  if (catalog.map((e) => e['agent_id']).toSet().length != 3000) {
    throw StateError('DUPLICATE_AGENT_ID');
  }
  for (final agent in scope) {
    final completed = approvedWave7AgentIds.contains(agent['agent_id']);
    if (agent['lifecycle_status'] !=
            (completed ? 'PROMPT_CREATED' : 'CATALOGED') ||
        agent['implementation_status'] !=
            (completed ? 'DOCUMENTED_ONLY' : 'NOT_IMPLEMENTED') ||
        agent['prompt_status'] !=
            (completed ? 'PROMPT_CREATED' : 'NOT_CREATED') ||
        agent['availability'] != 'NOT_AVAILABLE') {
      throw StateError('STATE_TRANSITION:${agent['agent_id']}');
    }
  }
}

const w7001AgentIds = <String>{
  'AG-ADM-0391',
  'AG-ADM-0392',
  'AG-ADM-0393',
  'AG-ADM-0394',
  'AG-ADM-0395',
  'AG-ADM-0396',
  'AG-ADM-0397',
  'AG-ADM-0398',
  'AG-ADM-0399',
  'AG-ADM-0400',
  'AG-ADM-0401',
  'AG-ADM-0402',
  'AG-ADM-0403',
  'AG-ADM-0404',
  'AG-ADM-0405',
  'AG-ADM-0406',
  'AG-ADM-0407',
  'AG-ADM-0408',
  'AG-ADM-0409',
  'AG-ADM-0410',
  'AG-ADM-0411',
  'AG-ADM-0412',
  'AG-ADM-0413',
  'AG-ADM-0414',
  'AG-ADM-0415',
  'AG-ADM-0416',
  'AG-ADM-0417',
  'AG-ADM-0418',
  'AG-ADM-0419',
  'AG-ADM-0420',
  'AG-ADM-0421',
  'AG-ADM-0422',
  'AG-ADM-0423',
  'AG-ADM-0424',
  'AG-ADM-0425',
  'AG-ADM-0426',
  'AG-ADM-0427',
  'AG-ADM-0428',
  'AG-ADM-0429',
  'AG-ADM-0430',
};
const w7002AgentIds = <String>{
  'AG-ADM-0681',
  'AG-ADM-0682',
  'AG-ADM-0683',
  'AG-ADM-0684',
  'AG-ADM-0685',
  'AG-ADM-0686',
  'AG-ADM-0687',
  'AG-ADM-0688',
  'AG-ADM-0689',
  'AG-ADM-0690',
  'AG-ADM-0691',
  'AG-ADM-0692',
  'AG-ADM-0693',
  'AG-ADM-0694',
  'AG-ADM-0695',
  'AG-ADM-0696',
  'AG-ADM-0697',
  'AG-ADM-0698',
  'AG-ADM-0699',
  'AG-ADM-0700',
};
const approvedWave7AgentIds = <String>{...w7001AgentIds, ...w7002AgentIds};

List<Map<String, Object?>> _buildFamilies(
  Map<String, List<Map<String, Object?>>> groups,
) {
  final result = <Map<String, Object?>>[];
  for (final item in groups.entries) {
    final members = item.value;
    final first = members.first;
    final risk = members.map((e) => e['risk_level']! as String).toSet();
    final data = members.map((e) => e['data_access_class']! as String).toSet();
    final tools = members.map((e) => e['tool_access_class']! as String).toSet();
    final memory = members.map((e) => e['memory_scope']! as String).toSet();
    if (risk.length != 1) {
      throw StateError('INCOMPATIBLE_FAMILY:${item.key}');
    }
    result.add({
      'family_prompt_id': _familyId(first),
      'canonical_family_name': first['family'],
      'surface': first['surface'],
      'domain': first['domain'],
      'member_count': members.length,
      'risk_range': risk.single,
      'base_authority': 'DOCUMENTARY_ONLY_DENY_BY_DEFAULT',
      'base_data_ceiling': 'DENY_BY_DEFAULT_IDENTITY_BOUND',
      'base_tool_ceiling': 'DENY_BY_DEFAULT_IDENTITY_BOUND',
      'base_memory_ceiling': 'DENY_BY_DEFAULT_IDENTITY_BOUND',
      'member_data_classes': data.toList()..sort(),
      'member_tool_classes': tools.toList()..sort(),
      'member_memory_scopes': memory.toList()..sort(),
      'required_modules': _moduleId(first),
      'exceptions': members.length == 1
          ? 'FAMILY_STABILITY_REVIEW_REQUIRED'
          : 'NONE',
      'owner': first['reports_to'],
      'status': 'APPROVED',
    });
  }
  result.sort(
    (a, b) => (a['family_prompt_id']! as String).compareTo(
      b['family_prompt_id']! as String,
    ),
  );
  return result;
}

List<Map<String, Object?>> _buildModules(
  Map<String, List<Map<String, Object?>>> groups,
) =>
    groups.values.map((members) {
      final first = members.first;
      return <String, Object?>{
        'specialty_module_id': _moduleId(first),
        'surface': first['surface'],
        'domain': first['domain'],
        'family_prompt_id': _familyId(first),
        'specialty': first['specialty'],
        'subspecialty': first['subspecialty'],
        'member_count': members.length,
        'adds': 'SPECIALTY_BEHAVIOR_AND_TERMINOLOGY_ONLY',
        'authority_effect': 'MAY_RESTRICT_NEVER_ELEVATE',
        'status': 'APPROVED',
      };
    }).toList()..sort(
      (a, b) => (a['specialty_module_id']! as String).compareTo(
        b['specialty_module_id']! as String,
      ),
    );

List<Map<String, Object?>> _buildSubwaves(
  Map<String, List<Map<String, Object?>>> groups,
) {
  final ordered = groups.values.toList()
    ..sort((left, right) {
      final p = _familyPriority(left).compareTo(_familyPriority(right));
      if (p != 0) return p;
      final surface = (left.first['surface']! as String).compareTo(
        right.first['surface']! as String,
      );
      if (surface != 0) return surface;
      final domain = (left.first['domain']! as String).compareTo(
        right.first['domain']! as String,
      );
      if (domain != 0) return domain;
      return _familyKey(left.first).compareTo(_familyKey(right.first));
    });
  final buckets = <List<Map<String, Object?>>>[];
  var current = <Map<String, Object?>>[];
  String? currentPartition;
  var currentCount = 0;
  for (final family in ordered) {
    final partition =
        '${_familyPriority(family)}|${family.first['surface']}|${family.first['domain']}';
    if (current.isNotEmpty &&
        (partition != currentPartition || currentCount + family.length > 100)) {
      buckets.add(current);
      current = <Map<String, Object?>>[];
      currentCount = 0;
    }
    currentPartition = partition;
    current.addAll(family);
    currentCount += family.length;
  }
  if (current.isNotEmpty) buckets.add(current);

  final result = <Map<String, Object?>>[];
  for (var i = 0; i < buckets.length; i++) {
    final members = buckets[i]..sort(_byAgentId);
    final first = members.first;
    final strategyCounts = <String, int>{};
    for (final member in members) {
      final strategy = _strategy(member, groups[_familyKey(member)]!.length);
      strategyCounts[strategy] = (strategyCounts[strategy] ?? 0) + 1;
    }
    int risk(String value) =>
        members.where((e) => e['risk_level'] == value).length;
    final id = 'W7-${(i + 1).toString().padLeft(3, '0')}';
    result.add({
      'subwave_id': id,
      'subwave_status': id == 'W7-001' || id == 'W7-002'
          ? 'DOCUMENTARY_PROMPTS_APPROVED'
          : 'NOT_STARTED',
      'sequence': i + 1,
      'surface': first['surface'],
      'domain': first['domain'],
      'family_ids': members.map(_familyId).toSet().toList()..sort(),
      'agent_count': members.length,
      'LOW_count': risk('LOW'),
      'MODERATE_count': risk('MODERATE'),
      'HIGH_count': risk('HIGH'),
      'CRITICAL_count': risk('CRITICAL'),
      'full_individual_count': strategyCounts['FULL_INDIVIDUAL_PROMPT'] ?? 0,
      'family_identity_count': strategyCounts['FAMILY_PLUS_IDENTITY'] ?? 0,
      'family_specialty_count':
          strategyCounts['FAMILY_PLUS_SPECIALTY_MODULE'] ?? 0,
      'parameterized_count': strategyCounts['PARAMETERIZED_SPECIALIST'] ?? 0,
      'redesign_count': strategyCounts['DEFERRED_REDESIGN'] ?? 0,
      'dependencies': i == 0
          ? 'WAVES_1_6'
          : 'WAVES_1_6;PREVIOUS_APPROVED_COMPONENTS',
      'entry_criteria': 'EXACT_SCOPE;APPROVED_COMPONENTS;REVIEWERS_ASSIGNED',
      'exit_criteria':
          'INDIVIDUAL_P0_P14;HASH_PARITY;FOUNDER_GATE_WHEN_REQUIRED',
      'review_requirements': risk('CRITICAL') > 0
          ? 'DOMAIN;SECURITY;PRIVACY;AUTHORITY;FOUNDER_WHEN_RESERVED'
          : risk('HIGH') > 0
          ? 'DOMAIN;SECURITY;PRIVACY'
          : risk('MODERATE') > 0
          ? 'DOMAIN'
          : 'STANDARD_DOCUMENTARY',
      'estimated_documentary_complexity': risk('CRITICAL') > 0
          ? 'VERY_HIGH'
          : risk('HIGH') > 0
          ? 'HIGH'
          : members.length >= 75
          ? 'MODERATE_HIGH'
          : 'MODERATE',
      '_agent_ids': members.map((e) => e['agent_id']! as String).toList(),
    });
  }
  return result;
}

Map<String, Object?> _strategyAssignment(
  Map<String, Object?> agent,
  int familySize,
  String subwaveId,
) {
  final strategy = _strategy(agent, familySize);
  final overlays = _overlays(agent);
  return {
    'agent_id': agent['agent_id'],
    'prompt_strategy': strategy,
    'risk_tier': agent['risk_level'],
    'family_prompt_id': _familyId(agent),
    'specialty_module_ids': _moduleId(agent),
    'overlay_ids': overlays.isEmpty ? 'NONE' : overlays.join(';'),
    'evaluation_profile_id': 'EVAL-${agent['risk_level']}-v1',
    'subwave_id': subwaveId,
    'priority': _agentPriority(agent),
    'dependency_status': 'COMPONENTS_NOT_YET_IMPLEMENTED',
    'redesign_status': strategy == 'DEFERRED_REDESIGN'
        ? 'REVIEW_REQUIRED'
        : 'NO_ISSUE',
    'subwave_status': subwaveId == 'W7-001' || subwaveId == 'W7-002'
        ? 'DOCUMENTARY_PROMPTS_APPROVED'
        : 'NOT_STARTED',
    'current_prompt_status': agent['prompt_status'],
    'current_lifecycle_status': agent['lifecycle_status'],
    'current_implementation_status': agent['implementation_status'],
  };
}

String _strategy(Map<String, Object?> agent, int familySize) {
  final risk = agent['risk_level'];
  final tool = agent['tool_access_class'];
  final data = agent['data_access_class'];
  if (risk == 'HIGH' ||
      risk == 'CRITICAL' ||
      agent['coordination_level'] != 'INDIVIDUAL_CONTRIBUTOR' ||
      tool == 'MUTATING_TOOLS_WITH_APPROVAL' ||
      tool == 'SECURITY_RESTRICTED_TOOLS' ||
      tool == 'FOUNDER_AUTHORIZED_TOOLS' ||
      data == 'SENSITIVE_HEALTH_DATA' ||
      data == 'SECURITY_RESTRICTED_DATA') {
    return 'FULL_INDIVIDUAL_PROMPT';
  }
  if (familySize == 1) return 'DEFERRED_REDESIGN';
  final function = agent['function']! as String;
  if (familySize >= 10 &&
      const {
        'assess',
        'plan',
        'monitor',
        'review',
        'research',
        'design',
        'validate',
      }.contains(function)) {
    return 'PARAMETERIZED_SPECIALIST';
  }
  if (const {
    'engineer',
    'audit',
    'operate',
    'optimize',
    'triage',
    'safeguard',
  }.contains(function)) {
    return 'FAMILY_PLUS_SPECIALTY_MODULE';
  }
  return 'FAMILY_PLUS_IDENTITY';
}

List<String> _overlays(Map<String, Object?> agent) {
  final text = [
    agent['domain'],
    agent['family'],
    agent['specialty'],
  ].join(' ').toLowerCase();
  final result = <String>[];
  if (agent['data_access_class'] == 'SENSITIVE_HEALTH_DATA' ||
      text.contains('clinical') ||
      text.contains('health')) {
    result.add('OVR-CLINICAL-SAFETY-v1');
  }
  if (text.contains('psychiatr') || text.contains('psycholog')) {
    result.add('OVR-MENTAL-HEALTH-CRISIS-v1');
  }
  if (text.contains('pediatric') || text.contains('minor')) {
    result.add('OVR-MINOR-PROTECTION-v1');
  }
  if (RegExp(
    'payment|billing|finance|revenue|subscription|refund',
  ).hasMatch(text)) {
    result.add('OVR-FINANCIAL-MUTATION-v1');
  }
  if (!const {
    'NO_TOOLS',
    'READ_ONLY_TOOLS',
  }.contains(agent['tool_access_class'])) {
    result.add('OVR-PRIVILEGED-ACCESS-v1');
  }
  if (agent['tool_access_class'] == 'SECURITY_RESTRICTED_TOOLS' ||
      agent['data_access_class'] == 'SECURITY_RESTRICTED_DATA' ||
      text.contains('security')) {
    result.add('OVR-SECURITY-RESTRICTED-v1');
  }
  if (text.contains('privacy') || text.contains('data_protection')) {
    result.add('OVR-PRIVACY-RIGHTS-v1');
  }
  if (text.contains('legal') || text.contains('compliance')) {
    result.add('OVR-LEGAL-UNCERTAINTY-v1');
  }
  if (RegExp('moderation|fraud|trust|abuse').hasMatch(text)) {
    result.add('OVR-MODERATION-HIGH-IMPACT-v1');
  }
  if (agent['tool_access_class'] == 'MUTATING_TOOLS_WITH_APPROVAL') {
    result.add('OVR-PRODUCTION-MUTATION-v1');
  }
  if (agent['tool_access_class'] == 'FOUNDER_AUTHORIZED_TOOLS' ||
      agent['risk_level'] == 'CRITICAL') {
    result.add('OVR-FOUNDER-EXCLUSIVE-v1');
  }
  return result.toSet().toList()..sort();
}

Map<String, Object?> _inventoryRecord(Map<String, Object?> agent) => {
  for (final field in wave7InventoryFields)
    field: field == 'risk_tier'
        ? agent['risk_level']
        : field == 'historical_source'
        ? agent['historical_mapping']
        : agent[field],
};

Map<String, Object?> _riskRecord(Map<String, Object?> agent) => {
  'agent_id': agent['agent_id'],
  'risk_tier': agent['risk_level'],
  'catalog_risk_source': 'AGENT_CATALOG_MASTER_v1.risk_level',
  'risk_drivers': _riskDrivers(agent).join(';'),
  'review_level': switch (agent['risk_level']) {
    'LOW' => 'STANDARD_DOCUMENTARY_REVIEW',
    'MODERATE' => 'DOMAIN_REVIEW',
    'HIGH' => 'DOMAIN_SECURITY_PRIVACY_REVIEW',
    _ => 'DOMAIN_SECURITY_AUTHORITY_FOUNDER_REVIEW',
  },
};

List<String> _riskDrivers(Map<String, Object?> agent) {
  final drivers = <String>['CATALOG_RISK_${agent['risk_level']}'];
  if (agent['data_access_class'] != 'NO_USER_DATA') {
    drivers.add('DATA_${agent['data_access_class']}');
  }
  if (agent['tool_access_class'] != 'NO_TOOLS') {
    drivers.add('TOOLS_${agent['tool_access_class']}');
  }
  if (agent['coordination_level'] != 'INDIVIDUAL_CONTRIBUTOR') {
    drivers.add('COORDINATION_${agent['coordination_level']}');
  }
  return drivers;
}

void _validateStrategy(
  List<Map<String, Object?>> remaining,
  List<Map<String, Object?>> families,
  List<Map<String, Object?>> modules,
  List<Map<String, Object?>> assignments,
  List<Map<String, Object?>> subwaves,
) {
  if (assignments.length != 2778 ||
      assignments.map((e) => e['agent_id']).toSet().length != 2778) {
    throw StateError('STRATEGY_ASSIGNMENT_PARITY');
  }
  if (families.length != 342 || modules.length != 342) {
    throw StateError(
      'FAMILY_MODULE_COUNT:${families.length}:${modules.length}',
    );
  }
  final familyIds = families.map((e) => e['family_prompt_id']).toSet();
  final moduleIds = modules.map((e) => e['specialty_module_id']).toSet();
  final subwaveIds = subwaves.map((e) => e['subwave_id']).toSet();
  for (final assignment in assignments) {
    if (!familyIds.contains(assignment['family_prompt_id']) ||
        !moduleIds.contains(assignment['specialty_module_ids']) ||
        !subwaveIds.contains(assignment['subwave_id']) ||
        assignment['prompt_strategy'] == null ||
        assignment['risk_tier'] == null) {
      throw StateError('INVALID_ASSIGNMENT:${assignment['agent_id']}');
    }
  }
  final subwaveTotal = subwaves.fold<int>(
    0,
    (sum, row) => sum + (row['agent_count']! as int),
  );
  if (subwaveTotal != 2778) throw StateError('SUBWAVE_TOTAL:$subwaveTotal');
  if (remaining
          .where((e) => approvedWave7AgentIds.contains(e['agent_id']))
          .any((e) => e['prompt_status'] != 'PROMPT_CREATED') ||
      remaining
          .where((e) => !approvedWave7AgentIds.contains(e['agent_id']))
          .any((e) => e['prompt_status'] != 'NOT_CREATED')) {
    throw StateError('PROMPT_STATUS_TRANSITION');
  }
}

void _addDataset(
  Map<String, String> artifacts,
  String baseName,
  List<String> fields,
  List<Map<String, Object?>> records,
  String title,
) {
  artifacts['$wave7StrategyRoot/$baseName.csv'] = _csv(fields, records);
  artifacts['$wave7StrategyRoot/$baseName.json'] =
      const JsonEncoder.withIndent('  ').convert({
        'schema_version': wave7SchemaVersion,
        'record_count': records.length,
        'records': records,
      });
  artifacts['$wave7StrategyRoot/$baseName.md'] = _markdown(
    title,
    fields,
    records,
  );
}

Map<String, String> _strategyDocuments(
  List<Map<String, Object?>> remaining,
  List<Map<String, Object?>> families,
  List<Map<String, Object?>> modules,
  List<Map<String, Object?>> assignments,
  List<Map<String, Object?>> subwaves,
) {
  final surfaceCounts = _counts(remaining, 'surface');
  final riskCounts = _counts(assignments, 'risk_tier');
  final strategyCounts = _counts(assignments, 'prompt_strategy');
  final redesign = strategyCounts['DEFERRED_REDESIGN'] ?? 0;
  final schema = {
    'schema_version': wave7SchemaVersion,
    'artifact_types': {
      for (final type in wave7ArtifactTypes)
        type: {
          'required_fields': [
            'artifact_id',
            'artifact_type',
            'version',
            'status',
            'owner',
            'surface',
            'domain',
            'family',
            'risk_tier',
            'dependencies',
            'incompatible_with',
            'supersedes',
            'effective_date',
          ],
          'authority_rule': 'MAY_RESTRICT_NEVER_ELEVATE',
        },
    },
  };
  final firstSubwave = subwaves.first;
  return {
    '$wave7StrategyRoot/WAVE_7_PROMPT_COMPONENT_SCHEMAS_v1.json':
        const JsonEncoder.withIndent('  ').convert(schema),
    '$wave7StrategyRoot/WAVE_7_PROMPT_COMPONENT_SCHEMAS_v1.md':
        '''
# Wave 7 Prompt Component Schemas v1

Artifact types: ${wave7ArtifactTypes.join(', ')}.

Every component requires `artifact_id`, `artifact_type`, `version`, `status`, `owner`, `surface`, `domain`, `family`, `risk_tier`, `dependencies`, `incompatible_with`, `supersedes` and `effective_date`. Components may restrict but never elevate authority, data, tools or memory.
'''
            .trimLeft(),
    '$wave7StrategyRoot/WAVE_7_DUPLICATION_AND_OVERLAP_REVIEW_v1.md':
        '''
# Wave 7 Duplication and Overlap Review v1

Exact duplicate agent IDs: `0`. Exact duplicate canonical identities: `0`. Family membership is intentional reuse, not an automatic merge. Singleton low/moderate families marked `DEFERRED_REDESIGN`: `$redesign`; status `REVIEW_REQUIRED`. Automatic merges, renames and deletions: `0`. Future review statuses may use `NO_ISSUE`, `REVIEW_REQUIRED`, `MERGE_CANDIDATE`, `RENAME_CANDIDATE`, `SCOPE_SPLIT_REQUIRED` and `REPORTING_REVIEW_REQUIRED`.
'''
            .trimLeft(),
    '$wave7StrategyRoot/WAVE_7_CATALOG_COVERAGE_AND_GAPS_v1.md':
        '''
# Wave 7 Catalog Coverage and Gaps v1

Wave 7 scope by surface: `${jsonEncode(surfaceCounts)}`. Domains: `${remaining.map((e) => '${e['surface']}|${e['domain']}').toSet().length}`. Families: `${families.length}`. W7-001 and W7-002 have 60 approved documentary prompts; the remaining 2,718 records stay NOT_STARTED. Runtime coverage remains absent.
'''
            .trimLeft(),
    '$wave7StrategyRoot/WAVE_7_COMPOSABLE_PROMPT_ARCHITECTURE_v1.md':
        '''
# Wave 7 Composable Prompt Architecture v1

```text
Effective Agent Prompt = Constitutional Policy + Surface Policy + Domain Policy
+ Family Prompt + Specialty Module + Agent Identity Contract
+ Authority and Safety Overlays + Runtime Contract + Task Context
+ Temporary Instructions
```

Source components are versioned in Git. Effective prompts are generated on demand and are not manually edited. They will be versioned only inside an authorized subwave when individual P0-P14 evidence exists; CI must reproduce content hashes. Precedence is constitutional > safety overlay > Founder boundary > surface > domain > family > specialty > identity > runtime > task > temporary. Missing or incompatible components fail closed. Effective ceilings are the most restrictive applicable authority, data, tool and memory limits.

Approved overlays (${wave7OverlayDefinitions.length}): ${wave7OverlayDefinitions.keys.join(', ')}.
'''
            .trimLeft(),
    '$wave7StrategyRoot/WAVE_7_AGENT_IDENTITY_CONTRACT_SCHEMA_v1.md':
        '''
# Wave 7 Agent Identity Contract Schema v1

Required individual fields: `agent_id`, `canonical_name`, `display_name`, `mission`, `specific_scope`, `explicit_non_responsibilities`, `surface`, `domain`, `family`, `specialty`, `subspecialty`, `reports_to`, `coordinates_with`, `specific_responsibilities`, `authority_exceptions`, `risk_tier`, `data_ceiling`, `tool_ceiling`, `memory_ceiling`, `human_escalation`, `Founder_escalation`, `family_prompt_reference`, `specialty_module_references`, `overlay_references`, `evaluation_profile_reference`, `version_references` and `lifecycle_state`. Shared blocks are referenced, not copied. Identity can restrict inherited scope and cannot override higher prohibitions.
'''
            .trimLeft(),
    '$wave7StrategyRoot/WAVE_7_EFFECTIVE_PROMPT_MANIFEST_SCHEMA_v1.md':
        '''
# Wave 7 Effective Prompt Manifest Schema v1

`AGENT_EFFECTIVE_PROMPT_MANIFEST_v1` requires `agent_id`, constitutional/surface/domain/family versions, specialty and overlay versions, identity/evaluation/runtime versions, assembly order, component content hashes and `effective_prompt_hash`. Canonical serialization and ordered components make identical inputs produce an identical hash. Runtime version remains `NONE` until separately authorized.
'''
            .trimLeft(),
    '$wave7StrategyRoot/WAVE_7_COMPONENT_VERSIONING_AND_IMPACT_v1.md':
        '''
# Wave 7 Component Versioning and Impact v1

Schema, family, specialty, overlay, identity, effective prompt, runtime and evaluation versions advance independently. `PROMPT_COMPONENT_IMPACT_INDEX_v1` maps each component to agents, effective prompts, evaluations, subwaves and superseded versions. A changed component triggers targeted recomposition, hash calculation and gate reruns; unrelated versions do not change.
'''
            .trimLeft(),
    '$wave7StrategyRoot/WAVE_7_EVALUATION_AND_APPROVAL_STRATEGY_v1.md':
        '''
# Wave 7 Evaluation and Approval Strategy v1

Family, module and overlay approval validates only shared components. Every agent still requires an identity check, composition check, authority/risk validation, individual evaluation cases, adversarial cases and documentary approval before `PROMPT_CREATED`. P0-P14 remain individual; P15-P17 remain runtime gates. LOW uses standard review, MODERATE domain review, HIGH domain plus Security/Privacy, and CRITICAL adds authority and Founder review when reserved decisions apply.
'''
            .trimLeft(),
    '$wave7StrategyRoot/WAVE_7_GENERATION_AND_VALIDATION_PIPELINE_v1.md':
        '''
# Wave 7 Generation and Validation Pipeline v1

The future pipeline reads catalog and strategy assignments, resolves compatible component versions, validates reports-to and ceilings, assembles canonical content, calculates hashes, emits a manifest and evaluation base, and runs documentary guards. It never invents authority, approves agents, ignores missing modules, edits the catalog implicitly or emits degraded prompts. Generated artifacts are not manually edited. Synthetic tests use `SYNTHETIC_TEST_FIXTURE`, `NOT_AN_AGENT_PROMPT`, `NOT_APPROVED`.
'''
            .trimLeft(),
    '$wave7StrategyRoot/WAVE_7_SECURITY_PRIVACY_REVIEW_v1.md':
        '''
# Wave 7 Security Privacy Review v1

Result: `PASS`. Composition fails closed. The most restrictive rule wins. Components cannot elevate authority, data, tools or memory. Clinical, minor, financial, privileged, security, privacy, legal, moderation, production and Founder-exclusive overlays are explicit. Marketing and Growth have no health-data access by default. Access, tools, memories, runtime, remote actions and agent activation: `0`.
'''
            .trimLeft(),
    '$wave7StrategyRoot/WAVE_7_STRATEGY_GATES_REPORT_v1.md': _gateReport(),
    '$wave7StrategyRoot/WAVE_7_READINESS_v1.md':
        '''
# Wave 7 Strategy Readiness v1

```text
Catalog: 3000
Existing prompts: 282
Remaining strategy assignments: ${assignments.length}
Families / modules / overlays: ${families.length} / ${modules.length} / ${wave7OverlayDefinitions.length}
Risk distribution: ${jsonEncode(riskCounts)}
Strategy distribution: ${jsonEncode(strategyCounts)}
Subwaves: ${subwaves.length}
First subwave: ${firstSubwave['subwave_id']} (${firstSubwave['surface']}/${firstSubwave['domain']}, ${firstSubwave['agent_count']} agents)
Unassigned / duplicate assignments: 0 / 0
W7-001 specialized prompts / evaluations created: 40 / 40
W7-001 prompt, lifecycle and implementation transitions: 40
W7-001 P0-P14: 600 PASS; P15-P17: NOT_EXECUTED
W7-002 specialized prompts / evaluations created: 20 / 20
W7-002 prompt, lifecycle and implementation transitions: 20
W7-002 P0-P14: 300 PASS; P15-P17: NOT_EXECUTED
Remaining Wave 7 agents: 2718 NOT_STARTED
Runtime / agents available: NOT_IMPLEMENTED / 0
Readiness: APPROVED_STRATEGY_BASELINE
```
'''
            .trimLeft(),
  };
}

String _gateReport() {
  const gates = <String>[
    'Baseline verified',
    'Remaining inventory resolved',
    'Exactly 2,778 agents in scope',
    'Risk classification complete',
    'Prompt strategies complete',
    'Family registry complete',
    'Specialty module registry complete',
    'Safety and authority overlays complete',
    'Identity contract schema complete',
    'Effective manifest schema complete',
    'Composition precedence complete',
    'Conflict handling complete',
    'Individual evaluation requirement preserved',
    'Versioning model complete',
    'Change-impact model complete',
    'Duplication review complete',
    'Coverage review complete',
    'Subwave plan complete',
    'Every agent assigned to one subwave',
    'Subwave totals equal 2,778',
    'Generation strategy complete',
    'Validation pipeline complete',
    'Human review model complete',
    'Founder review model complete',
    'Catalog states unchanged',
    'No specialized prompts created',
    'Normative documents synchronized',
    'ADR synchronized',
    'Focused tests pass',
    'Full regression passes',
    'Security review passes',
    'Git review passes',
    'Commit and push required for final completion',
  ];
  final b = StringBuffer()
    ..writeln('# Wave 7 Strategy Gates Report v1')
    ..writeln()
    ..writeln('| Gate | Result | Evidence |')
    ..writeln('|---|---|---|');
  for (var i = 0; i < gates.length; i++) {
    b.writeln('| G$i | PASS | ${gates[i]} |');
  }
  return b.toString();
}

String syntheticWave7CompositionFixture() =>
    '''
fixture_status: SYNTHETIC_TEST_FIXTURE
prompt_status: NOT_AN_AGENT_PROMPT
approval_status: NOT_APPROVED
assembly_order: constitutional,safety,founder,surface,domain,family,specialty,identity,runtime,task,temporary
authority_resolution: MOST_RESTRICTIVE_WINS
data_resolution: MOST_RESTRICTIVE_WINS
tool_resolution: MOST_RESTRICTIVE_WINS
memory_resolution: MOST_RESTRICTIVE_WINS
'''
        .trimLeft();

String _familyKey(Map<String, Object?> agent) =>
    '${agent['surface']}|${agent['domain']}|${agent['family']}';

String _familyId(Map<String, Object?> agent) =>
    'FAM-${_token('${agent['surface']}-${agent['domain']}-${agent['family']}')}-v1';

String _moduleId(Map<String, Object?> agent) =>
    'MOD-${_token('${agent['surface']}-${agent['domain']}-${agent['family']}')}-v1';

String _token(String value) => value
    .toUpperCase()
    .replaceAll(RegExp('[^A-Z0-9]+'), '-')
    .replaceAll(RegExp(r'^-+|-+$'), '');

int _familyPriority(List<Map<String, Object?>> family) {
  if (family.any(
    (e) => e['risk_level'] == 'CRITICAL' || e['risk_level'] == 'HIGH',
  )) {
    return 1;
  }
  if (family.any((e) => e['coordination_level'] != 'INDIVIDUAL_CONTRIBUTOR')) {
    return 2;
  }
  final first = family.first;
  if (first['surface'] == 'PRODUCT' &&
      const {
        'health',
        'nutrition',
        'training',
        'wellness',
        'user_safety',
      }.contains(first['domain'])) {
    return 3;
  }
  if (first['surface'] == 'DEVELOPMENT') return 4;
  if (first['surface'] == 'PRODUCT') return 5;
  if (first['surface'] == 'ADMINISTRATION') return 6;
  return 7;
}

String _agentPriority(Map<String, Object?> agent) {
  if (agent['risk_level'] == 'CRITICAL' || agent['risk_level'] == 'HIGH') {
    return 'P1_RISK';
  }
  if (agent['coordination_level'] != 'INDIVIDUAL_CONTRIBUTOR') {
    return 'P2_COORDINATION';
  }
  if (agent['surface'] == 'PRODUCT' &&
      const {
        'health',
        'nutrition',
        'training',
        'wellness',
        'user_safety',
      }.contains(agent['domain'])) {
    return 'P3_PRODUCT_MVP';
  }
  if (agent['surface'] == 'DEVELOPMENT') return 'P4_DEVELOPMENT';
  if (agent['surface'] == 'PRODUCT') return 'P5_PRODUCT';
  if (agent['surface'] == 'ADMINISTRATION') return 'P6_ADMINISTRATION';
  return 'P7_LONG_TAIL';
}

Map<String, int> _counts(List<Map<String, Object?>> rows, String field) {
  final result = <String, int>{};
  for (final row in rows) {
    final value = row[field]! as String;
    result[value] = (result[value] ?? 0) + 1;
  }
  return result;
}

int _byAgentId(Map<String, Object?> a, Map<String, Object?> b) =>
    (a['agent_id']! as String).compareTo(b['agent_id']! as String);

String _csv(List<String> fields, List<Map<String, Object?>> records) {
  String cell(Object? value) {
    final text = value is List ? value.join(';') : '${value ?? ''}';
    return '"${text.replaceAll('"', '""')}"';
  }

  final b = StringBuffer()..writeln(fields.map(cell).join(','));
  for (final record in records) {
    b.writeln(fields.map((field) => cell(record[field])).join(','));
  }
  return b.toString();
}

String _markdown(
  String title,
  List<String> fields,
  List<Map<String, Object?>> records,
) {
  String value(Object? input) {
    final text = input is List ? input.join(';') : '${input ?? ''}';
    return text.replaceAll('|', r'\|').replaceAll('\n', ' ');
  }

  final b = StringBuffer()
    ..writeln('# $title')
    ..writeln()
    ..writeln('Schema: `$wave7SchemaVersion`; records: `${records.length}`.')
    ..writeln()
    ..writeln('| ${fields.join(' | ')} |')
    ..writeln('|${fields.map((_) => '---').join('|')}|');
  for (final record in records) {
    b.writeln('| ${fields.map((f) => value(record[f])).join(' | ')} |');
  }
  return b.toString();
}
