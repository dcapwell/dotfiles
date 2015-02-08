alias cargo-test='fswatch -o src/ -o tests/ | xargs -n1 bash -c "clear ; date ; cargo test"'
alias cargo-build='fswatch -o src/ -o tests/ | xargs -n1 bash -c "clear ; date ; cargo build"'
