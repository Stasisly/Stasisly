import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:stasisly/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // TODO(setup): Initialize Supabase here via env variables
  await Supabase.initialize(
    url: 'https://stasisly-dummy.supabase.co',
    anonKey: 'dummy-anon-key-for-ui-testing',
  );
  // TODO(setup): Initialize Firebase Auth here
  // TODO(setup): Initialize Sentry here
  
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
