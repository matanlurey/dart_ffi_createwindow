# `dart_ffi_createwindow`

This package and repository showcases the challenges in using Dart (outside
of Flutter, or a custom embedder) to use windowing APIs that have main thread
restrictions (and most either do, or it's not particularly safe to use a thread
other than the "main" thread).

> [!IMPORTANT]
> This example only runs on MacOS, and was only tested on an ARM64 Mac.

When running, expect the following output:

```sh
$ dart --enable-experiment=native-assets run example/main_thread.dart
ffi_sum_on_current_thread(1, 2) = 3
Trying to compute 1 + 2 on the main thread
The program will hang...
```

I'm not an embedding expert, but my understanding is the main thread is being
used by the Dart process, and it's not possible (or I don't know how) to allow
it to be free to execute other work. This makes it impossible to use the main
thread when required for APIs, such as windowing.

See <https://github.com/dart-lang/sdk/issues/38315> for details.

## Running

There are two ways to run the example code:

1. Use `--enable-experiment=native-assets`

  ```sh
  dart --enable-experiment=native-assets run example/main_thread.dart
  ```

1. Manually build the Rust FFI dylib (the program falls back to `DynamicLibrary.open` automatically)

  ```sh
  cd rust
  cargo build
  cd ../
  dart run example/main_thread.dart
  ```
