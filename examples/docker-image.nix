{ pkgs ? import <nixpkgs> { }
, pkgsLinux ? import <nixpkgs> { system = "x86_64-linux"; }
}:

# This can be run as
# $(nix-build docker-image.nix) | docker load && docker run -v /path/to/some/alien-bin:/path -it example:latest

pkgs.dockerTools.streamLayeredImage {
  name = "example";
  tag = "latest";
  
  contents = [
    pkgs.bash_5
    pkgs.nix-ld
  ];
  
  extraCommands = ''
    mkdir -p lib64
    ln -s ${pkgs.nix-ld}/libexec/nix-ld lib64/ld-linux-x86_64.so.2
  '';
  
  config = {
    Cmd = [ "/bin/bash" ];
    Env = [
      # Make this what you expect alien binaries expect to run
      ("NIX_LD_LIBRARY_PATH=" + pkgs.lib.makeLibraryPath [
        pkgs.stdenv.cc.cc
        pkgs.zlib
      ])
      ("NIX_LD=" + pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker")
    ];
  };
}
