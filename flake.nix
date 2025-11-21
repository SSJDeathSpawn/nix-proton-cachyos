{
  description = "CachyOS-Python";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs } : 
  let 
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in
  {
    packages.${system} = {
      proton-cachyos = pkgs.stdenv.mkDerivation rec {
        name = "proton-cachyos";
        version = "10.0-20251107";
        src = pkgs.fetchurl {
          url = "https://github.com/CachyOS/proton-cachyos/releases/download/cachyos-${version}-slr/proton-cachyos-${version}-slr-x86_64.tar.xz";
          hash = "sha256-FECVwymkKV1SiqGzB0yMypAThMEnXcUGO1B9wZxUm9A=";
        };
        
        nativeBuildInputs = [ pkgs.zstd pkgs.xz ];

        installPhase = ''
          mkdir -p $out/share/steam/compatibilitytools.d
          tar -I xz -xf $src
          mv proton-cachyos-${version}-slr-x86_64 $out/share/steam/compatibilitytools.d/
        '';

        meta = with pkgs.lib; {
          description = "CachyOS Proton build with additional patches and optimizations";
          homepage = "https://github.com/CachyOS/proton-cachyos";
          license = licenses.bsd3;
          platforms = [ "x86_64-linux" ];
        };
      };

      default = self.packages.${system}.proton-cachyos;
    };
  };
}
