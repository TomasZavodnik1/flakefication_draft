# Copyright 2024 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0

{
  lib,
  pkgs,
  stdenv,
  pkg-config,
  pkgconf,
  openssl,
  libnl,
}:

stdenv.mkDerivation rec {
  pname = "morsemicro_utils";
  version = "v1.0";

  src = ./.;

  buildInputs = [ pkgs.pkg-config pkgconf openssl libnl libnl.dev ];
  
  nativeBuildInputs = with pkgs; [
        pkg-config
  ];

  buildPhase = '' tar -xzvf source.tar
                 cd wpa_supplicant/wpa_supplicant/
                 make all
                 cd ../../morsecli
                 make all
                 cd ../morsectrl
                 make all
                 cd ../hostapd/hostapd
                 make all
                 cd ../../
                 #touch $out
                 '';
  installPhase = ''
    mkdir -p $out/bin
    cp morsecli/morse_cli $out/bin/
    cp morsectrl/morsectrl $out/bin/
    cp hostapd/hostapd/hostapd_s1g $out/bin/
    cp hostapd/hostapd/hostapd_cli_s1g $out/bin/
    cp hostapd/hostapd/hostapd_s1g.conf $out/bin/
    cp wpa_supplicant/wpa_supplicant/wpa_cli_s1g $out/bin/
    cp wpa_supplicant/wpa_supplicant/wpa_passphrase_s1g $out/bin/
    cp wpa_supplicant/wpa_supplicant/wpa_supplicant_s1g $out/bin/
  '';
}

