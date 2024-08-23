# Copyright 2024 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0

{

  description = "multimedia audio codec opuscodec driver";
  inputs = {
    # NixOS official package source, here using the nixos-24.05 branch
  };

  outputs = _: {
      #imports package for the opus coded
      codec_opus = import packages;
  };
}
