
[comment]: # (Generated file, make edits to README.md.in)

![wyrm logo](docs/static/images/wyrm_logo.png)

# WYRM

Wyrm is an experimental programming language for creative media production.
Wyrm is a statically-typed, garbage-collected language based on LLVM. Wyrm is
in the early development/prototype stage and is not yet ready for use.

## Compiling Quick Start

Wyrm depends on LLVM to compile. The easiest way to get LLVM is to download the
binaries from [llvm.org](https://llvm.org). Wyrm requires LLVM version
15.0.6, and will not compile against another version. Download
and extract the matching version of LLVM binaries. Provide the path to the CMake
build system with the `LLVM_DIR` variable, like:

```
mkdir build
cd build
cmake -G Ninja -DLLVM_DIR=<path_to_llvm_download> ..
cmake --build .
```

For detailed build instructions, consult the Developer Documentation either
[in this repository](docs/developer/compiling_wyrm.rst) or
[on the web](https://wyrm.sh/developer/compiling_wyrm.html)

## Documentation

Wyrm uses [sphinx](https://www.sphinx-doc.org/en/master/index.html) to generate
the static HTML website hosted at [wyrm.sh](https://wyrm.sh).
