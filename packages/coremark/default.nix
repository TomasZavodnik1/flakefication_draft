# Copyright 2024 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0
{
  lib,
  pkgs,
  stdenv,
  pkg-config,
}:

pkgs.stdenv.mkDerivation rec {
  pname = "coremark";
  version = "v1.02";

  src = pkgs.fetchFromGitHub {
      owner = "eembc";
      repo = "coremark";
      rev = "d5fad6bd094899101a4e5fd53af7298160ced6ab";
      sha256 = "sha256-KBzkjRV24chI7iLLCIFNXVTEgFv9/+DvzWH0aeq6QAU=";
  };

  buildInputs = [  ];
  
  nativeBuildInputs = [];

  buildPhase = ''                 
                make compile
                 '';

  installPhase = ''
                mkdir -p $out/bin
                cp coremark.exe $out/bin/coremark
                '';
}

