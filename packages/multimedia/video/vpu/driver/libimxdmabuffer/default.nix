# Copyright 2024 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0
{ pkgs ? import <nixpkgs> {} }:

with pkgs;
let
   asdsadsad = callPackage ../linux-imx-kernel-headers {};
in
stdenv.mkDerivation rec {
  pname = "libimxdmabuffer";
  version = "v1.1.3";
  src = ./.;
  buildInputs = [ pkg-config binutils waf python3 ];
  nativeBuildInputs =  [ binutils waf python3 ];

  dontUseCmakeConfigure=true;
  
  buildPhase = '' 
                  mkdir $out
                  python3 waf configure --prefix=$out  --imx-linux-headers-path=${asdsadsad}
                  python3 waf
                  python3 waf install
                  ''; 
  installPhase = '' #create output dir
                   #cp -r /build/libimxdmabuffer/build/* $out/
	'';
}

