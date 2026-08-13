#!/bin/sh

sudo nix-env --delete-generations old
sudo nix-collect-garbage -d
sudo nix-store --optimise
sudo nix-channel --remove nixos
sudo nix-channel --update
