
{ pkgs ? import <nixpkgs> {} }:

pkgs.python311.pkgs.buildPythonPackage rec {
  pname = "m2crypto";
  version = "0.41.0";
  format = "setuptools";

  src = pkgs.fetchPypi {
    pname = "M2Crypto";
    inherit version;
    hash = "sha256-OhNYx+6EkEbZF4Knd/F4a/AnocHVG1+vjxlDW/w/FJU=";
  };

  nativeBuildInputs = [
    ( pkgs.callPackage ../swig {} )
    #pkgs.swig2
    pkgs.openssl
  ];

  propagatedBuildInputs = [
    pkgs.openssl
  ];

  env = {
    NIX_CFLAGS_COMPILE = pkgs.lib.optionalString pkgs.stdenv.isDarwin (toString [
      "-Wno-error=implicit-function-declaration"
      "-Wno-error=incompatible-pointer-types"
    ]);
  } // pkgs.lib.optionalAttrs (pkgs.stdenv.hostPlatform != pkgs.stdenv.buildPlatform) {
    CPP = "${pkgs.stdenv.cc.targetPrefix}cpp";
  };

  pythonImportsCheck = [
    "M2Crypto"
  ];

  meta = with pkgs.lib; {
    description = "A Python crypto and SSL toolkit";
    homepage = "https://gitlab.com/m2crypto/m2crypto";
    changelog = "https://gitlab.com/m2crypto/m2crypto/-/blob/${version}/CHANGES";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
