{ pkgs }: {
  deps = [
    pkgs.nodejs_20
    pkgs.npm-9_x
    pkgs.yarn
    pkgs.gcc
    pkgs.pkg-config
    pkgs.libffi
    pkgs.openssl
    pkgs.zlib
    pkgs.libxml2
    pkgs.libxslt
    pkgs.curl
    pkgs.wget
    pkgs.git
    pkgs.bash
    pkgs.coreutils
    pkgs.findutils
    pkgs.gnugrep
    pkgs.gnused
    pkgs.gawk
    pkgs.which
    pkgs.procps
    pkgs.htop
    pkgs.tree
    pkgs.jq
    pkgs.sqlite
    pkgs.chromium
  ];
  env = {
    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
      pkgs.stdenv.cc.cc.lib
      pkgs.zlib
      pkgs.glibc
      pkgs.libffi
      pkgs.openssl
    ];
  };
}
