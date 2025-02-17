import 'dart:io';

import 'package:native_toolchain_rust/native_toolchain_rust.dart';
import 'package:native_assets_cli/native_assets_cli.dart';

void main(List<String> args) async {
  try {
    await build(args, (BuildConfig buildConfig, BuildOutput output) async {
      final builder = RustBuilder(
        // The ID of native assets consists of package name and crate name.
        package: 'dart_ffi_createwindow',
        cratePath: 'rust',
        buildConfig: buildConfig,
      );
      await builder.run(output: output);
    });
  } catch (e) {
    stderr.writeln(e);
    exitCode = 1;
  }
}
