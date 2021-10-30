// 🎯 Dart imports:
import 'dart:io';

// 📦 Package imports:
import 'package:path/path.dart' as p;

/// Convert the import paths
/// Returns the converted file as a string at
/// index 0 and the number of converted imports
/// at index 1
ImportConvertData convertImports(
  List<String> lines,
  String packageName,
  bool toRelative,
  bool exitIfChanged,
  String filePath,
) {
  bool isMultiLineString = false;
  final convertedLines = <String>[];

  for (var i = 0; i < lines.length; i++) {
    // Check if line is in multiline string
    if (_timesContained(lines[i], "'''") == 1 ||
        _timesContained(lines[i], '"""') == 1) {
      isMultiLineString = !isMultiLineString;
    }

    if (lines[i].startsWith('import') &&
        lines[i].endsWith(';') &&
        !isMultiLineString) {
      // Convert import path
      convertedLines
          .add(_convertPath(lines[i], toRelative, packageName, filePath));
    } else {
      convertedLines.add(lines[i]);
    }
  }

  final convertedFile = convertedLines.join('\n');
  final original = lines.join('\n') + '\n';
  if (exitIfChanged && original != convertedFile) {
    if (filePath != null) {
      stdout.writeln(
          '\n┗━━🚨 File ${filePath} does not have its imports converted.');
    }
    exit(1);
  }
  if (original == convertedFile) {
    return ImportConvertData(original, false);
  }

  return ImportConvertData(convertedFile, true);
}

/// Get the number of times a string contains another
/// string
int _timesContained(String string, String looking) =>
    string.split(looking).length - 1;

/// Convert to relative path import or package import
String _convertPath(
    String line, bool toRelative, String projectName, String filePath) {
  String importPath = line.split(RegExp(r"\'*\'"))[1];

  final fileDir = p.dirname(filePath);
  final libDir = '${Directory.current.path}/lib/';

  final packagePrefix = 'package:$projectName/';

  if (toRelative) {
    // convert to relative path import
    if (importPath.contains(packagePrefix)) {
      importPath = importPath.replaceAll(packagePrefix, libDir);
      importPath = p.relative(importPath, from: fileDir);
    } else {
      return line;
    }
  } else {
    // convert to package import
    if (!importPath.contains(':')) {
      importPath = p.normalize(fileDir + '/' + importPath + '/');
      importPath = importPath.replaceAll(libDir, packagePrefix);
    } else {
      return line;
    }
  }

  final splittedPath = line.split(RegExp(r"\'*\'"));
  splittedPath[1] = "'$importPath'";

  return splittedPath.join();
}

/// Data to return from a convert
class ImportConvertData {
  final String convertedFile;
  final bool updated;

  const ImportConvertData(this.convertedFile, this.updated);
}