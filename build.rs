use cc;
use std::env;
use std::path::Path;

fn main() {
    let target = env::var("TARGET").unwrap();
    let arch_dir = Path::new("src").join(target);
    cc::Build::new()
        .file(arch_dir.join("start.s"))
        .file(arch_dir.join("syscalls.c"))
        .compile("platform-code");
}