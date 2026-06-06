{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    opentofu
    talosctl
    kubectl
    fluxcd
  ];
}
