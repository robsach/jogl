{
  description = "dev shell for development with jogl";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";
  };

  outputs = inputs: {
    devShells = builtins.mapAttrs (
      system: pkgs:
      let
        jogamp-2-6-0-url = "https://jogamp.org/deployment/archive/rc/v2.6.0/fat/jogamp-fat.jar";
        hash = "sha256-Eu/A1bDKf4UKdDgrms3qQVjJnXACP7R0yM8pJ9RUqI4=";
        jogamp-file = pkgs.fetchurl {
          url = jogamp-2-6-0-url;
          sha256 = hash;
        };
      in
      {
        default = pkgs.mkShell {
          buildInputs = [
            pkgs.libxxf86vm
          ];

          packages = [
            pkgs.jdk21
          ];

          shellHook = ''
            # JOGAMPPATH
            export JOGAMPPATH=${jogamp-file}  # used by aliases.sh
            export CLASSPATH=".:$JOGAMPPATH:$CLASSPATH"

            # Add libxxf86vm to linker path for dynamic loader
            export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [ pkgs.libxxf86vm ]}:$LD_LIBRARY_PATH"
          '';
        };
      }
    ) inputs.nixpkgs.legacyPackages;
  };
}
