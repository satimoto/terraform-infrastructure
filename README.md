# terraform-infrastructure
Satimoto Infrastructure using terraform

## lambda-rust module usage

* **Note:** If you are running on Mac OS you'll need to install the linker for the target platform. You do this using the `musl-cross` tap from [Homebrew](https://brew.sh/) which provides a complete cross-compilation toolchain for Mac OS. Once `musl-cross` is installed we will also need to inform cargo of the newly installed linker when building for the `x86_64-unknown-linux-musl` platform.
```bash
$ brew install filosottile/musl-cross/musl-cross
```
