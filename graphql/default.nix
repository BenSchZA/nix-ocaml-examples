# standalone derivation, for nix-build, nix-shell, etc
{ pkgs ? import <nixpkgs> {}, opam2nix ? pkgs.callPackage ./release/default.nix {} }:
pkgs.callPackage ./nix { inherit opam2nix; }
