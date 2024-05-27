# Local instance of compiler explorer with rust dependencies

Rust dependencies are configured inside `config.yml`, example can be found in `config.example.yml`:

```yml
crates:
  - name: either
    version: 1.12.0
  - name: derive_more
    version: 0.99.17
  - name: seq-macro
    version: 0.3.5
```

Dependencies are fetched from [`crates.io`](https://crates.io) at the exact version. 

To use dependency, just add `extern crate ...` on the top of the main file:

```rust
extern crate either;
extern crate derive_more;
extern crate seq_macro;
``` 

## Multiple source files

To use multiple source files as 1 rust crate with compiler explorer, do the following steps:

1. Archive the `src` folder of your crate;
2. At the compiler explorer main page: `Add` -> `Tree (IDE Mode)`;
3. In the newly opened window: `Project` -> `Browse`;
4. Select archive from step 1;
5. Make sure that all files are in the included section and, most importantly, rename `lib.rs` to `example.rs` (rename icon can be slightly confusing looking like a tag);
6. In the `Tree` window: `Add new` -> `Compiler`;
7. Everything should work fine.

Renaming `lib.rs` to `example.rs` is required as compiler explorer has no idea what file to choose as an entry point, so `example.{lang_ext}` is hardcoded. With `C++`/`C` `CMake` can be used to change that behavior, but unfortunately this is the only build system currently supported.
