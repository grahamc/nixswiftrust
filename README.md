# nixrustswift

This is a minimal reproducer of failing to get swift-rs to be happy when building for x86_64-darwin using new SDKs.

## Reproducer

See it work on aarch64-darwin:

```sh
nix build .#packages.aarch64-darwin.default -L
```

See it fail on x86_64-darwin:

```sh
nix build .#packages.x86_64-darwin.default -L
```

The command I was using while making the reproducer, to make sure it failed the same way:

```
if cargo build && nix build .#packages.aarch64-darwin.default && ! nix build .#packages.x86_64-darwin.default -L ; then echo "still broke the same way"; else echo "broke differently"; fi
```

## Notes

- It uses `grahamc/naersk` instead of `nix-community/naersk`, but only because I thought maybe `nix-community/naersk`'s inclusion of frameworks might be causing the problem: https://github.com/grahamc/naersk/commit/adbf3b75057151f09fc17bf3a105e2e1b9b20f9d ... this is the only difference.
- All the flake inputs were updated right before testing.

## Log

```
Running phase: unpackPhase
@nix { "action": "setPhase", "phase": "unpackPhase" }
unpacking source archive /nix/store/f4xc18aw7sw2vq8ww1vffi0il02vs7kn-nixrustswift-source
source root is nixrustswift-source
Running phase: patchPhase
@nix { "action": "setPhase", "phase": "patchPhase" }
Running phase: configurePhase
@nix { "action": "setPhase", "phase": "configurePhase" }
[naersk] cargo_version (read): 1.80.0 (376290515 2024-07-16)
[naersk] cargo_message_format (set): json-diagnostic-rendered-ansi
[naersk] cargo_release: --release
[naersk] cargo_options:
[naersk] cargo_build_options: $cargo_release -j "$NIX_BUILD_CORES" --message-format=$cargo_message_format
[naersk] cargo_test_options: $cargo_release -j "$NIX_BUILD_CORES" --all
[naersk] RUST_TEST_THREADS: 14
[naersk] cargo_bins_jq_filter: select(.reason == "compiler-artifact" and .executable != null and .profile.test == false)
[naersk] cargo_build_output_json (created): /private/tmp/nix-build-nixrustswift-0.1.0.drv-0/tmp.YJBil5VhA5
[naersk] RUSTFLAGS:
[naersk] CARGO_BUILD_RUSTFLAGS:
[naersk] CARGO_BUILD_RUSTFLAGS (updated):  --remap-path-prefix /nix/store/npk81rkz2nw5kmish2m6sa53c9x950sd-crates-io-dependencies=/sources --remap-path-prefix /nix/store/9d7r5iwdya6xrxn91b5pd2f47wggh89q-git-dependencies=/sources
[naersk] pre-installing dep /nix/store/dykglh54s98p5q5xkkkvkxkgvfzb218h-nixrustswift-deps-0.1.0
Running phase: buildPhase
@nix { "action": "setPhase", "phase": "buildPhase" }
cargo build $cargo_release -j "$NIX_BUILD_CORES" --message-format=$cargo_message_format
[1m[32m   Compiling[0m nixrustswift v0.1.0 (/private/tmp/nix-build-nixrustswift-0.1.0.drv-0/nixrustswift-source)
[1m[31merror[0m[1m:[0m failed to run custom build command for `nixrustswift v0.1.0 (/private/tmp/nix-build-nixrustswift-0.1.0.drv-0/nixrustswift-source)`

Caused by:
  process didn't exit successfully: `/private/tmp/nix-build-nixrustswift-0.1.0.drv-0/nixrustswift-source/target/release/build/nixrustswift-4bf2577770d6e980/build-script-build` (exit status: 101)
  --- stdout
  cargo:rustc-link-search=native=/nix/store/14ry1wqq1ac592jiqv63g39lyxsi6bzb-swift-5.8-lib/lib/swift/macosx
  cargo:rustc-link-search=native=/usr/lib/swift
  cargo:rustc-link-lib=clang_rt.osx
  cargo:rustc-link-search=/nix/store/raqax5qp65an4jcwj1bzd5lq589ywpg0-clang-wrapper-16.0.6/resource-root/lib/darwin

  --- stderr
  warning: Could not read SDKSettings.json for SDK at: /nix/store/6fb3yzhx0dlhzjk8s1mwkmn505yqbmmb-apple-sdk-10.12.2/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk
  warning: Could not read SDKSettings.json for SDK at: /nix/store/6fb3yzhx0dlhzjk8s1mwkmn505yqbmmb-apple-sdk-10.12.2/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk
  warning: Could not read SDKSettings.json for SDK at: /nix/store/6fb3yzhx0dlhzjk8s1mwkmn505yqbmmb-apple-sdk-10.12.2/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk
  warning: /var/empty/Library/org.swift.swiftpm/configuration is not accessible or not writable, disabling user-level cache features.
  warning: /var/empty/Library/org.swift.swiftpm/security is not accessible or not writable, disabling user-level cache features.
  warning: /var/empty/Library/Caches/org.swift.swiftpm is not accessible or not writable, disabling user-level cache features.
  warning: 'swift-lib': failed loading cached manifest for 'swift-lib': Error Domain=NSCocoaErrorDomain Code=4 "The file “manifests” doesn’t exist." UserInfo={NSFilePath=/var/empty/Library/Caches/org.swift.swiftpm/manifests, NSURL=file:///var/empty/Library/Caches/org.swift.swiftpm/manifests, NSUnderlyingError=0x600001a8ebe0 {Error Domain=NSPOSIXErrorDomain Code=2 "No such file or directory"}}
  warning: 'swift-lib': failed closing cache: Error Domain=NSCocoaErrorDomain Code=4 "The file “manifests” doesn’t exist." UserInfo={NSFilePath=/var/empty/Library/Caches/org.swift.swiftpm/manifests, NSURL=file:///var/empty/Library/Caches/org.swift.swiftpm/manifests, NSUnderlyingError=0x600001a94060 {Error Domain=NSPOSIXErrorDomain Code=2 "No such file or directory"}}
  error: 'swift-lib': Invalid manifest (compiled with: ["/nix/store/15zsh6qniwxm15r7s7xkq4116b1dll3h-swift-wrapper-5.8/bin/swiftc", "-vfsoverlay", "/private/tmp/nix-build-nixrustswift-0.1.0.drv-0/TemporaryDirectory.QL9qoV/vfs.yaml", "-L", "/nix/store/v4bjaaxv05djh5l0qw521279v3xcr45g-swiftpm-5.8/lib/swift/pm/ManifestAPI", "-lPackageDescription", "-Xlinker", "-rpath", "-Xlinker", "/nix/store/v4bjaaxv05djh5l0qw521279v3xcr45g-swiftpm-5.8/lib/swift/pm/ManifestAPI", "-target", "x86_64-apple-macosx10.15.4", "-sdk", "/nix/store/6fb3yzhx0dlhzjk8s1mwkmn505yqbmmb-apple-sdk-10.12.2/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk", "-F", "/nix/store/6fb3yzhx0dlhzjk8s1mwkmn505yqbmmb-apple-sdk-10.12.2/Platforms/MacOSX.platform/Developer/Library/Frameworks", "-I", "/nix/store/6fb3yzhx0dlhzjk8s1mwkmn505yqbmmb-apple-sdk-10.12.2/Platforms/MacOSX.platform/Developer/usr/lib", "-L", "/nix/store/6fb3yzhx0dlhzjk8s1mwkmn505yqbmmb-apple-sdk-10.12.2/Platforms/MacOSX.platform/Developer/usr/lib", "-swift-version", "5", "-I", "/nix/store/v4bjaaxv05djh5l0qw521279v3xcr45g-swiftpm-5.8/lib/swift/pm/ManifestAPI", "-sdk", "/nix/store/6fb3yzhx0dlhzjk8s1mwkmn505yqbmmb-apple-sdk-10.12.2/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk", "-package-description-version", "5.7.0", "/private/tmp/nix-build-nixrustswift-0.1.0.drv-0/nixrustswift-source/swift-lib/Package.swift", "-o", "/private/tmp/nix-build-nixrustswift-0.1.0.drv-0/TemporaryDirectory.nf8TJ4/swift-lib-manifest"])
  warning: Could not read SDKSettings.json for SDK at: /nix/store/6fb3yzhx0dlhzjk8s1mwkmn505yqbmmb-apple-sdk-10.12.2/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk
  error: compile command failed due to signal 8 (use -v to see invocation)
  <unknown>:0: warning: overriding '-mmacos-version-min=10.12' option with '-target x86_64-apple-macosx10.15.4'
  /nix/store/6fb3yzhx0dlhzjk8s1mwkmn505yqbmmb-apple-sdk-10.12.2/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/Foundation.framework/Headers/NSURLError.h:14:9: note: while building module 'CoreServices' imported from /nix/store/6fb3yzhx0dlhzjk8s1mwkmn505yqbmmb-apple-sdk-10.12.2/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/Foundation.framework/Headers/NSURLError.h:14:
  #import <CoreServices/CoreServices.h>
          ^
  /nix/store/6fb3yzhx0dlhzjk8s1mwkmn505yqbmmb-apple-sdk-10.12.2/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/CoreServices.framework/Frameworks/CarbonCore.framework/Headers/MachineExceptions.h:22:10: note: while building module '_Builtin_intrinsics' imported from /nix/store/6fb3yzhx0dlhzjk8s1mwkmn505yqbmmb-apple-sdk-10.12.2/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/CoreServices.framework/Frameworks/CarbonCore.framework/Headers/MachineExceptions.h:22:
  #include <emmintrin.h>
           ^
  <module-includes>:1:9: note: in file included from <module-includes>:1:
  #import "immintrin.h"
          ^
  /nix/store/raqax5qp65an4jcwj1bzd5lq589ywpg0-clang-wrapper-16.0.6/resource-root/include/immintrin.h:31:10: note: in file included from /nix/store/raqax5qp65an4jcwj1bzd5lq589ywpg0-clang-wrapper-16.0.6/resource-root/include/immintrin.h:31:
  #include <emmintrin.h>
           ^
  /nix/store/raqax5qp65an4jcwj1bzd5lq589ywpg0-clang-wrapper-16.0.6/resource-root/include/emmintrin.h:43:9: error: _Float16 is not supported on this target
  typedef _Float16 __v8hf __attribute__((__vector_size__(16), __aligned__(16)));
          ^
  /nix/store/6fb3yzhx0dlhzjk8s1mwkmn505yqbmmb-apple-sdk-10.12.2/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/Foundation.framework/Headers/NSURLError.h:14:9: note: while building module 'CoreServices' imported from /nix/store/6fb3yzhx0dlhzjk8s1mwkmn505yqbmmb-apple-sdk-10.12.2/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/Foundation.framework/Headers/NSURLError.h:14:
  #import <CoreServices/CoreServices.h>
          ^
  /nix/store/6fb3yzhx0dlhzjk8s1mwkmn505yqbmmb-apple-sdk-10.12.2/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/CoreServices.framework/Frameworks/CarbonCore.framework/Headers/MachineExceptions.h:22:10: note: while building module '_Builtin_intrinsics' imported from /nix/store/6fb3yzhx0dlhzjk8s1mwkmn505yqbmmb-apple-sdk-10.12.2/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/CoreServices.framework/Frameworks/CarbonCore.framework/Headers/MachineExceptions.h:22:
  #include <emmintrin.h>
           ^
  <module-includes>:1:9: note: in file included from <module-includes>:1:
  #import "immintrin.h"
          ^
  /nix/store/raqax5qp65an4jcwj1bzd5lq589ywpg0-clang-wrapper-16.0.6/resource-root/include/immintrin.h:31:10: note: in file included from /nix/store/raqax5qp65an4jcwj1bzd5lq589ywpg0-clang-wrapper-16.0.6/resource-root/include/immintrin.h:31:
  #include <emmintrin.h>
           ^
  /nix/store/raqax5qp65an4jcwj1bzd5lq589ywpg0-clang-wrapper-16.0.6/resource-root/include/emmintrin.h:44:9: error: _Float16 is not supported on this target
  typedef _Float16 __m128h __attribute__((__vector_size__(16), __aligned__(16)));
          ^
  /nix/store/6fb3yzhx0dlhzjk8s1mwkmn505yqbmmb-apple-sdk-10.12.2/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/Foundation.framework/Headers/NSURLError.h:14:9: note: while building module 'CoreServices' imported from /nix/store/6fb3yzhx0dlhzjk8s1mwkmn505yqbmmb-apple-sdk-10.12.2/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/Foundation.framework/Headers/NSURLError.h:14:
  #import <CoreServices/CoreServices.h>
          ^
  /nix/store/6fb3yzhx0dlhzjk8s1mwkmn505yqbmmb-apple-sdk-10.12.2/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/CoreServices.framework/Frameworks/CarbonCore.framework/Headers/MachineExceptions.h:22:10: note: while building module '_Builtin_intrinsics' imported from /nix/store/6fb3yzhx0dlhzjk8s1mwkmn505yqbmmb-apple-sdk-10.12.2/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/CoreServices.framework/Frameworks/CarbonCore.framework/Headers/MachineExceptions.h:22:
  #include <emmintrin.h>
           ^
  <module-includes>:1:9: note: in file included from <module-includes>:1:
  #import "immintrin.h"
          ^
  /nix/store/raqax5qp65an4jcwj1bzd5lq589ywpg0-clang-wrapper-16.0.6/resource-root/include/immintrin.h:31:10: note: in file included from /nix/store/raqax5qp65an4jcwj1bzd5lq589ywpg0-clang-wrapper-16.0.6/resource-root/include/immintrin.h:31:
  #include <emmintrin.h>
           ^
  /nix/store/raqax5qp65an4jcwj1bzd5lq589ywpg0-clang-wrapper-16.0.6/resource-root/include/emmintrin.h:45:9: error: _Float16 is not supported on this target
  typedef _Float16 __m128h_u __attribute__((__vector_size__(16), __aligned__(1)));
          ^
  /nix/store/6fb3yzhx0dlhzjk8s1mwkmn505yqbmmb-apple-sdk-10.12.2/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/Foundation.framework/Headers/NSURLError.h:14:9: note: while building module 'CoreServices' imported from /nix/store/6fb3yzhx0dlhzjk8s1mwkmn505yqbmmb-apple-sdk-10.12.2/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/Foundation.framework/Headers/NSURLError.h:14:
  #import <CoreServices/CoreServices.h>
          ^
  /nix/store/6fb3yzhx0dlhzjk8s1mwkmn505yqbmmb-apple-sdk-10.12.2/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/CoreServices.framework/Frameworks/CarbonCore.framework/Headers/MachineExceptions.h:22:10: note: while building module '_Builtin_intrinsics' imported from /nix/store/6fb3yzhx0dlhzjk8s1mwkmn505yqbmmb-apple-sdk-10.12.2/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks/CoreServices.framework/Frameworks/CarbonCore.framework/Headers/MachineExceptions.h:22:
  #include <emmintrin.h>
           ^
  <module-includes>:1:9: note: in file included from <module-includes>:1:
  #import "immintrin.h"
          ^
  /nix/store/raqax5qp65an4jcwj1bzd5lq589ywpg0-clang-wrapper-16.0.6/resource-root/include/immintrin.h:31:10: note: in file included from /nix/store/raqax5qp65an4jcwj1bzd5lq589ywpg0-clang-wrapper-16.0.6/resource-root/include/immintrin.h:31:
  #include <emmintrin.h>
           ^
  /nix/store/raqax5qp65an4jcwj1bzd5lq589ywpg0-clang-wrapper-16.0.6/resource-root/include/emmintrin.h:47:9: error: __bf16 is not supported on this target
  typedef __bf16 __v8bf __attribute__((__vector_size__(16), __aligned__(16)));
          ^
  Please submit a bug report (https://swift.org/contributing/#reporting-bugs) and include the crash backtrace.
  Stack dump:
  0.	/nix/store/raqax5qp65an4jcwj1bzd5lq589ywpg0-clang-wrapper-16.0.6/resource-root/include/emmintrin.h:47:76: current parser token ';'
  Stack dump without symbol names (ensure you have llvm-symbolizer in your PATH or set the environment var `LLVM_SYMBOLIZER_PATH` to point to it):
  0  .swift-frontend-wrapped  0x00000001093542bb llvm::sys::PrintStackTrace(llvm::raw_ostream&, int) + 59
  1  .swift-frontend-wrapped  0x00000001093531b7 llvm::sys::RunSignalHandlers() + 279
  2  .swift-frontend-wrapped  0x00000001093549cb SignalHandler(int) + 363
  3  libsystem_platform.dylib 0x00007ff807883e9d _sigtramp + 29
  4  libsystem_platform.dylib 0x0000000315fd8fa0 _sigtramp + 18446603383708406048
  5  .swift-frontend-wrapped  0x000000010824977e processTypeAttrs((anonymous namespace)::TypeProcessingState&, clang::QualType&, TypeAttrLocation, clang::ParsedAttributesView const&) + 5550
  6  .swift-frontend-wrapped  0x0000000108241c17 GetFullTypeForDeclarator((anonymous namespace)::TypeProcessingState&, clang::QualType, clang::TypeSourceInfo*) + 22983
  7  .swift-frontend-wrapped  0x0000000108238f6c clang::Sema::GetTypeForDeclarator(clang::Declarator&, clang::Scope*) + 716
  8  .swift-frontend-wrapped  0x0000000107bd7a46 clang::Sema::HandleDeclarator(clang::Scope*, clang::Declarator&, llvm::MutableArrayRef<clang::TemplateParameterList*>) + 1190
  9  .swift-frontend-wrapped  0x0000000107bd753a clang::Sema::ActOnDeclarator(clang::Scope*, clang::Declarator&) + 26
  10 .swift-frontend-wrapped  0x00000001077758b4 clang::Parser::ParseDeclarationAfterDeclaratorAndAttributes(clang::Declarator&, clang::Parser::ParsedTemplateInfo const&, clang::Parser::ForRangeInit*) + 148
  11 .swift-frontend-wrapped  0x00000001077735b2 clang::Parser::ParseDeclGroup(clang::ParsingDeclSpec&, clang::DeclaratorContext, clang::SourceLocation*, clang::Parser::ForRangeInit*) + 882
  12 .swift-frontend-wrapped  0x000000010776cad6 clang::Parser::ParseSimpleDeclaration(clang::DeclaratorContext, clang::SourceLocation&, clang::ParsedAttributes&, bool, clang::Parser::ForRangeInit*, clang::SourceLocation*) + 758
  13 .swift-frontend-wrapped  0x000000010776c402 clang::Parser::ParseDeclaration(clang::DeclaratorContext, clang::SourceLocation&, clang::ParsedAttributes&, clang::SourceLocation*) + 370
  14 .swift-frontend-wrapped  0x000000010783226b clang::Parser::ParseExternalDeclaration(clang::ParsedAttributes&, clang::ParsingDeclSpec*) + 203
  15 .swift-frontend-wrapped  0x0000000107830855 clang::Parser::ParseTopLevelDecl(clang::OpaquePtr<clang::DeclGroupRef>&, clang::Sema::ModuleImportState&) + 853
  16 .swift-frontend-wrapped  0x0000000107756bde clang::ParseAST(clang::Sema&, bool, bool) + 798
  17 .swift-frontend-wrapped  0x000000010755e9a8 clang::FrontendAction::Execute() + 104
  18 .swift-frontend-wrapped  0x00000001074d37ac clang::CompilerInstance::ExecuteAction(clang::FrontendAction&) + 860
  19 .swift-frontend-wrapped  0x00000001074de7d0 void llvm::function_ref<void ()>::callback_fn<compileModuleImpl(clang::CompilerInstance&, clang::SourceLocation, llvm::StringRef, clang::FrontendInputFile, llvm::StringRef, llvm::StringRef, llvm::function_ref<void (clang::CompilerInstance&)>, llvm::function_ref<void (clang::CompilerInstance&)>)::$_7>(long) + 144
  20 .swift-frontend-wrapped  0x0000000109290ab3 llvm::CrashRecoveryContext::RunSafely(llvm::function_ref<void ()>) + 227
  21 .swift-frontend-wrapped  0x0000000109290bf0 RunSafelyOnThread_Dispatch(void*) + 48
  22 .swift-frontend-wrapped  0x0000000109290d3f void* llvm::thread::ThreadProxy<std::__1::tuple<void (*)(void*), (anonymous namespace)::RunSafelyOnThreadInfo*> >(void*) + 15
  23 libsystem_pthread.dylib  0x00007ff80784f253 _pthread_start + 99
  24 libsystem_pthread.dylib  0x00007ff80784abef thread_start + 15
  thread 'main' panicked at /sources/swift-rs-1.0.7-4057c98e2e852d51fdcfca832aac7b571f6b351ad159f9eda5db1655f8d0c4d7/src-rs/build.rs:281:17:
  Failed to compile swift package swift-lib
  note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
[naersk] cargo returned with exit code 101, exiting
```
