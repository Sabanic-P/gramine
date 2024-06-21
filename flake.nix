{
  description = "SVSM";

  nixConfig.extra-substituters = [ "https://cache.garnix.io" ];

  nixConfig.extra-trusted-public-keys =
    [ "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ];

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:Sabanic-P/rust-overlay";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    bpftrace.url = "github:mmisono/bpftrace/kvm_module_btf";
    qemu-coconut-src = {
      url =
        "git+https://github.com/coconut-svsm/qemu.git?ref=svsm-v8.0.0&submodules=1";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, nixos-generators, rust-overlay
    , bpftrace, ... }@args:
    (flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        flakepkgs = self.packages.${system};
        selfpkgs = self.packages.${system};
        overlays = [ (import rust-overlay) ];
        pkgsrust = import nixpkgs { inherit system overlays; };
      in {
        packages = {
        };

        devShells = let
          common_deps = with pkgs; [
            nixos-generators.packages.${system}.nixos-generate
            ccls # c lang serv
            meson
            ninja
            gdb
            bridge-utils
            cloud-utils
          ];
        in {
          default = pkgs.stdenv.mkDerivation {
            name = "devshell";
            buildInputs = with pkgs;
              [
                meson 
                bison
                gawk
                ninja
                pkg-config
                
                glibc
                glibc.static
                python312Packages.click
                python312Packages.jinja2
                python312Packages.pip
                python312Packages.pyelftools
                python312Packages.voluptuous
                python312Packages.meson
                python312Packages.tomli
                python312Packages.tomli-w
                wget
                python312
              ];
            hardeningDisable = [ "all" ];
            shellHook = ''
            '';
          };
        };
      }));
}
