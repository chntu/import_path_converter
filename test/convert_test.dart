// 🎯 Dart imports:
import 'dart:io';

// 📦 Package imports:
import 'package:test/test.dart';

// 🌎 Project imports:
import 'package:import_path_converter/convert.dart';

void tester() {
  const packageName = 'import_path_converter_test';

  // Imports:
  const relativeImports = '''
import 'anotherFile.dart' as af;
import 'anotherFile2.dart';
''';

  const packageImports = '''
import 'package:import_path_converter_test/anotherFile.dart' as af;
import 'package:import_path_converter_test/anotherFile2.dart';
''';

  const sampleProgram = '''
void main(List<String> args) async {
  final stopwatch = Stopwatch();
  stopwatch.start();

  final currentPath = Directory.current.path;
  /*
  Getting the package name and dependencies/dev_dependencies
  Package name is one factor used to identify project imports
  Dependencies/dev_dependencies names are used to identify package imports
  */
  final pubspecYamlFile = File('\${currentPath}/pubspec.yaml');
  final pubspecYaml = loadYaml(pubspecYamlFile.readAsStringSync());
}''';

  final filePath = '${Directory.current.path}/lib/test.dart';

  test(
    'No imports and no code',
    () {
      expect(
        convertImports(
          [],
          packageName,
          false,
          false,
          filePath,
        ).convertedFile,
        '',
      );
    },
  );
  test(
    'No imports',
    () {
      expect(
          convertImports(
            sampleProgram.split('\n'),
            packageName,
            false,
            false,
            filePath,
          ).convertedFile,
          '$sampleProgram');
    },
  );
  test(
    'Single code line',
    () {
      expect(
        convertImports(
          ['enum HomeEvent { showInfo, showDiscover, showProfile }', ''],
          packageName,
          false,
          false,
          filePath,
        ).convertedFile,
        'enum HomeEvent { showInfo, showDiscover, showProfile }\n',
      );
    },
  );
  test(
    'No code, convert relative imports into package imports',
    () {
      expect(
        convertImports(
          '$relativeImports\n'.split('\n'),
          packageName,
          false,
          false,
          filePath,
        ).convertedFile,
        '$packageImports\n',
      );
    },
  );
  test(
    'No code, convert package imports into relative imports',
    () {
      expect(
        convertImports(
          '$packageImports\n'.split('\n'),
          packageName,
          true,
          false,
          filePath,
        ).convertedFile,
        '$relativeImports\n',
      );
    },
  );
  test(
    'Convert relative imports into package imports',
    () {
      expect(
        convertImports(
          '$sampleProgram\n$relativeImports\n'.split('\n'),
          packageName,
          false,
          false,
          filePath,
        ).convertedFile,
        '$sampleProgram\n$packageImports\n',
      );
    },
  );
  test(
    'Convert package imports into relative imports',
    () {
      expect(
        convertImports(
          '$sampleProgram\n$packageImports\n'.split('\n'),
          packageName,
          true,
          false,
          filePath,
        ).convertedFile,
        '$sampleProgram\n$relativeImports\n',
      );
    },
  );
}

void main() {
  group(
    'test',
    () => tester(),
  );
}
