use std::process::Command;

// Learn more about Tauri commands at https://tauri.app/develop/calling-rust/
#[tauri::command]
fn greet(name: &str) -> String {
    format!("Hello, {}! You've been greeted from Rust!", name)
}

#[tauri::command]
fn init_bench(name: String) -> Result<String, String> {
    println!("Running init_bench with name: {}", name);

    let mut child = Command::new("bash")
        .arg("init-bench.sh") // Just the script name since we're in the directory
        .arg(&name)
        .current_dir("shell-scripts") // Change to shell-scripts directory
        .spawn()
        .expect("failed to execute process");

    let status = child.wait().expect("failed to wait for process");

    if status.success() {
        Ok(format!("Project {} initialized successfully!", name))
    } else {
        Err(format!("Failed to initialize project: {:?}", status))
    }
}

#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    tauri::Builder::default()
        .plugin(tauri_plugin_os::init())
        .plugin(tauri_plugin_fs::init())
        .plugin(tauri_plugin_shell::init())
        .plugin(tauri_plugin_opener::init())
        .invoke_handler(tauri::generate_handler![greet, init_bench])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
