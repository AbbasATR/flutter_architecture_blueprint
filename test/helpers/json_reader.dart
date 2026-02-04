import 'dart:io';

/// Helper function to read JSON files from the fixtures directory
/// Usage: fixture('auth/auth_tokens.json')
String fixture(String name) => File('test/fixtures/$name').readAsStringSync();
