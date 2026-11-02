# REVISADO — general/cbindgen — Cbindgen-0.29.0
set -e
cargo build --release
install -Dm755 target/release/cbindgen /usr/bin/
