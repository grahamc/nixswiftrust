{
  description = "nixrustswift";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.590113.tar.gz";

    fenix = {
      url = "https://flakehub.com/f/nix-community/fenix/0.1.1584.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    naersk = {
      url = "github:DeterminateSystems/naersk/apple-sdks";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , fenix
    , naersk
    , ...
    } @ inputs:
    let
      supportedSystems = [ "x86_64-darwin" "aarch64-darwin" ];

      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: (forSystem system f));

      forSystem = system: f: f rec {
        inherit system;
        pkgs = import nixpkgs { inherit system; overlays = [ self.overlays.default ]; };
        lib = pkgs.lib;
      };

      fenixToolchain = system: with fenix.packages.${system};
        combine ([
          stable.rustc
          stable.cargo
          stable.rust-src
        ]);
    in
    {
      overlays.default = final: prev:
        let
          toolchain = fenixToolchain final.stdenv.system;
          naerskLib = final.callPackage naersk {
            cargo = toolchain;
            rustc = toolchain;
          };
        in
        rec {
          nixrustswift = (naerskLib.override ({ pkgs, ... }: { stdenv = pkgs.swiftPackages.stdenv; })).buildPackage {
            pname = "nixrustswift";
            version = (builtins.fromTOML (builtins.readFile ./Cargo.toml)).package.version;
            src = builtins.path {
              name = "nixrustswift-source";
              path = self;
              filter = (path: type: baseNameOf path != "nix" && baseNameOf path != ".github");
            };

            nativeBuildInputs = with final; [
              swift
              swiftPackages.swiftpm
              xcbuild
            ];

            SWIFT_RS_CLANG = "${final.clang}/bin/clang";

            copyBins = true;
            copyDocsToSeparateOutput = false;

            doCheck = true;
            doDoc = false;
            doDocFail = false;
            cargoTestOptions = f: f ++ [ "--all" ];
          };
        };


      devShells = forAllSystems ({ system, pkgs, ... }:
        let
          toolchain = fenixToolchain system;
        in
        {
          default = pkgs.mkShell {
            name = "nixrustswift-shell";

            RUST_SRC_PATH = "${toolchain}/lib/rustlib/src/rust/library";

            nativeBuildInputs = with pkgs; [
              swift
              swiftPackages.swiftpm
              xcbuild
            ];
            buildInputs = with pkgs; [
              toolchain
            ];

            SWIFT_RS_CLANG = "${pkgs.clang}/bin/clang";
          };
        });

      packages = forAllSystems ({ system, pkgs, ... }: {
        default = pkgs.nixrustswift;
      });
    };
}
