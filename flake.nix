{
  description = " The missing CMake project initializer";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
  let 
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system}.default = pkgs.stdenv.mkDerivation {
      pname = "cmake-init";
      version = "0.37.3";

      src = pkgs.fetchFromGitHub {
        owner = "friendlyanon";
        repo = "cmake-init";
        rev = "v0.37.3";
        hash = "sha256-E7SQrtfxp7JLDec/GaBYncpZP0bIiNBBobSjKfpVRFA=";
      };

      buildInputs = [ pkgs.python3 ];
      nativeBuildInputs = [ pkgs.ensureNewerSourcesForZipFilesHook ];

      buildPhase = ''
        unset SOURCE_DATE_EPOCH
        python -m zipapp cmake-init
      '';

      installPhase = ''
        mkdir -p $out/{bin,lib}
        mv cmake-init.pyz $out/lib

        echo "#!/usr/bin/env bash" >> $out/bin/cmake-init
        echo "${pkgs.python3}/bin/python $out/lib/cmake-init.pyz $@" >> $out/bin/cmake-init
        chmod +x $out/bin/cmake-init
      '';
    };

  };
}
