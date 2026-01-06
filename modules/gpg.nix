_:
let
  environment.variables = {
    GNUPGHOME = "~/.gnupg";
    KEYID = "529972E4160200DF";
  };

  flake.modules.nixos.gpg = {
    inherit environment;
  };
  flake.modules.darwin.gpg = {
    inherit environment;
  };
  flake.modules.homeManager.gpg =
    { pkgs, ... }:
    let
      fetchKey =
        {
          key,
          hash,
          keyserver ? "keys.openpgp.org",
        }:
        let
          validKeyservers = [ "keys.openpgp.org" ];
          url =
            if keyserver == "keys.openpgp.org" then
              "https://${keyserver}/vks/v1/by-keyid/${key}"
            else
              abort "Invalid keyserver. Must be one of: ${builtins.toString validKeyservers}";
        in
        pkgs.fetchurl {
          inherit url hash;
        };
    in
    {
      # TODO: Create this using pkgs.writeShellApplication instead
      programs.fish.loginShellInit = ''
        function secret
          set output (string join . $argv[1] (date +%s) enc)
          gpg --encrypt --armor --output $output -r ${environment.variables.KEYID} $argv[1]
          and echo "$argv[1] -> $output"
        end

        function reveal
          set output (echo $argv[1] | rev | cut -c16- | rev)
          gpg --decrypt --output $output $argv[1]
          and echo "$argv[1] -> $output"
        end

        function copy-term-info
          infocmp -x | ssh $argv[1] -- tic -x -
        end
      '';
      programs.gpg = {
        enable = true;

        mutableKeys = true;
        mutableTrust = false;
        publicKeys = [
          {
            source = fetchKey {
              key = "529972E4160200DF";
              hash = "sha256-Hgr7+Uze9Hlr3cobKwwsrU9OS4luL6LzLVOoZBNrPtw=0";
            };
            trust = 5;
          }
          {
            source = fetchKey {
              key = "304CB5F9C479DFFA";
              hash = "sha256-JyH3kUJiNMAF49RM0H3Zjs75BJfYl0BlF0gsfeeQT+s=";
            };
            trust = 3;
          }
          {
            source = pkgs.fetchurl {
              url = "https://github.com/krabba.gpg";
              hash = "sha256-XWXfQ/rI/0eBmUCaA3TtXlwN0K9C+pXF6jfsMRh0yYA=";
            };
            trust = 2;
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
    };
in
{
  inherit flake;
}
