
with import <nixpkgs> {};

with pkgs;
stdenv.mkDerivation rec {
  pname = "morsectrl";
  version = "v1.5";

  src = ./.;

  # Disable the execution of checks during the build
  #doCheck = false;

  # Set buildInputs to an empty list
  buildInputs = [ pkg-config pkgconf openssl libnl libnl.dev ];
  #sourceRoot = "./.";

  # Add the dontBuild attribute to prevent building the package
  buildPhase = ''cd wpa_supplicant/
                 make all
                 '';
  installPhase = ''
    #mkdir -p $out/bin
    #cp morse_cli $out/bin/morse_cli
  '';
}

