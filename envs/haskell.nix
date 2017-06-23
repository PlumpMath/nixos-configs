{ config, pkgs, ... }:

let haskell_ = pkgs.haskellPackages.ghcWithPackages (haskellPackages: with haskellPackages; [
        QuickCheck hspec mtl lens arrows
        cabal-install cabal2nix
        purescript pkgs.psc-package
    ]);
    haskellEnv = with pkgs; myEnvFun {
      name = "haskell";
      buildInputs = [ stdenv haskell_ ];
      extraCmds = ''
        unset SSL_CERT_FILE
        eval "$(egrep ^export "$(type -p ghc)")"
      '';
  };
in
{
    environment.systemPackages = [ haskellEnv ];
}
