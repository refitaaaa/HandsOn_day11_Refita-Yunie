import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:working_with_asset/main.dart';

void main() {
  testWidgets('App builds and shows main screen', (WidgetTester tester) async {
    // Build the main app widget
    await tester.pumpWidget(const MyApp());

    // Verifikasi: aplikasi berhasil dirender
    expect(find.byType(MaterialApp), findsOneWidget);

    // Pastikan AppBar atau judul utama muncul
    expect(find.text('Adaptive Layout'), findsOneWidget);

    // Pastikan tidak ada error widget (seperti "RenderFlex overflowed")
    expect(tester.takeException(), isNull);
  });
}
