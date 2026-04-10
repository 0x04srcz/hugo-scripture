{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  # https://devenv.sh/packages/
  packages =
    with pkgs;
    [
      hugo
    ];

  # https://devenv.sh/processes/
  # processes.cargo-watch.exec = "cargo-watch";
  processes.hugo-watch.exec = "hugo server -D";

  # See full reference at https://devenv.sh/reference/options/
}
