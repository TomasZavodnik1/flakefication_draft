# Copyright 2024 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0
{
 pkgs,
 gnumake,
 bash
}:

with pkgs;
let

in
stdenv.mkDerivation rec {
  pname = "linux-imx-kernel-headers";
  version = "v0.3.50";
  src = ./.;
  buildInputs = [ ];
  nativeBuildInputs =  [  ];

  dontUseCmakeConfigure=true;
  
  installPhase = '' #create output dir
                   mkdir -p $out/include

                   cp -r $src/include/* $out/include/

	'';
}

