{ pkgs }: {
  deps = [
    # Node.js runtime and package management
    pkgs.nodejs_20
    pkgs.nodePackages.npm
    pkgs.nodePackages.yarn
    
    # TypeScript and language support
    pkgs.nodePackages.typescript
    pkgs.nodePackages.typescript-language-server
    pkgs.nodePackages.vscode-json-languageserver
    
    # Build tools and system utilities
    pkgs.gcc
    pkgs.pkg-config
    pkgs.libffi
    pkgs.openssl
    pkgs.zlib
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
    
    # Audio and WebRTC dependencies for voice AI
    pkgs.libuv
    pkgs.libxml2
    pkgs.libxslt
    pkgs.alsa-lib
    pkgs.pulseaudio
    pkgs.ffmpeg
  ];
  
  env = {
    # Library paths for proper linking
    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
      pkgs.stdenv.cc.cc.lib
      pkgs.zlib
      pkgs.glibc
      pkgs.libffi
      pkgs.openssl
    ];
    
    # Node.js configuration
    NODE_PATH = "$REPL_HOME/node_modules";
    NPM_CONFIG_PREFIX = "$REPL_HOME/.npm-global";
    PATH = "$REPL_HOME/.npm-global/bin:$PATH";
    
    # Next.js optimization
    NEXT_TELEMETRY_DISABLED = "1";
    NODE_OPTIONS = "--max-old-space-size=4096";
    
    # Replit environment
    REPLIT = "true";
  };
}
