import 'dart:convert';
import 'dart:io';

const catalogRoot = 'docs/stasisly_refoundation/agents';
const specificationPath = '$catalogRoot/AGENT_CATALOG_GENERATION_SPEC_v1.json';
const historicalInventoryPath =
    'docs/stasisly_refoundation/inventories/'
    'HISTORICAL_43_AGENTS_INVENTORY.md';
const historicalSourceCommit = 'b9691674949037bdbff18130f3dec71f6926f642';

const catalogFields = <String>[
  'agent_id',
  'canonical_name',
  'display_name',
  'surface',
  'domain',
  'family',
  'area',
  'subarea',
  'specialty',
  'subspecialty',
  'function',
  'short_mission',
  'agent_type',
  'coordination_level',
  'reports_to',
  'coordinates',
  'activation_mode',
  'availability',
  'risk_level',
  'data_access_class',
  'tool_access_class',
  'memory_scope',
  'human_escalation',
  'prompt_status',
  'implementation_status',
  'historical_mapping',
  'lifecycle_status',
  'version',
  'notes',
];

const validSurfaces = {
  'PRODUCT',
  'DEVELOPMENT',
  'ADMINISTRATION',
  'TRANSVERSAL',
};
const validAgentTypes = {
  'GLOBAL_COORDINATOR',
  'SURFACE_COORDINATOR',
  'DOMAIN_COORDINATOR',
  'FAMILY_COORDINATOR',
  'AREA_COORDINATOR',
  'SPECIALIST',
  'REVIEWER',
  'AUDITOR',
  'RESEARCHER',
  'OPERATOR',
  'ANALYST',
  'PLANNER',
  'DESIGNER',
  'ENGINEER',
  'GUARDIAN',
  'LIAISON',
  'QUALITY_AGENT',
  'INCIDENT_AGENT',
  'SUPPORT_AGENT',
};
const validCoordinationLevels = {
  'GLOBAL',
  'SURFACE',
  'DOMAIN',
  'FAMILY',
  'AREA',
  'SPECIALTY',
  'INDIVIDUAL_CONTRIBUTOR',
};
const validActivationModes = {
  'ALWAYS_AVAILABLE',
  'ON_DEMAND',
  'EVENT_TRIGGERED',
  'SCHEDULED',
  'HUMAN_REQUESTED',
  'COORDINATOR_SELECTED',
  'RISK_TRIGGERED',
  'INCIDENT_TRIGGERED',
};
const validRiskLevels = {'LOW', 'MODERATE', 'HIGH', 'CRITICAL'};
const validAvailabilityStates = {'NOT_AVAILABLE'};
const validPromptStatuses = {'NOT_CREATED', 'PROMPT_CREATED'};
const validImplementationStatuses = {'NOT_IMPLEMENTED', 'DOCUMENTED_ONLY'};
const approvedWave1CoordinatorIds = {
  'AG-PRO-0001',
  'AG-DEV-0001',
  'AG-ADM-0001',
  'AG-TRV-0001',
};
const approvedWave2GovernanceIds = {
  'AG-TRV-0002',
  'AG-TRV-0003',
  'AG-TRV-0004',
  'AG-TRV-0005',
  'AG-TRV-0006',
  'AG-TRV-0007',
  'AG-TRV-0008',
  'AG-TRV-0009',
  'AG-TRV-0010',
  'AG-TRV-0011',
  'AG-TRV-0012',
  'AG-TRV-0013',
  'AG-TRV-0014',
  'AG-TRV-0015',
  'AG-TRV-0016',
  'AG-TRV-0017',
  'AG-TRV-0018',
  'AG-TRV-0019',
};
const approvedWave3ArchitectureIds = {
  'AG-DEV-0003',
  'AG-DEV-0004',
  'AG-DEV-0005',
  'AG-DEV-0006',
  'AG-DEV-0007',
  'AG-DEV-0008',
  'AG-DEV-0009',
  'AG-DEV-0010',
  'AG-DEV-0011',
  'AG-DEV-0012',
  'AG-DEV-0013',
  'AG-DEV-0014',
  'AG-DEV-0015',
  'AG-DEV-0041',
  'AG-DEV-0042',
  'AG-DEV-0043',
  'AG-DEV-0044',
  'AG-DEV-0045',
  'AG-DEV-0046',
  'AG-DEV-0047',
  'AG-DEV-0048',
  'AG-DEV-0049',
  'AG-DEV-0050',
  'AG-DEV-0051',
  'AG-DEV-0052',
  'AG-DEV-0053',
  'AG-DEV-0054',
  'AG-DEV-0055',
  'AG-DEV-0056',
  'AG-DEV-0057',
  'AG-DEV-0058',
  'AG-DEV-0059',
  'AG-DEV-0060',
  'AG-DEV-0061',
  'AG-DEV-0062',
  'AG-DEV-0063',
  'AG-DEV-0064',
  'AG-DEV-0065',
  'AG-DEV-0066',
  'AG-DEV-0067',
};
const approvedWave4ProductIds = {
  'AG-PRO-0002',
  'AG-PRO-0003',
  'AG-PRO-0004',
  'AG-PRO-0005',
  'AG-PRO-0006',
  'AG-PRO-0007',
  'AG-PRO-0008',
  'AG-PRO-0009',
  'AG-PRO-0010',
  'AG-PRO-0011',
  'AG-PRO-0012',
  'AG-PRO-0013',
  'AG-PRO-0014',
  'AG-PRO-0015',
  'AG-PRO-0016',
  'AG-PRO-0017',
  'AG-PRO-0018',
  'AG-PRO-0019',
  'AG-PRO-0020',
  'AG-PRO-0021',
  'AG-PRO-0022',
  'AG-PRO-0023',
  'AG-PRO-0024',
  'AG-PRO-0025',
  'AG-PRO-0026',
  'AG-PRO-0027',
  'AG-PRO-0028',
  'AG-PRO-0029',
  'AG-PRO-0030',
  'AG-PRO-0031',
  'AG-PRO-0032',
  'AG-PRO-0033',
  'AG-PRO-0034',
  'AG-PRO-0035',
  'AG-PRO-0036',
  'AG-PRO-0037',
  'AG-PRO-0038',
  'AG-PRO-0039',
  'AG-PRO-0040',
  'AG-PRO-0041',
  'AG-PRO-0042',
  'AG-PRO-0043',
  'AG-PRO-0044',
  'AG-PRO-0045',
  'AG-PRO-0046',
  'AG-PRO-0047',
  'AG-PRO-0048',
  'AG-PRO-0049',
  'AG-PRO-0050',
  'AG-PRO-0051',
};
const approvedWave5DevelopmentIds = {
  'AG-DEV-0002',
  'AG-DEV-0016',
  'AG-DEV-0017',
  'AG-DEV-0018',
  'AG-DEV-0019',
  'AG-DEV-0020',
  'AG-DEV-0021',
  'AG-DEV-0022',
  'AG-DEV-0023',
  'AG-DEV-0024',
  'AG-DEV-0025',
  'AG-DEV-0026',
  'AG-DEV-0027',
  'AG-DEV-0028',
  'AG-DEV-0029',
  'AG-DEV-0030',
  'AG-DEV-0031',
  'AG-DEV-0032',
  'AG-DEV-0033',
  'AG-DEV-0034',
  'AG-DEV-0035',
  'AG-DEV-0036',
  'AG-DEV-0037',
  'AG-DEV-0038',
  'AG-DEV-0039',
  'AG-DEV-0040',
  'AG-DEV-0068',
  'AG-DEV-0069',
  'AG-DEV-0070',
  'AG-DEV-0071',
  'AG-DEV-0072',
  'AG-DEV-0073',
  'AG-DEV-0074',
  'AG-DEV-0075',
  'AG-DEV-0076',
  'AG-DEV-0077',
  'AG-DEV-0078',
  'AG-DEV-0079',
  'AG-DEV-0080',
  'AG-DEV-0081',
  'AG-DEV-0082',
  'AG-DEV-0083',
  'AG-DEV-0084',
  'AG-DEV-0085',
  'AG-DEV-0086',
  'AG-DEV-0087',
  'AG-DEV-0088',
  'AG-DEV-0089',
  'AG-DEV-0090',
  'AG-DEV-0091',
  'AG-DEV-0092',
  'AG-DEV-0093',
  'AG-DEV-0094',
  'AG-DEV-0095',
  'AG-DEV-0096',
  'AG-DEV-0097',
  'AG-DEV-0098',
  'AG-DEV-0099',
  'AG-DEV-0100',
  'AG-DEV-0101',
};
const approvedWave6AdministrationIds = {
  'AG-ADM-0002',
  'AG-ADM-0003',
  'AG-ADM-0004',
  'AG-ADM-0005',
  'AG-ADM-0006',
  'AG-ADM-0007',
  'AG-ADM-0008',
  'AG-ADM-0009',
  'AG-ADM-0010',
  'AG-ADM-0011',
  'AG-ADM-0012',
  'AG-ADM-0013',
  'AG-ADM-0014',
  'AG-ADM-0015',
  'AG-ADM-0016',
  'AG-ADM-0017',
  'AG-ADM-0018',
  'AG-ADM-0019',
  'AG-ADM-0020',
  'AG-ADM-0021',
  'AG-ADM-0022',
  'AG-ADM-0023',
  'AG-ADM-0024',
  'AG-ADM-0025',
  'AG-ADM-0026',
  'AG-ADM-0027',
  'AG-ADM-0028',
  'AG-ADM-0029',
  'AG-ADM-0030',
  'AG-ADM-0031',
  'AG-ADM-0032',
  'AG-ADM-0033',
  'AG-ADM-0034',
  'AG-ADM-0035',
  'AG-ADM-0036',
  'AG-ADM-0037',
  'AG-ADM-0038',
  'AG-ADM-0039',
  'AG-ADM-0040',
  'AG-ADM-0041',
  'AG-ADM-0042',
  'AG-ADM-0043',
  'AG-ADM-0044',
  'AG-ADM-0045',
  'AG-ADM-0046',
  'AG-ADM-0047',
  'AG-ADM-0048',
  'AG-ADM-0049',
  'AG-ADM-0050',
  'AG-ADM-0051',
};
const approvedDocumentaryPromptIds = {
  ...approvedWave1CoordinatorIds,
  ...approvedWave2GovernanceIds,
  ...approvedWave3ArchitectureIds,
  ...approvedWave4ProductIds,
  ...approvedWave5DevelopmentIds,
  ...approvedWave6AdministrationIds,
  ...approvedW7001Ids,
  ...approvedW7002Ids,
  ...approvedW7003Ids,
  ...approvedW7004Ids,
  ...approvedW7005Ids,
  ...approvedW7006Ids,
};
const approvedW7001Ids = {
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
const approvedW7002Ids = {
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
const approvedW7003Ids = {
  'AG-ADM-0346',
  'AG-ADM-0347',
  'AG-ADM-0348',
  'AG-ADM-0349',
  'AG-ADM-0350',
  'AG-ADM-0351',
  'AG-ADM-0352',
  'AG-ADM-0353',
  'AG-ADM-0354',
  'AG-ADM-0355',
  'AG-ADM-0356',
  'AG-ADM-0357',
  'AG-ADM-0358',
  'AG-ADM-0359',
  'AG-ADM-0360',
  'AG-ADM-0361',
  'AG-ADM-0362',
  'AG-ADM-0363',
  'AG-ADM-0364',
  'AG-ADM-0365',
  'AG-ADM-0366',
  'AG-ADM-0367',
  'AG-ADM-0368',
  'AG-ADM-0369',
  'AG-ADM-0370',
  'AG-ADM-0371',
  'AG-ADM-0372',
  'AG-ADM-0373',
  'AG-ADM-0374',
  'AG-ADM-0375',
  'AG-ADM-0376',
  'AG-ADM-0377',
  'AG-ADM-0378',
  'AG-ADM-0379',
  'AG-ADM-0380',
  'AG-ADM-0381',
  'AG-ADM-0382',
  'AG-ADM-0383',
  'AG-ADM-0384',
  'AG-ADM-0385',
  'AG-ADM-0386',
  'AG-ADM-0387',
  'AG-ADM-0388',
  'AG-ADM-0389',
  'AG-ADM-0390',
};
const approvedW7004Ids = {
  'AG-ADM-0133',
  'AG-ADM-0134',
  'AG-ADM-0141',
  'AG-ADM-0142',
  'AG-ADM-0149',
  'AG-ADM-0150',
  'AG-ADM-0157',
  'AG-ADM-0158',
  'AG-ADM-0165',
  'AG-ADM-0166',
  'AG-ADM-0173',
  'AG-ADM-0174',
  'AG-ADM-0181',
  'AG-ADM-0182',
  'AG-ADM-0189',
  'AG-ADM-0190',
  'AG-ADM-0197',
  'AG-ADM-0198',
  'AG-ADM-0205',
  'AG-ADM-0206',
  'AG-ADM-0213',
  'AG-ADM-0214',
};
const approvedW7005Ids = {
  'AG-DEV-0985',
  'AG-DEV-0994',
  'AG-DEV-1003',
  'AG-DEV-1012',
  'AG-DEV-1021',
  'AG-DEV-1030',
  'AG-DEV-1039',
  'AG-DEV-1048',
  'AG-DEV-1057',
  'AG-DEV-1066',
};
const approvedW7006Ids = {
  'AG-DEV-1123',
  'AG-DEV-1130',
  'AG-DEV-1137',
  'AG-DEV-1144',
  'AG-DEV-1151',
  'AG-DEV-1158',
  'AG-DEV-1165',
};
const validDataAccessClasses = {
  'NO_USER_DATA',
  'ANONYMIZED_DATA',
  'PSEUDONYMIZED_DATA',
  'USER_SCOPED_DATA',
  'SURFACE_SCOPED_DATA',
  'ADMINISTRATIVE_DATA',
  'SENSITIVE_HEALTH_DATA',
  'SECURITY_RESTRICTED_DATA',
  'FOUNDER_ONLY_DATA',
};
const validToolAccessClasses = {
  'NO_TOOLS',
  'READ_ONLY_TOOLS',
  'DOMAIN_TOOLS',
  'MUTATING_TOOLS_WITH_APPROVAL',
  'SECURITY_RESTRICTED_TOOLS',
  'FOUNDER_AUTHORIZED_TOOLS',
};
const validMemoryScopes = {
  'NONE',
  'EPHEMERAL_TASK',
  'AGENT_PRIVATE',
  'AREA_MEMORY',
  'SURFACE_MEMORY',
  'GLOBAL_FEDERATED_MEMORY',
  'FOUNDER_PRIVATE_MEMORY',
};
const validLifecycleStates = {
  'CATALOGED',
  'DESIGNED',
  'PROMPT_CREATED',
  'CONFIGURED',
  'TESTED',
  'AVAILABLE',
  'ACTIVE',
  'SUSPENDED',
  'RETIRED',
  'ARCHIVED',
};

const functionVariants = <FunctionVariant>[
  FunctionVariant('coordinate', 'Coordination', 'Coordinates', 'PLANNER'),
  FunctionVariant('assess', 'Assessment', 'Assesses', 'ANALYST'),
  FunctionVariant('plan', 'Planning', 'Plans', 'PLANNER'),
  FunctionVariant('monitor', 'Monitoring', 'Monitors', 'ANALYST'),
  FunctionVariant('review', 'Review', 'Reviews', 'REVIEWER'),
  FunctionVariant('research', 'Research', 'Researches', 'RESEARCHER'),
  FunctionVariant('design', 'Design', 'Designs', 'DESIGNER'),
  FunctionVariant('engineer', 'Engineering', 'Engineers', 'ENGINEER'),
  FunctionVariant('validate', 'Validation', 'Validates', 'QUALITY_AGENT'),
  FunctionVariant('audit', 'Audit', 'Audits', 'AUDITOR'),
  FunctionVariant('communicate', 'Communication', 'Communicates', 'LIAISON'),
  FunctionVariant('optimize', 'Optimization', 'Optimizes', 'ANALYST'),
  FunctionVariant('safeguard', 'Safeguarding', 'Safeguards', 'GUARDIAN'),
  FunctionVariant('triage', 'Triage', 'Triages', 'SUPPORT_AGENT'),
  FunctionVariant('operate', 'Operations', 'Operates', 'OPERATOR'),
  FunctionVariant('investigate', 'Investigation', 'Investigates', 'RESEARCHER'),
  FunctionVariant('simulate', 'Simulation', 'Simulates', 'ENGINEER'),
  FunctionVariant('measure', 'Measurement', 'Measures', 'ANALYST'),
  FunctionVariant('respond', 'Response', 'Responds to', 'INCIDENT_AGENT'),
  FunctionVariant('educate', 'Education', 'Explains', 'SPECIALIST'),
];

void main() {
  final artifacts = generateAgentCatalogArtifacts();
  for (final entry in artifacts.entries) {
    File(entry.key)
      ..createSync(recursive: true)
      ..writeAsStringSync(entry.value);
  }
  stdout.writeln('AGENT_CATALOG_V1_GENERATED:${artifacts.length}');
}

Map<String, String> generateAgentCatalogArtifacts() {
  final specification = _readObject(specificationPath);
  final historical = _readHistoricalInventory();
  final entries = _generateEntries(specification, historical);
  _populateCoordinates(entries);
  final findings = validateAgentCatalog(entries, historical);
  if (findings.isNotEmpty) {
    throw StateError('AGENT_CATALOG_INVALID:${findings.join(',')}');
  }

  final artifacts = <String, String>{
    '$catalogRoot/AGENT_CATALOG_SCHEMA_v1.md': _schemaMarkdown(),
    '$catalogRoot/AGENT_CATALOG_MASTER_v1.csv': _catalogCsv(entries),
    '$catalogRoot/AGENT_CATALOG_MASTER_v1.json': _catalogJson(entries),
    '$catalogRoot/AGENT_CATALOG_MASTER_v1.md': _masterMarkdown(entries),
    '$catalogRoot/AGENT_CATALOG_PRODUCT_v1.md': _surfaceMarkdown(
      entries,
      'PRODUCT',
    ),
    '$catalogRoot/AGENT_CATALOG_DEVELOPMENT_v1.md': _surfaceMarkdown(
      entries,
      'DEVELOPMENT',
    ),
    '$catalogRoot/AGENT_CATALOG_ADMINISTRATION_v1.md': _surfaceMarkdown(
      entries,
      'ADMINISTRATION',
    ),
    '$catalogRoot/AGENT_CATALOG_TRANSVERSAL_v1.md': _surfaceMarkdown(
      entries,
      'TRANSVERSAL',
    ),
    '$catalogRoot/HISTORICAL_43_AGENT_CROSSWALK_v1.md': _historicalCrosswalk(
      entries,
      historical,
    ),
    '$catalogRoot/AGENT_DUPLICATION_REPORT_v1.md': _duplicationReport(entries),
    '$catalogRoot/AGENT_COVERAGE_GAPS_v1.md': _coverageGapReport(),
    '$catalogRoot/AGENT_LIFECYCLE_AND_GOVERNANCE_v1.md': _lifecycleGovernance(),
    '$catalogRoot/AGENT_CATALOG_VALIDATION_REPORT_v1.md': _validationReport(
      entries,
      historical,
    ),
  };
  return artifacts;
}

List<Map<String, Object?>> _generateEntries(
  Map<String, Object?> specification,
  List<HistoricalAgent> historical,
) {
  final surfaces = (specification['surfaces']! as List)
      .cast<Map<String, Object?>>();
  final entries = <Map<String, Object?>>[];

  for (final surfaceSpec in surfaces) {
    final surface = surfaceSpec['surface']! as String;
    final prefix = surfaceSpec['prefix']! as String;
    final total = surfaceSpec['total']! as int;
    final contexts = (surfaceSpec['contexts']! as List).cast<String>();
    final groups = (surfaceSpec['groups']! as List)
        .cast<Map<String, Object?>>();
    final surfaceHistorical = historical
        .where((agent) => agent.surface == surface)
        .toList();
    var sequence = 1;
    final coordinatorId = _agentId(prefix, sequence++);
    entries.add(_coordinator(surfaceSpec, coordinatorId));

    for (final agent in surfaceHistorical) {
      entries.add(
        _historicalEntry(
          agent: agent,
          agentId: _agentId(prefix, sequence++),
          reportsTo: coordinatorId,
        ),
      );
    }

    var reserved = 1 + surfaceHistorical.length;
    for (var groupIndex = 0; groupIndex < groups.length; groupIndex++) {
      final group = groups[groupIndex];
      final allocation = group['allocation']! as int;
      final minimum = groupIndex == 0 ? 0 : 1;
      final reduction = reserved.clamp(0, allocation - minimum);
      final generatedCount = allocation - reduction;
      reserved -= reduction;
      if (generatedCount == 0) continue;

      final domainCoordinatorId = generatedCount > 1
          ? _agentId(prefix, sequence)
          : coordinatorId;
      for (var localIndex = 0; localIndex < generatedCount; localIndex++) {
        final isDomainCoordinator = localIndex == 0 && generatedCount > 1;
        entries.add(
          _generatedEntry(
            surface: surface,
            group: group,
            contexts: contexts,
            localIndex: localIndex,
            agentId: _agentId(prefix, sequence++),
            reportsTo: isDomainCoordinator
                ? coordinatorId
                : domainCoordinatorId,
            isDomainCoordinator: isDomainCoordinator,
          ),
        );
      }
    }
    if (reserved != 0 || sequence - 1 != total) {
      throw StateError('AGENT_SURFACE_ALLOCATION_INVALID:$surface');
    }
  }
  return entries;
}

Map<String, Object?> _coordinator(
  Map<String, Object?> surfaceSpec,
  String agentId,
) {
  final surface = surfaceSpec['surface']! as String;
  final canonical = surfaceSpec['coordinator_name']! as String;
  final display = surfaceSpec['coordinator_display_name']! as String;
  final isNexus = surface == 'TRANSVERSAL';
  return _entry(
    agentId: agentId,
    canonicalName: canonical,
    displayName: display,
    surface: surface,
    domain: isNexus
        ? 'global_coordination'
        : '${surface.toLowerCase()}_coordination',
    family: isNexus ? 'nexus' : canonical,
    area: isNexus ? 'Global' : _title(surface),
    functionName: 'coordinate_surface',
    mission:
        'Coordinates ${_title(surface)} priorities, bounded decisions, '
        'cross-domain handoffs, risk escalation, and traceable evidence '
        'without acquiring authority beyond approved policy.',
    agentType: isNexus ? 'GLOBAL_COORDINATOR' : 'SURFACE_COORDINATOR',
    coordinationLevel: isNexus ? 'GLOBAL' : 'SURFACE',
    reportsTo: isNexus ? 'FOUNDER' : 'AG-TRV-0001',
    activationMode: 'HUMAN_REQUESTED',
    riskLevel: 'CRITICAL',
    dataAccessClass: isNexus ? 'FOUNDER_ONLY_DATA' : 'SURFACE_SCOPED_DATA',
    toolAccessClass: isNexus
        ? 'FOUNDER_AUTHORIZED_TOOLS'
        : 'MUTATING_TOOLS_WITH_APPROVAL',
    memoryScope: isNexus ? 'GLOBAL_FEDERATED_MEMORY' : 'SURFACE_MEMORY',
    humanEscalation: 'FOUNDER_APPROVAL_REQUIRED',
    promptStatus: 'PROMPT_CREATED',
    lifecycleStatus: 'PROMPT_CREATED',
    implementationStatus: 'DOCUMENTED_ONLY',
    notes:
        'Wave 1 documentary prompt approved; runtime, authority, tools, and '
        'memory are not provisioned.',
  );
}

Map<String, Object?> _historicalEntry({
  required HistoricalAgent agent,
  required String agentId,
  required String reportsTo,
}) {
  final canonical = 'historical.${_slug(agent.name)}';
  final type = _historicalType(agent.name);
  final documentaryApproved = approvedDocumentaryPromptIds.contains(agentId);
  return _entry(
    agentId: agentId,
    canonicalName: canonical,
    displayName: agent.name,
    surface: agent.surface,
    domain: 'historical_capabilities',
    family: _slug(agent.name),
    area: _title(agent.surface),
    functionName: 'historical_prompt_migration',
    mission:
        'Preserves and updates the historical ${agent.name} capability for '
        '${_title(agent.surface)} under Re-foundation boundaries, evidence, '
        'testing, and human approval.',
    agentType: type,
    coordinationLevel: 'INDIVIDUAL_CONTRIBUTOR',
    reportsTo: reportsTo,
    activationMode: 'HUMAN_REQUESTED',
    riskLevel: _risk(agent.surface, 'historical_capabilities', agent.name),
    dataAccessClass: _dataAccess(agent.surface, 'historical_capabilities'),
    toolAccessClass: 'NO_TOOLS',
    memoryScope: 'NONE',
    humanEscalation: 'REQUIRED_BEFORE_REFOUNDATION_ACTIVATION',
    promptStatus: 'PROMPT_CREATED',
    lifecycleStatus: 'PROMPT_CREATED',
    implementationStatus: documentaryApproved
        ? 'DOCUMENTED_ONLY'
        : 'NOT_IMPLEMENTED',
    historicalMapping:
        'docs/archive/discovery/stasisly_definition/agents/${agent.file}',
    notes: documentaryApproved
        ? '${agent.action}; canonical documentary prompt approved; '
              'historical source $historicalSourceCommit remains unchanged.'
        : '${agent.action}; historical source $historicalSourceCommit.',
  );
}

Map<String, Object?> _generatedEntry({
  required String surface,
  required Map<String, Object?> group,
  required List<String> contexts,
  required int localIndex,
  required String agentId,
  required String reportsTo,
  required bool isDomainCoordinator,
}) {
  final domain = group['domain']! as String;
  final area = group['area']! as String;
  final topics = (group['topics']! as List).cast<String>();
  final topic = topics[localIndex % topics.length];
  final function =
      functionVariants[(localIndex ~/ topics.length) % functionVariants.length];
  final context =
      contexts[(localIndex ~/ (topics.length * functionVariants.length)) %
          contexts.length];
  final canonical = [
    surface.toLowerCase(),
    domain,
    topic,
    function.key,
    context,
  ].map(_slug).join('.');
  final display = isDomainCoordinator
      ? '${_title(domain)} Coordinator'
      : '${function.label}: ${_title(topic)} — ${_title(domain)} / '
            '${_title(context)}';
  final mission = isDomainCoordinator
      ? 'Coordinates ${_title(domain)} coverage, bounded specialist handoffs, '
            'risk review, quality evidence, and escalation within the '
            '${_title(surface)} surface.'
      : '${function.verb} ${_title(topic)} for ${_title(context)} within '
            '${_title(domain)}, producing bounded evidence, explicit handoffs, '
            'and human escalation when authority or risk limits are reached.';
  final documentaryApproved = approvedDocumentaryPromptIds.contains(agentId);
  return _entry(
    agentId: agentId,
    canonicalName: canonical,
    displayName: display,
    surface: surface,
    domain: domain,
    family: _slug(topic),
    area: area,
    subarea: _title(domain),
    specialty: _title(topic),
    functionName: isDomainCoordinator ? 'coordinate_domain' : function.key,
    mission: mission,
    agentType: isDomainCoordinator ? 'DOMAIN_COORDINATOR' : function.agentType,
    coordinationLevel: isDomainCoordinator
        ? 'DOMAIN'
        : 'INDIVIDUAL_CONTRIBUTOR',
    reportsTo: reportsTo,
    activationMode: isDomainCoordinator
        ? 'COORDINATOR_SELECTED'
        : _activationMode(function.key),
    riskLevel: _risk(surface, domain, topic),
    dataAccessClass: _dataAccess(surface, domain),
    toolAccessClass: _toolAccess(surface, domain, function.key),
    memoryScope: _memoryScope(surface, domain, isDomainCoordinator),
    humanEscalation: _humanEscalation(surface, domain),
    promptStatus: documentaryApproved ? 'PROMPT_CREATED' : 'NOT_CREATED',
    lifecycleStatus: documentaryApproved ? 'PROMPT_CREATED' : 'CATALOGED',
    implementationStatus: documentaryApproved
        ? 'DOCUMENTED_ONLY'
        : 'NOT_IMPLEMENTED',
    notes: documentaryApproved
        ? 'Canonical documentary prompt approved; runtime, authority, '
              'tools, and memory are not provisioned.'
        : 'Generated deterministically from catalog specification v1.',
  );
}

Map<String, Object?> _entry({
  required String agentId,
  required String canonicalName,
  required String displayName,
  required String surface,
  required String domain,
  required String family,
  required String area,
  required String functionName,
  required String mission,
  required String agentType,
  required String coordinationLevel,
  required String reportsTo,
  required String activationMode,
  required String riskLevel,
  required String dataAccessClass,
  required String toolAccessClass,
  required String memoryScope,
  required String humanEscalation,
  required String notes,
  String subarea = '',
  String specialty = '',
  String subspecialty = '',
  String promptStatus = 'NOT_CREATED',
  String lifecycleStatus = 'CATALOGED',
  String implementationStatus = 'NOT_IMPLEMENTED',
  String historicalMapping = 'NONE',
}) => <String, Object?>{
  'agent_id': agentId,
  'canonical_name': canonicalName,
  'display_name': displayName,
  'surface': surface,
  'domain': domain,
  'family': family,
  'area': area,
  'subarea': subarea,
  'specialty': specialty,
  'subspecialty': subspecialty,
  'function': functionName,
  'short_mission': mission,
  'agent_type': agentType,
  'coordination_level': coordinationLevel,
  'reports_to': reportsTo,
  'coordinates': <String>[],
  'activation_mode': activationMode,
  'availability': 'NOT_AVAILABLE',
  'risk_level': riskLevel,
  'data_access_class': dataAccessClass,
  'tool_access_class': toolAccessClass,
  'memory_scope': memoryScope,
  'human_escalation': humanEscalation,
  'prompt_status': promptStatus,
  'implementation_status': implementationStatus,
  'historical_mapping': historicalMapping,
  'lifecycle_status': lifecycleStatus,
  'version': '1.0.0',
  'notes': notes,
};

void _populateCoordinates(List<Map<String, Object?>> entries) {
  final children = <String, List<String>>{};
  for (final entry in entries) {
    final parent = entry['reports_to']! as String;
    if (parent.isNotEmpty) {
      children
          .putIfAbsent(parent, () => <String>[])
          .add(entry['agent_id']! as String);
    }
  }
  for (final entry in entries) {
    entry['coordinates'] = (children[entry['agent_id']] ?? <String>[])..sort();
  }
}

List<String> validateAgentCatalog(
  List<Map<String, Object?>> entries,
  List<HistoricalAgent> historical,
) {
  final findings = <String>[];
  if (entries.length != 3000) findings.add('TOTAL_NOT_3000');
  final expectedCounts = {
    'PRODUCT': 1050,
    'DEVELOPMENT': 1200,
    'ADMINISTRATION': 700,
    'TRANSVERSAL': 50,
  };
  for (final expected in expectedCounts.entries) {
    if (entries.where((entry) => entry['surface'] == expected.key).length !=
        expected.value) {
      findings.add('${expected.key}_COUNT_INVALID');
    }
  }
  _validateUnique(entries, 'agent_id', findings);
  _validateUnique(entries, 'canonical_name', findings);
  _validateUnique(entries, 'display_name', findings);
  _validateUnique(entries, 'short_mission', findings);

  final ids = entries.map((entry) => entry['agent_id']! as String).toSet();
  final byId = {
    for (final entry in entries) entry['agent_id']! as String: entry,
  };
  final expectedIds = <String>{
    for (var index = 1; index <= 1050; index++) _agentId('PRO', index),
    for (var index = 1; index <= 1200; index++) _agentId('DEV', index),
    for (var index = 1; index <= 700; index++) _agentId('ADM', index),
    for (var index = 1; index <= 50; index++) _agentId('TRV', index),
  };
  if (ids.length != expectedIds.length || !ids.containsAll(expectedIds)) {
    findings.add('ID_RANGE_INVALID');
  }
  for (final entry in entries) {
    if (catalogFields.any((field) => !entry.containsKey(field))) {
      findings.add('MISSING_FIELD');
      break;
    }
    for (final field in <String>[
      'agent_id',
      'canonical_name',
      'display_name',
      'surface',
      'domain',
      'family',
      'function',
      'short_mission',
      'agent_type',
      'coordination_level',
      'activation_mode',
      'availability',
      'risk_level',
      'data_access_class',
      'tool_access_class',
      'memory_scope',
      'human_escalation',
      'prompt_status',
      'implementation_status',
      'historical_mapping',
      'lifecycle_status',
      'version',
    ]) {
      if ((entry[field]! as String).trim().isEmpty) {
        findings.add('EMPTY_REQUIRED_FIELD');
        break;
      }
    }
    if (!validSurfaces.contains(entry['surface']) ||
        !validAgentTypes.contains(entry['agent_type']) ||
        !validCoordinationLevels.contains(entry['coordination_level']) ||
        !validActivationModes.contains(entry['activation_mode']) ||
        !validAvailabilityStates.contains(entry['availability']) ||
        !validRiskLevels.contains(entry['risk_level']) ||
        !validDataAccessClasses.contains(entry['data_access_class']) ||
        !validToolAccessClasses.contains(entry['tool_access_class']) ||
        !validMemoryScopes.contains(entry['memory_scope']) ||
        !validPromptStatuses.contains(entry['prompt_status']) ||
        !validImplementationStatuses.contains(entry['implementation_status']) ||
        !validLifecycleStates.contains(entry['lifecycle_status'])) {
      findings.add('INVALID_ENUM');
    }
    final id = entry['agent_id']! as String;
    final parent = entry['reports_to']! as String;
    if (parent == id) findings.add('SELF_REPORTING');
    if (parent.isNotEmpty && parent != 'FOUNDER' && !ids.contains(parent)) {
      findings.add('UNKNOWN_PARENT');
    }
    if (parent.isNotEmpty && ids.contains(parent)) {
      final parentEntry = byId[parent]!;
      final crossesSurface = parentEntry['surface'] != entry['surface'];
      final isSurfaceLiaison =
          parent == 'AG-TRV-0001' &&
          entry['agent_type'] == 'SURFACE_COORDINATOR';
      if (crossesSurface && !isSurfaceLiaison) {
        findings.add('CROSS_SURFACE_PARENT_WITHOUT_LIAISON');
      }
    }
    final coordinates = entry['coordinates']! as List<Object?>;
    if (coordinates.any((coordinate) => !ids.contains(coordinate))) {
      findings.add('UNKNOWN_COORDINATE');
    }
    for (final coordinate in coordinates) {
      if (byId[coordinate]!['reports_to'] != id) {
        findings.add('NON_RECIPROCAL_COORDINATION');
      }
    }
    final words = (entry['short_mission']! as String)
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .length;
    if (words < 10 || words > 35) findings.add('MISSION_LENGTH_INVALID');
    final approvedDocumentaryPrompt = approvedDocumentaryPromptIds.contains(id);
    final expectedImplementation = approvedDocumentaryPrompt
        ? 'DOCUMENTED_ONLY'
        : 'NOT_IMPLEMENTED';
    if (entry['availability'] != 'NOT_AVAILABLE' ||
        entry['implementation_status'] != expectedImplementation) {
      findings.add('INITIAL_STATE_INVALID');
    }
    final historicalEntry = entry['historical_mapping'] != 'NONE';
    if (!historicalEntry &&
        !approvedDocumentaryPrompt &&
        (entry['prompt_status'] != 'NOT_CREATED' ||
            entry['lifecycle_status'] != 'CATALOGED')) {
      findings.add('NEW_AGENT_STATE_INVALID');
    }
    if (approvedDocumentaryPrompt &&
        (entry['prompt_status'] != 'PROMPT_CREATED' ||
            entry['lifecycle_status'] != 'PROMPT_CREATED')) {
      findings.add('APPROVED_DOCUMENTARY_PROMPT_STATE_INVALID');
    }
  }

  const coordinators = {
    'AG-PRO-0001': ('stasis', 'Stasis', 'PRODUCT', 'SURFACE_COORDINATOR'),
    'AG-DEV-0001': ('rector', 'Rector', 'DEVELOPMENT', 'SURFACE_COORDINATOR'),
    'AG-ADM-0001': (
      'gerendi',
      'Gerendi',
      'ADMINISTRATION',
      'SURFACE_COORDINATOR',
    ),
    'AG-TRV-0001': ('nexus', 'Nexus', 'TRANSVERSAL', 'GLOBAL_COORDINATOR'),
  };
  for (final coordinator in coordinators.entries) {
    final entry = byId[coordinator.key];
    final expected = coordinator.value;
    if (entry == null ||
        entry['canonical_name'] != expected.$1 ||
        entry['display_name'] != expected.$2 ||
        entry['surface'] != expected.$3 ||
        entry['agent_type'] != expected.$4) {
      findings.add('PRINCIPAL_COORDINATOR_INVALID');
    }
  }

  if (_hasParentCycle(entries)) findings.add('PARENT_CYCLE');
  final historicalEntries = entries
      .where((entry) => entry['historical_mapping'] != 'NONE')
      .toList();
  if (historicalEntries.length != 43 || historical.length != 43) {
    findings.add('HISTORICAL_MAPPING_COUNT_INVALID');
  }
  if (historicalEntries.any(
    (entry) =>
        entry['prompt_status'] != 'PROMPT_CREATED' ||
        entry['lifecycle_status'] != 'PROMPT_CREATED',
  )) {
    findings.add('HISTORICAL_PROMPT_STATE_INVALID');
  }
  if (entries.any(
    (entry) =>
        (entry['agent_type']! as String).contains('COORDINATOR') &&
        (entry['coordinates']! as List).isEmpty &&
        entry['agent_id'] != 'AG-TRV-0001',
  )) {
    findings.add('ORPHAN_COORDINATOR');
  }
  return findings.toSet().toList()..sort();
}

void _validateUnique(
  List<Map<String, Object?>> entries,
  String field,
  List<String> findings,
) {
  final values = entries.map((entry) => entry[field]).toList();
  if (values.toSet().length != values.length) {
    findings.add('DUPLICATE_${field.toUpperCase()}');
  }
}

bool _hasParentCycle(List<Map<String, Object?>> entries) {
  final parentById = {
    for (final entry in entries)
      entry['agent_id']! as String: entry['reports_to']! as String,
  };
  for (final id in parentById.keys) {
    final seen = <String>{};
    var current = id;
    while (current.isNotEmpty) {
      if (!seen.add(current)) return true;
      current = parentById[current] ?? '';
    }
  }
  return false;
}

Map<String, Object?> _readObject(String path) {
  final decoded = jsonDecode(File(path).readAsStringSync());
  if (decoded is! Map<String, Object?>) {
    throw const FormatException('CATALOG_SPEC_INVALID');
  }
  return decoded;
}

List<HistoricalAgent> _readHistoricalInventory() {
  final source = File(historicalInventoryPath).readAsLinesSync();
  final row = RegExp(
    r'^\| \d+ \| `([^`]+)` \| (.+?) \| FOUND \| PROMPT_CREATED \| '
    r'(Product|Development|Administration|Transversal) \| '
    r'(MIGRATE_AND_UPDATE|RECLASSIFY) \|$',
  );
  final agents = <HistoricalAgent>[];
  for (final line in source) {
    final match = row.firstMatch(line);
    if (match == null) continue;
    agents.add(
      HistoricalAgent(
        file: match.group(1)!,
        name: match.group(2)!,
        surface: match.group(3)!.toUpperCase(),
        action: match.group(4)!,
      ),
    );
  }
  if (agents.length != 43) {
    throw StateError('HISTORICAL_AGENT_INVENTORY_INVALID:${agents.length}');
  }
  return agents;
}

String _agentId(String prefix, int sequence) =>
    'AG-$prefix-${sequence.toString().padLeft(4, '0')}';

String _slug(String value) => value
    .toLowerCase()
    .replaceAll(RegExp('[^a-z0-9]+'), '_')
    .replaceAll(RegExp(r'^_+|_+$'), '');

String _title(String value) => value
    .replaceAll('_', ' ')
    .split(' ')
    .where((part) => part.isNotEmpty)
    .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
    .join(' ');

String _historicalType(String name) {
  final lower = name.toLowerCase();
  if (lower.contains('arquitect')) return 'ENGINEER';
  if (lower.contains('developer') || lower.contains('ingeniero')) {
    return 'ENGINEER';
  }
  if (lower.contains('revisor') || lower.contains('qa')) return 'REVIEWER';
  if (lower.contains('director') || lower.contains('owner')) return 'PLANNER';
  if (lower.contains('analista')) return 'ANALYST';
  if (lower.contains('designer')) return 'DESIGNER';
  if (lower.contains('customer success')) return 'SUPPORT_AGENT';
  return 'SPECIALIST';
}

String _activationMode(String functionName) {
  if (functionName == 'respond') return 'INCIDENT_TRIGGERED';
  if (functionName == 'safeguard') return 'RISK_TRIGGERED';
  if (functionName == 'monitor') return 'EVENT_TRIGGERED';
  if (functionName == 'audit') return 'SCHEDULED';
  return 'COORDINATOR_SELECTED';
}

String _risk(String surface, String domain, String topic) {
  final value = '$domain $topic'.toLowerCase();
  if (surface == 'TRANSVERSAL' ||
      value.contains('security') ||
      value.contains('incident') ||
      value.contains('clinical safety')) {
    return 'CRITICAL';
  }
  if (domain == 'health' ||
      value.contains('privacy') ||
      value.contains('fraud') ||
      value.contains('payment') ||
      value.contains('financial') ||
      value.contains('authorization')) {
    return 'HIGH';
  }
  if (surface == 'DEVELOPMENT' || surface == 'ADMINISTRATION') {
    return 'MODERATE';
  }
  return 'LOW';
}

String _dataAccess(String surface, String domain) {
  if (surface == 'PRODUCT' && domain == 'health') {
    return 'SENSITIVE_HEALTH_DATA';
  }
  if (surface == 'PRODUCT') return 'USER_SCOPED_DATA';
  if (surface == 'ADMINISTRATION') return 'ADMINISTRATIVE_DATA';
  if (surface == 'TRANSVERSAL' && domain == 'founder_liaison') {
    return 'FOUNDER_ONLY_DATA';
  }
  if (domain.contains('security') || domain.contains('privacy')) {
    return 'SECURITY_RESTRICTED_DATA';
  }
  return surface == 'DEVELOPMENT' ? 'NO_USER_DATA' : 'SURFACE_SCOPED_DATA';
}

String _toolAccess(String surface, String domain, String functionName) {
  if (surface == 'TRANSVERSAL' && domain == 'founder_liaison') {
    return 'FOUNDER_AUTHORIZED_TOOLS';
  }
  if (domain.contains('security') || domain.contains('fraud')) {
    return 'SECURITY_RESTRICTED_TOOLS';
  }
  if (functionName == 'operate' || functionName == 'respond') {
    return 'MUTATING_TOOLS_WITH_APPROVAL';
  }
  if (functionName == 'research' ||
      functionName == 'review' ||
      functionName == 'audit') {
    return 'READ_ONLY_TOOLS';
  }
  return 'NO_TOOLS';
}

String _memoryScope(String surface, String domain, bool coordinator) {
  if (surface == 'TRANSVERSAL' && domain == 'founder_liaison') {
    return 'FOUNDER_PRIVATE_MEMORY';
  }
  if (coordinator) return 'SURFACE_MEMORY';
  if (surface == 'PRODUCT' && domain == 'memory_personalization') {
    return 'AREA_MEMORY';
  }
  if (surface == 'PRODUCT') return 'AGENT_PRIVATE';
  return 'EPHEMERAL_TASK';
}

String _humanEscalation(String surface, String domain) {
  if (surface == 'PRODUCT' && domain == 'health') {
    return 'REQUIRED_FOR_MEDICAL_DECISIONS';
  }
  if (surface == 'TRANSVERSAL') return 'FOUNDER_APPROVAL_REQUIRED';
  if (surface == 'ADMINISTRATION' &&
      (domain.contains('finance') || domain.contains('roles_permissions'))) {
    return 'HUMAN_APPROVAL_REQUIRED';
  }
  return 'WHEN_OUT_OF_SCOPE_OR_HIGH_RISK';
}

String _schemaMarkdown() =>
    '''
# Agent Catalog Schema v1

## Contract

`AgentCatalogEntryV1` is metadata only. It grants no runtime, data, tool or
memory access.

| Field | Type | Required | Rule |
|---|---|---|---|
${catalogFields.map((field) => '| `$field` | ${field == 'coordinates' ? 'array<string>' : 'string'} | yes | Versioned catalog value |').join('\n')}

## Closed vocabularies

- Surfaces: ${validSurfaces.join(', ')}.
- Agent types: ${validAgentTypes.join(', ')}.
- Coordination levels: ${validCoordinationLevels.join(', ')}.
- Activation modes: ${validActivationModes.join(', ')}.
- Risk: ${validRiskLevels.join(', ')}.
- Data access: ${validDataAccessClasses.join(', ')}.
- Tool access: ${validToolAccessClasses.join(', ')}.
- Memory: ${validMemoryScopes.join(', ')}.
- Lifecycle: ${validLifecycleStates.join(', ')}.

IDs are immutable. `canonical_name` is stable and unique. Access classes state
future review requirements and never provision access.
''';

String _catalogJson(List<Map<String, Object?>> entries) =>
    '${const JsonEncoder.withIndent('  ').convert({'schema': 'AgentCatalogEntryV1', 'catalog_version': '1.0.0', 'generated_from': 'AGENT_CATALOG_GENERATION_SPEC_v1.json', 'entry_count': entries.length, 'entries': entries})}\n';

String _catalogCsv(List<Map<String, Object?>> entries) {
  final buffer = StringBuffer()..writeln(catalogFields.join(','));
  for (final entry in entries) {
    buffer.writeln(
      catalogFields
          .map((field) {
            final value = entry[field];
            return _csv(value is List ? value.join(';') : value.toString());
          })
          .join(','),
    );
  }
  return buffer.toString();
}

String _csv(String value) =>
    '"${value.replaceAll('"', '""').replaceAll('\n', ' ')}"';

String _masterMarkdown(List<Map<String, Object?>> entries) {
  final counts = _counts(entries, 'surface');
  return '''
# Agent Catalog Master v1

## Status

```text
Schema: AgentCatalogEntryV1
Catalog version: 1.0.0
Total: ${entries.length}
Individual prompt files generated by catalog generator: 0
Canonical Wave 1 prompts approved: ${entries.where((entry) => approvedWave1CoordinatorIds.contains(entry['agent_id'])).length}
Canonical Wave 2 prompts approved: ${entries.where((entry) => approvedWave2GovernanceIds.contains(entry['agent_id'])).length}
Canonical Wave 3 prompts approved: ${entries.where((entry) => approvedWave3ArchitectureIds.contains(entry['agent_id'])).length}
Canonical Wave 4 prompts approved: ${entries.where((entry) => approvedWave4ProductIds.contains(entry['agent_id'])).length}
Canonical Wave 5 prompts approved: ${entries.where((entry) => approvedWave5DevelopmentIds.contains(entry['agent_id'])).length}
Canonical Wave 6 prompts approved: ${entries.where((entry) => approvedWave6AdministrationIds.contains(entry['agent_id'])).length}
Prompt-created catalog records: ${entries.where((entry) => entry['prompt_status'] == 'PROMPT_CREATED').length}
Runtime agents created: 0
```

| Surface | Count |
|---|---:|
${counts.entries.map((entry) => '| ${entry.key} | ${entry.value} |').join('\n')}

The CSV and JSON files are canonical machine-readable views. Surface Markdown
files summarize domain/family coverage. Cataloged access classes are future
review metadata, not permissions.
''';
}

String _surfaceMarkdown(List<Map<String, Object?>> entries, String surface) {
  final selected = entries
      .where((entry) => entry['surface'] == surface)
      .toList();
  final domainCounts = _counts(selected, 'domain');
  final familyCounts = _counts(selected, 'family');
  return '''
# $surface Agent Catalog v1

```text
Entries: ${selected.length}
Lifecycle: CATALOGED except approved Wave 1 coordinator and historical prompt records
Availability default: NOT_AVAILABLE
```

## Domain allocation

| Domain | Count |
|---|---:|
${domainCounts.entries.map((entry) => '| ${entry.key} | ${entry.value} |').join('\n')}

## Family coverage

| Family | Count |
|---|---:|
${familyCounts.entries.map((entry) => '| ${entry.key} | ${entry.value} |').join('\n')}
''';
}

Map<String, int> _counts(List<Map<String, Object?>> entries, String field) {
  final counts = <String, int>{};
  for (final entry in entries) {
    final value = entry[field]! as String;
    counts[value] = (counts[value] ?? 0) + 1;
  }
  return Map.fromEntries(
    counts.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
  );
}

String _historicalCrosswalk(
  List<Map<String, Object?>> entries,
  List<HistoricalAgent> historical,
) {
  final byPath = {
    for (final entry in entries)
      if (entry['historical_mapping'] != 'NONE')
        entry['historical_mapping']! as String: entry,
  };
  final buffer = StringBuffer()
    ..writeln('# Historical 43 Agent Crosswalk v1')
    ..writeln()
    ..writeln('```text')
    ..writeln('Historical source commit: $historicalSourceCommit')
    ..writeln('Mapped: ${historical.length}/43')
    ..writeln('Prompts copied or generated: 0')
    ..writeln('```')
    ..writeln()
    ..writeln(
      '| historical_file | historical_name | historical_commit_or_source | '
      'new_agent_id | '
      'new_canonical_name | new_surface | new_domain | migration_decision | '
      'prompt_status | required_changes | duplication_status | notes |',
    )
    ..writeln('|---|---|---|---|---|---|---|---|---|---|---|---|');
  for (final agent in historical) {
    final path =
        'docs/archive/discovery/stasisly_definition/agents/${agent.file}';
    final entry = byPath[path]!;
    buffer.writeln(
      '| `${agent.file}` | ${agent.name} | `$historicalSourceCommit` | '
      '${entry['agent_id']} | `${entry['canonical_name']}` | '
      '${entry['surface']} | ${entry['domain']} | ${agent.action} | '
      'PROMPT_CREATED | '
      'Revalidate scope, safety, tools and prompt against Re-foundation | '
      'NO_DUPLICATE | Preserved by reference; not available or active |',
    );
  }
  return buffer.toString();
}

String _duplicationReport(List<Map<String, Object?>> entries) {
  final ids = entries.map((entry) => entry['agent_id']).toSet().length;
  final canonical = entries
      .map((entry) => entry['canonical_name'])
      .toSet()
      .length;
  final display = entries.map((entry) => entry['display_name']).toSet().length;
  final missions = entries
      .map((entry) => entry['short_mission'])
      .toSet()
      .length;
  return '''
# Agent Duplication Report v1

| Check | Unique | Total | Classification |
|---|---:|---:|---|
| Agent IDs | $ids | ${entries.length} | NO_DUPLICATE |
| Canonical names | $canonical | ${entries.length} | NO_DUPLICATE |
| Display names | $display | ${entries.length} | NO_DUPLICATE |
| Missions | $missions | ${entries.length} | NO_DUPLICATE |

Deterministic combinations were reviewed by domain, family, function and
context. Similar functions across different specialties are
`INTENTIONAL_SPECIALIZATION`, not automatic merge candidates. Historical
entries map once and remain `NO_DUPLICATE`. No merge is performed by this
package; future semantic overlap review remains part of prompt-wave approval.
''';
}

String _coverageGapReport() => '''
# Agent Coverage Gaps v1

The 3,000-record count does not imply complete operational coverage.

| Surface | Domain | Family | Missing capability/evidence | Risk | Recommended action |
|---|---|---|---|---|---|
| PRODUCT | health | all clinical families | Clinician review of future prompts by jurisdiction | CRITICAL | Required before prompt wave |
| PRODUCT | integrations | device ecosystem | Vendor-specific contracts and consent validation | HIGH | Design per provider |
| DEVELOPMENT | regional architecture | data residency | Country-by-country legal placement matrix | HIGH | STASISLY-DATA package |
| DEVELOPMENT | AI evaluation | model behavior | Provider/model-specific benchmark evidence | HIGH | Evaluation wave |
| ADMINISTRATION | legal compliance | jurisdictions | Local counsel validation | CRITICAL | Market launch gate |
| ADMINISTRATION | finance | tax operations | Country-specific tax rules | HIGH | Market-specific catalog extension |
| TRANSVERSAL | resilience | systemic recovery | Operational exercises and measured RTO/RPO | CRITICAL | Future resilience package |
| TRANSVERSAL | Founder control | emergency mode | Implemented console and audit evidence | CRITICAL | Separate architecture package |

Structural families required by RF-002 are represented. These residual gaps do
not justify runtime availability and must be resolved before affected prompt or
deployment waves.
''';

String _lifecycleGovernance() => '''
# Agent Lifecycle and Governance v1

## Allowed lifecycle

`CATALOGED → DESIGNED → PROMPT_CREATED → CONFIGURED → TESTED → AVAILABLE → ACTIVE`

Return and retirement paths are `ACTIVE → AVAILABLE`,
`AVAILABLE ↔ SUSPENDED`, `SUSPENDED → RETIRED`, `AVAILABLE → RETIRED`, and
`RETIRED → ARCHIVED`.

`CATALOGED → ACTIVE`, `ARCHIVED → ACTIVE`, and `RETIRED → PROMPT_CREATED` are
forbidden without an extraordinary, versioned recovery process.

## New-agent process

```text
identify gap → search catalog → compare overlap → justify capability
→ assign taxonomy and owner → review risk → approve CATALOGED entry
→ create prompt in a later package
```

## Activation

The default team is `MINIMUM_SUFFICIENT`. Selection requires task, surface,
environment, authority, risk, data/tool class, cost and human escalation checks.
Catalog metadata grants no access. Every future wave requires separate Founder
approval.

## Proposed waves

1. Global and surface coordinators.
2. Security, architecture and governance.
3. Product core and Stasis.
4. Development core.
5. Administration core.
6. Specialized domains in evidence-driven increments.
''';

String _validationReport(
  List<Map<String, Object?>> entries,
  List<HistoricalAgent> historical,
) {
  final historicalEntries = entries.where(
    (entry) => entry['historical_mapping'] != 'NONE',
  );
  return '''
# Agent Catalog Validation Report v1

```text
Product: ${entries.where((entry) => entry['surface'] == 'PRODUCT').length}
Development: ${entries.where((entry) => entry['surface'] == 'DEVELOPMENT').length}
Administration: ${entries.where((entry) => entry['surface'] == 'ADMINISTRATION').length}
Transversal: ${entries.where((entry) => entry['surface'] == 'TRANSVERSAL').length}
Total: ${entries.length}
Unique agent_id: ${entries.map((entry) => entry['agent_id']).toSet().length}
Unique canonical_name: ${entries.map((entry) => entry['canonical_name']).toSet().length}
Unique display_name: ${entries.map((entry) => entry['display_name']).toSet().length}
Unique short_mission: ${entries.map((entry) => entry['short_mission']).toSet().length}
Missing required fields: 0
Unknown surfaces: 0
Invalid lifecycle: 0
Invalid ID ranges: 0
Invalid mission lengths: 0
Self-reporting agents: 0
Broken parent references: 0
Coordination cycles: 0
Cross-surface parents without liaison: 0
Non-reciprocal coordinates: 0
Orphan coordinators: 0
Historical agents mapped: ${historicalEntries.length}/${historical.length}
Historical prompts preserved: 43
Canonical Wave 1 prompts approved: ${entries.where((entry) => approvedWave1CoordinatorIds.contains(entry['agent_id'])).length}
Canonical Wave 2 prompts approved: ${entries.where((entry) => approvedWave2GovernanceIds.contains(entry['agent_id'])).length}
Canonical Wave 3 prompts approved: ${entries.where((entry) => approvedWave3ArchitectureIds.contains(entry['agent_id'])).length}
Canonical Wave 4 prompts approved: ${entries.where((entry) => approvedWave4ProductIds.contains(entry['agent_id'])).length}
Canonical Wave 5 prompts approved: ${entries.where((entry) => approvedWave5DevelopmentIds.contains(entry['agent_id'])).length}
Canonical Wave 6 prompts approved: ${entries.where((entry) => approvedWave6AdministrationIds.contains(entry['agent_id'])).length}
Prompt-created catalog records: ${entries.where((entry) => entry['prompt_status'] == 'PROMPT_CREATED').length}
Runtime agents created: 0
```

Quantitative validation passes. Qualitative coverage includes medical safety,
security, marketing/growth, data routing/sharding, surface ownership, human
escalation and Founder control. Residual evidence gaps are tracked separately
and prevent automatic availability.
''';
}

final class FunctionVariant {
  const FunctionVariant(this.key, this.label, this.verb, this.agentType);

  final String key;
  final String label;
  final String verb;
  final String agentType;
}

final class HistoricalAgent {
  const HistoricalAgent({
    required this.file,
    required this.name,
    required this.surface,
    required this.action,
  });

  final String file;
  final String name;
  final String surface;
  final String action;
}
