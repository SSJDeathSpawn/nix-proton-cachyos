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
        src = pkgs.lib.fetchurl {
          url = "https://github.com/CachyOS/proton-cachyos/releases/download/cachyos-${version}-slr/proton-cachyos-${version}-slr-x86_64.tar.xz";
          hash = "sha256-144095c329a4295d528aa1b3074c8cca901384c1275dc5063b507dc19c549bd0";
        };
        
        nativeBuildInputs = [ pkgs.zstd ];

        installPhase = ''
          tar -I zstd -xf $src
          mkdir -p $out/share/steam/compatibilitytools.d
          mv usr/share/steam/compatibilitytools.d/proton-cachyos $out/share/steam/compatibilitytools.d/
        '';
        meta = with pkgs.lib; {
          description = "CachyOS Proton build with additional patches and optimizations";
          homepage = "https://github.com/CachyOS/proton-cachyos";
          license = licenses.bsd3;
          platforms = [ "x86_64-linux" ];
          maintainers = with maintainers; [ kimjongbing ];
        };
      };

      default = self.packages.${system}.proton-cachyos;
    };
  };
}
