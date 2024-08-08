# Copyright 2024 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0
{ pkgs ? import <nixpkgs> {} }:

with pkgs;
let
   linux-headers-pkgs = callPackage ../linux-imx-kernel-headers {};
   imx-vpu-hantro-pkgs = callPackage ../imx-vpu-hantro {};
   libimxdmabuffer-pkgs = callPackage ../libimxdmabuffer {};


in
stdenv.mkDerivation rec {
  pname = "libimxvpuapi";
  version = "v2.3.0";
  src = ./.;
  buildInputs = [ python3 pkg-config imx-vpu-hantro-pkgs libimxdmabuffer-pkgs ];
  nativeBuildInputs =  [  python3  imx-vpu-hantro-pkgs libimxdmabuffer-pkgs ];

  dontUseCmakeConfigure=true;
  
  buildPhase = '' cp -r ${linux-headers-pkgs}/include/* .
                  cp -r ${imx-vpu-hantro-pkgs}/usr/include/* . 
                  cp -r ${imx-vpu-hantro-pkgs}/* .
                  cp -r ${imx-vpu-hantro-pkgs}/usr/* . 
 

                  cp -r ${libimxdmabuffer-pkgs}/include/* .
                  cp -r imxdmabuffer/* .
                  cp -r hantro_dec/* .
                  chmod -R 777 linux/
                  rm linux/types.h
             
                  cp -r ${libimxdmabuffer-pkgs}/lib/* .
                  cp -r ${imx-vpu-hantro-pkgs}/usr/lib/* .
                  ls -la 
                  
                  substituteInPlace  pkgconfig/libhantro_vc8000e.pc --replace {vc-pkg} ${imx-vpu-hantro-pkgs}
                  rm -r pkgconfig
                  python3 waf configure --sysroot-path=. --imx-platform=imx8mp --prefix=$out --disable-examples
                  python3 waf
                  python3 waf install --prefix=$out''; 
  installPhase = ''   '';
}

