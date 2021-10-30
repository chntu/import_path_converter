<!-- DO NOT REMOVE - contributor_list:data:start:["gleich", "lig", "bartekpacia", "ImgBotApp", "jlnrrg", "vHanda", "lsaudon"]:end -->

```txt
 ___  _____ ______   ________  ________  ________  _________        ________  ________  _________  ___  ___
|\  \|\   _ \  _   \|\   __  \|\   __  \|\   __  \|\___   ___\     |\   __  \|\   __  \|\___   ___\\  \|\  \
\ \  \ \  \\\__\ \  \ \  \|\  \ \  \|\  \ \  \|\  \|___ \  \_|     \ \  \|\  \ \  \|\  \|___ \  \_\ \  \\\  \
 \ \  \ \  \\|__| \  \ \   ____\ \  \\\  \ \   _  _\   \ \  \       \ \   ____\ \   __  \   \ \  \ \ \   __  \
  \ \  \ \  \    \ \  \ \  \___|\ \  \\\  \ \  \\  \|   \ \  \       \ \  \___|\ \  \ \  \   \ \  \ \ \  \ \  \
   \ \__\ \__\    \ \__\ \__\    \ \_______\ \__\\ _\    \ \__\       \ \__\    \ \__\ \__\   \ \__\ \ \__\ \__\
    \|__|\|__|     \|__|\|__|     \|_______|\|__|\|__|    \|__|        \|__|     \|__|\|__|    \|__|  \|__|\|__|

 ________  ________  ________   ___      ___ _______   ________  _________  _______   ________
|\   ____\|\   __  \|\   ___  \|\  \    /  /|\  ___ \ |\   __  \|\___   ___\\  ___ \ |\   __  \
\ \  \___|\ \  \|\  \ \  \\ \  \ \  \  /  / | \   __/|\ \  \|\  \|___ \  \_\ \   __/|\ \  \|\  \
 \ \  \    \ \  \\\  \ \  \\ \  \ \  \/  / / \ \  \_|/_\ \   _  _\   \ \  \ \ \  \_|/_\ \   _  _\
  \ \  \____\ \  \\\  \ \  \\ \  \ \    / /   \ \  \_|\ \ \  \\  \|   \ \  \ \ \  \_|\ \ \  \\  \|
   \ \_______\ \_______\ \__\\ \__\ \__/ /     \ \_______\ \__\\ _\    \ \__\ \ \_______\ \__\\ _\
    \|_______|\|_______|\|__| \|__|\|__|/       \|_______|\|__|\|__|    \|__|  \|_______|\|__|\|__|
```

# import_path_converter

🎯 Dart package to automatically organize your dart imports. Any dart project supported! Will convert relative path imports into package imports and vice versa.

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

## 🚀 Installing

Simply add `import_path_converter: ^1.0.0` to your `pubspec.yaml`'s `dev_dependencies`.

## 🏃‍♂️ Running

Once you've installed it simply run `flutter pub run import_path_converter:main` (`pub run import_path_converter:main` if normal dart application) to format every file dart file in your lib, bin, test, and tests folder! Don't worry if these folders don't exist.

## 💻 Command Line

- If you're using a config in the `pubspec.yaml` you can have the program ignore it by adding `--ignore-config`.
- Want to make sure your files are converter? Add `--exit-if-changed` to make sure the files are converted. Good for things like CI.
- Add the `-h` flag if you need any help from the command line!
- You can only run import_path_converter on certain files by passing in a regular expression(s) that will only convert certain files. Below are two examples:
  - `pub run import_path_converter:main bin/main.dart lib/args.dart` (only convert paths in bin/main.dart and lib/args.dart)
  - `pub run import_path_converter:main lib\/* test\/*` (only convert paths in the lib and test folders)

## 🏗️ Config

If you use import_path_converter a lot or need to ignore certain files you should look at using the config you put in your `pubspec.yaml`. Ignored files are in the format of regex. This regex is then applied to the project root path (the one outputted to the terminal). Below is an example config setting relative to true and ignoring all files in the lib folder:

```yaml
import_path_converter:
  relative: true # Select relative path import or package import(Optional, defaults to false)
  ignored_files: # Add files to ignore(Optional, defaults to [])
    - \/lib\/*
```

## 🙋‍♀️🙋‍♂️ Contributing

All contributions are welcome! Just make sure that it's not an already existing issue or pull request.
