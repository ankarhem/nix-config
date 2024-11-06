_: {
  programs.gpg = {
    enable = true;

    mutableKeys = false;
    mutableTrust = false;
    publicKeys = [
      {
        source = ./public-keys/jakob-2024-11-01.pub;
        trust = 5;
      }
      {
        source = ./public-keys/jonatan.pub;
        trust = 4;
      }
      {
        source = ./public-keys/william.pub;
        trust = 4;
      }
    ];

    # https://raw.githubusercontent.com/drduh/config/master/gpg.conf
    settings = {
      personal-cipher-preferences = "AES256 AES192 AES";
      personal-digest-preferences = "SHA512 SHA384 SHA256";
      personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
      default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
      cert-digest-algo = "SHA512";
      s2k-digest-algo = "SHA512";
      s2k-cipher-algo = "AES256";
      charset = "utf-8";
      no-comments = true;
      no-emit-version = true;
      no-greeting = true;
      keyid-format = "0xlong";
      list-options = "show-uid-validity";
      verify-options = "show-uid-validity";
      with-fingerprint = true;
      require-cross-certification = true;
      no-symkey-cache = true;
      armor = true;
      use-agent = true;
      throw-keyids = true;
    };
  };
}
