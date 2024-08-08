# Copyright 2024 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0
{ pkgs ? import <nixpkgs> {} }:

with pkgs;
let
   asdsadsad = callPackage ../linux-imx-kernel-headers {};
in
stdenv.mkDerivation rec {
  pname = "imx-vpu-hantro";
  version = "v1.19.0";
  src = ./.;
  buildInputs = [ linuxHeaders ];
  nativeBuildInputs =  [ linuxHeaders ];

  dontUseCmakeConfigure=true;
  
  buildPhase = '' 
                  LINUX_KERNEL_ROOT=${asdsadsad} make  ''; 
  installPhase = '' #create output dir
                   DEST_DIR=$out make install
                   cp -r cpy/* $out/
        '';
}

















