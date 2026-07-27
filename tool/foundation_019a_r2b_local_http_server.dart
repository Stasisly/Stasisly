import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> arguments) async {
  if (arguments.length != 1) {
    stderr.writeln('Usage: dart run <server> <port-file>');
    exitCode = 64;
    return;
  }

  final portFile = File(arguments.single);
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
  portFile.writeAsStringSync('${server.port}\n', flush: true);

  await for (final request in server) {
    if (request.uri.path == '/shutdown') {
      request.response.statusCode = HttpStatus.noContent;
      await request.response.close();
      await server.close(force: true);
      return;
    }

    await Future<void>.delayed(const Duration(milliseconds: 450));
    final body = jsonEncode({
      'id': '00000000-0000-4000-8000-000000000001',
      'kind': 'synthetic',
      'padding': 'x' * 320,
    });
    request.response
      ..statusCode = HttpStatus.ok
      ..headers.contentType = ContentType.json
      ..write(body);
    await request.response.close();
  }
}
