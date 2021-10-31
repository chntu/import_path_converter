# import_path_converter

A flutter utility to automatically convert relative ⇔ absolute path.

Forked/Inspired by @gleich's [import_sorter](https://github.com/fluttercommunity/import_sorter).

Below is an example:

### Before

```dart
import 'common/constants.dart' ;
import '../app.dart';
```

### After

```dart
import 'package:example/common/constants.dart';
import 'package:example/app.dart';
```

## Installing

Run this command:

`flutter pub add --dev import_path_converter`

This will add a line like this to dev_dependencies in your pubspec.yaml.

```yaml
dev_dependencies:
  import_path_converter: ^1.0.0
```

## Running

Once you've installed it simply run `flutter pub run import_path_converter:main` (`pub run import_path_converter:main` if normal dart application) to format every file dart file in your lib, bin, test, and tests folder!

## Command Line

- If you're using a config in the `pubspec.yaml` you can have the program ignore it by adding `--ignore-config`.
- Want to make sure your files are converted? Add `--exit-if-changed` to make sure the files are converted. Good for things like CI.
- Add the `-h` flag if you need any help from the command line!
- You can only run import_path_converter on certain files by passing in a regular expression(s) that will only convert paths in certain files. Below are two examples:
  - `pub run import_path_converter:main bin/main.dart lib/args.dart` (only convert paths in bin/main.dart and lib/args.dart)
  - `pub run import_path_converter:main lib\/* test\/*` (only convert paths in the lib and test folders)

## Config

Below is an example of pubspec.yaml.

```yaml
import_path_converter:
  relative: true # Select relative path import or package import(default: false)
  ignored_files: # Add files to ignore(default: [])
    - \/lib\/*
```
