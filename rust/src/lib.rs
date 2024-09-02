use dispatch::Queue;

// Ensure this only compiles on MacOS for now.
#[cfg(not(target_os = "macos"))]
compile_error!("This crate only supports MacOS.");

#[no_mangle]
pub extern "C" fn ffi_sum_on_current_thread(a: i32, b: i32) -> i32 {
    a + b
}

#[no_mangle]
pub extern "C" fn ffi_sum_on_main_thread(a: i32, b: i32) -> i32 {
    Queue::main().exec_sync(|| a + b)
}
