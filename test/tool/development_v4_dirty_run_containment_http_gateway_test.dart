import 'package:flutter_test/flutter_test.dart';

import '../../tool/development_v4_dirty_run_containment_contracts.dart';
import '../../tool/development_v4_dirty_run_containment_http_gateway.dart';

void main() {
  final identity = V4RunIdentity.reconstruct('gateway-test-run');
  final owner = ['00000000', '0000', '4000', '8000', '000000000001'].join('-');
  final conversation = [
    '00000000',
    '0000',
    '4000',
    '8000',
    '000000000002',
  ].join('-');

  test('post-delete counters retain exact in-memory run handles', () async {
    final transport = _ScriptedTransport([
      _json(200, [
        {
          'subject_id': owner,
          'operation_id': 'create_conversation',
          'idempotency_key': 'gateway-test-run_create_0001',
          'result_reference': conversation,
          'state': 'completed',
        },
      ]),
      _json(200, [
        {'id': owner, 'display_name': 'Synthetic gateway-test-run'},
      ]),
      _json(200, [
        {'id': conversation, 'user_id': owner},
      ]),
      _json(200, const []),
      _json(404, null),
      _json(204, null),
      _json(204, null),
      _json(204, null),
      _json(200, const []),
      _json(200, const []),
      _json(200, const []),
      _json(200, const []),
      _json(404, null),
    ]);
    final gateway = _gateway(transport);
    final initial = await gateway.readSevenCounters(identity);
    final plan = const V4ExactContainmentPlanner().plan(initial);
    expect(plan.map((operation) => operation.resource), [
      'idempotency',
      'sessions',
      'profiles',
    ]);
    for (final operation in plan) {
      expect(await gateway.deleteExact(operation), isTrue);
    }
    final finalSnapshot = await gateway.readSevenCounters(identity);
    expect(finalSnapshot.allZero, isTrue);
    expect(transport.remaining, 0);
  });

  test('initial loss of every exact identity source blocks counters', () async {
    final transport = _ScriptedTransport([
      _json(200, const []),
      _json(200, const []),
    ]);
    final snapshot = await _gateway(transport).readSevenCounters(identity);
    expect(snapshot.counters[0].result, V4CounterResult.unknownBlocking);
    expect(snapshot.counters[2].result, V4CounterResult.unknownBlocking);
    expect(snapshot.hasUnknown, isTrue);
    expect(transport.remaining, 0);
  });

  test('conflicting exact owner proofs fail closed', () async {
    final otherOwner = [
      '00000000',
      '0000',
      '4000',
      '8000',
      '000000000003',
    ].join('-');
    final transport = _ScriptedTransport([
      _json(200, [
        {
          'subject_id': owner,
          'operation_id': 'create_conversation',
          'idempotency_key': 'gateway-test-run_create_0001',
          'result_reference': conversation,
          'state': 'completed',
        },
      ]),
      _json(200, [
        {'id': otherOwner, 'display_name': 'Synthetic gateway-test-run'},
      ]),
    ]);
    final snapshot = await _gateway(transport).readSevenCounters(identity);
    expect(snapshot.hasUnknown, isTrue);
    expect(transport.remaining, 0);
  });

  test(
    'exact delete accepts idempotent statuses and rejects unexpected status',
    () async {
      for (final scenario in [
        (status: 200, expected: true),
        (status: 404, expected: true),
        (status: 409, expected: false),
      ]) {
        final transport = _ScriptedTransport([_json(scenario.status, null)]);
        final gateway = _gateway(transport);
        final result = await gateway.deleteExact(
          V4ContainmentOperation(
            resource: 'sessions',
            handle: V4OpaqueHandle.exact('sessions', '$conversation|$owner'),
          ),
        );
        expect(result, scenario.expected);
      }
    },
  );
}

HttpV4DirtyRunContainmentGateway _gateway(_ScriptedTransport transport) =>
    HttpV4DirtyRunContainmentGateway(
      baseUrl: Uri.parse('https://local.invalid'),
      serviceRoleKey: 'test-only-non-secret',
      transport: transport.call,
    );

V4ContainmentHttpResponse _json(int status, Object? body) =>
    V4ContainmentHttpResponse(status, body);

final class _ScriptedTransport {
  _ScriptedTransport(this._responses);

  final List<V4ContainmentHttpResponse> _responses;
  int _index = 0;

  int get remaining => _responses.length - _index;

  Future<V4ContainmentHttpResponse> call(String method, Uri uri) async {
    if (_index >= _responses.length) {
      throw StateError('UNEXPECTED_TEST_REQUEST');
    }
    return _responses[_index++];
  }
}
