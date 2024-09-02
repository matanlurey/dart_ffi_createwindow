@DefaultAsset('package:dart_ffi_createwindow/ffi_createwindow')
library;

import 'dart:ffi';
import 'dart:io' as io;

/// Uses ABI to add two numbers on the current thread.
@Native<Int32 Function(Int32, Int32)>()
external int ffi_sum_on_current_thread(int a, int b);

/// Uses ABI to add two numbers on the _main_ thread.
///
/// On MacOS, this is implemented by using libdispatch to dispatch the work to
/// the main thread.
@Native<Int32 Function(Int32, Int32)>()
external int ffi_sum_on_main_thread(int a, int b);

void main() async {
  if (!io.Platform.isMacOS) {
    io.stderr.writeln('This example project is intended to only run on MacOS');
    io.exitCode = 1;
    return;
  }

  if (Abi.current() != Abi.macosArm64) {
    io.stderr.writeln('This example project was only tested on MacOS ARM64');
  }

  // Try using ffi_sum_on_current_thread to test the FFI is working.
  try {
    final result = ffi_sum_on_current_thread(1, 2);
    io.stdout.writeln('ffi_sum_on_current_thread(1, 2) = $result');
  } on ArgumentError catch (_) {
    final file = io.File('rust/target/debug/libffi_createwindow.dylib');
    io.stderr.writeln(
      '--enable-experiments=native-assets not used or configured correctly. '
      '\nFalling back to DynamicLibrary.open(${file.path})',
    );
    if (!file.existsSync()) {
      io.stderr.writeln('No output found in ${file.path}');
      io.stderr.writeln('Refer to the project README for instructions');
      io.exitCode = 1;
      return;
    }

    try {
      DynamicLibrary.open(file.absolute.path);
      final result = ffi_sum_on_current_thread(1, 2);
      io.stdout.writeln('ffi_sum_on_current_thread(1, 2) = $result');
    } catch (e) {
      io.stderr.writeln('Failed to dynamically link libffi.dylib: $e');
      io.exitCode = 1;
      return;
    }
  }

  // Now showcase that using the main thread isn't possible.
  io.stdout.writeln('Trying to compute 1 + 2 on the main thread');
  io.stdout.writeln('The program will hang...');
  final result = ffi_sum_on_main_thread(1, 2);
  io.stdout.writeln('ffi_sum_on_main_thread(1, 2) = $result');
}
