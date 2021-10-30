// 🎯 Dart imports:
import 'dart:io';

// 📦 Package imports:
import 'package:args/args.dart';
import 'package:tint/tint.dart';
import 'package:yaml/yaml.dart';

// 🌎 Project imports:
import 'package:import_path_converter/args.dart' as local_args;
import 'package:import_path_converter/files.dart' as files;
import 'package:import_path_converter/convert.dart' as convert;

void main(List<String> args) {
  // Parsing arguments
  final parser = ArgParser();
  parser.addFlag('relative', abbr: 'r', negatable: false);
  parser.addFlag('ignore-config', negatable: false);
  parser.addFlag('help', abbr: 'h', negatable: false);
  parser.addFlag('exit-if-changed', negatable: false);
  final argResults = parser.parse(args).arguments;
  if (argResults.contains('-h') || argResults.contains('--help')) {
    local_args.outputHelp();
  }

  final currentPath = Directory.current.path;
  /*
  Getting the package name and dependencies/dev_dependencies
  Package name is one factor used to identify project imports
  Dependencies/dev_dependencies names are used to identify package imports
  */
  final pubspecYamlFile = File('${currentPath}/pubspec.yaml');
  final pubspecYaml = loadYaml(pubspecYamlFile.readAsStringSync());

  // Getting all dependencies and project package name
  final packageName = pubspecYaml['name'];
  final dependencies = [];

  final stopwatch = Stopwatch();
  stopwatch.start();

  final pubspecLockFile = File('${currentPath}/pubspec.lock');
  final pubspecLock = loadYaml(pubspecLockFile.readAsStringSync());
  dependencies.addAll(pubspecLock['packages'].keys);

  bool isRelative = false;
  final ignored_files = [];

  // Reading from config in pubspec.yaml safely
  if (!argResults.contains('--ignore-config')) {
    if (pubspecYaml.containsKey('import_path_converter')) {
      final config = pubspecYaml['import_path_converter'];
      if (config.containsKey('relative')) isRelative = config['relative'];
      if (config.containsKey('ignored_files')) {
        ignored_files.addAll(config['ignored_files']);
      }
    }
  }

  // Setting values from args
  if (!isRelative) isRelative = argResults.contains('-r');
  final exitOnChange = argResults.contains('--exit-if-changed');

  // Getting all the dart files for the project
  final dartFiles = files.dartFiles(currentPath, args);
  final containsFlutter = dependencies.contains('flutter');
  final containsRegistrant = dartFiles
      .containsKey('${currentPath}/lib/generated_plugin_registrant.dart');

  stdout.writeln('contains flutter: ${containsFlutter}');
  stdout.writeln('contains registrant: ${containsRegistrant}');

  if (containsFlutter && containsRegistrant) {
    dartFiles.remove('${currentPath}/lib/generated_plugin_registrant.dart');
  }

  for (final pattern in ignored_files) {
    dartFiles.removeWhere((key, _) =>
        RegExp(pattern).hasMatch(key.replaceFirst(currentPath, '')));
  }

  stdout.write('┏━━ Converting ${dartFiles.length} dart files');

  // Converting and writing to files
  final convertedFiles = [];
  final success = '✔'.green();

  for (final filePath in dartFiles.keys) {
    final file = dartFiles[filePath];
    if (file == null) {
      continue;
    }

    final convertedFile = convert.convertImports(
        file.readAsLinesSync(), packageName, isRelative, exitOnChange, filePath);
    if (!convertedFile.updated) {
      continue;
    }
    dartFiles[filePath]?.writeAsStringSync(convertedFile.convertedFile);
    convertedFiles.add(filePath);
  }

  stopwatch.stop();

  // Outputting results
  if (convertedFiles.length > 1) {
    stdout.write("\n");
  }
  for (int i = 0; i < convertedFiles.length; i++) {
    final file = dartFiles[convertedFiles[i]];
    stdout.write(
        '${convertedFiles.length == 1 ? '\n' : ''}┃  ${i == convertedFiles.length - 1 ? '┗' : '┣'}━━ ${success} Converted imports for ${file?.path.replaceFirst(currentPath, '')}/');
    String filename = file!.path.split(Platform.pathSeparator).last;
    stdout.write(filename + "\n");
  }

  if (convertedFiles.length == 0) {
    stdout.write("\n");
  }
  stdout.write(
      '┗━━ ${success} Converted ${convertedFiles.length} files in ${stopwatch.elapsed.inSeconds}.${stopwatch.elapsedMilliseconds} seconds\n');
}