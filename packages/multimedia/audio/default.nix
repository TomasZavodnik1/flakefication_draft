# Copyright 2024 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0
{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.comms.gstreamer_audio;
  
  opus_decoder = pkgs.callPackage ../../../packages/multimedia/audio/codecs/opustools {};

in
  with lib; {
      environment.systemPackages = [
        #main gstreamer lib
        pkgs.gst_all_1.gstreamer
        # Common plugins like "filesrc" to combine within e.g. gst-launch
        pkgs.gst_all_1.gst-plugins-base
        # Specialized plugins separated by quality
        pkgs.gst_all_1.gst-plugins-good
        pkgs.gst_all_1.gst-plugins-bad
        pkgs.gst_all_1.gst-plugins-ugly
        # Plugins to reuse ffmpeg to play almost every video format
        pkgs.gst_all_1.gst-libav
        # Support the Video Audio (Hardware) Acceleration API
        pkgs.gst_all_1.gst-vaapi
        # Basic alsa utils needed for sound testing and gstreamer correct function
        pkgs.alsa-utils
      ];
  }




