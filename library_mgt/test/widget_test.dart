import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:library_mgt/main.dart';

void main() {
  testWidgets(
    'theme uses surface colors for scaffold, navigation bar, bottom sheet, and dialog',
    (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final context = tester.element(find.byType(MaterialApp).first);
      final theme = Theme.of(context);

      expect(theme.scaffoldBackgroundColor, theme.colorScheme.surface);
      expect(
        theme.navigationBarTheme.backgroundColor,
        theme.colorScheme.surface,
      );
      expect(theme.bottomSheetTheme.backgroundColor, theme.colorScheme.surface);
      expect(theme.dialogTheme.backgroundColor, theme.colorScheme.surface);
    },
  );
}
