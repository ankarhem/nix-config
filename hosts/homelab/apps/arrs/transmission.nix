{config,...}:let
  interface = "pia_wg0";
in {
  imports = [
    ../../../../nixosModules/pia-vpn.nix
  ];


  sops.secrets.pia_username = {};
  sops.secrets.pia_password = {};

  sops.templates."pia-certificate-file".contents = ''
    <programlisting>
    PIA_USER=${config.sops.placeholder.pia_username}
    PIA_PASS=${config.sops.placeholder.pia_password}
    </programlisting>
  '';

  services.pia-vpn = {
    enable = true;
    certificateFile = config.sops.templates."pia-certificate-file".path;
    inherit interface;
  };
}
