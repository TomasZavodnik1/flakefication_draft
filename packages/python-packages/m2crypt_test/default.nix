{ pkgs, bash, systemd, ... }:

with pkgs;

pkgs.stdenv.mkDerivation {
  name = "m2cryptotest";

  src = ./.;

  propagatedBuildInputs = [
    (pkgs.python311.withPackages (pythonPackages: with pythonPackages; [
      (pkgs.callPackage ../m2crypt {})
    ]))
  ];
  dontUnpack = true;
  installPhase = "install -Dm755 ${./test.py} $out/bin/m2cryptotest";
}
