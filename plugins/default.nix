final: prev:
let
  pluginFiles = builtins.attrNames (builtins.readDir ./.);
  pluginNames = builtins.filter (name: (builtins.match ".*\.nix" name != null) && name != "default.nix") pluginFiles;

in
{
  nvimPlugins = builtins.listToAttrs (map
    (name:
      {
        name = builtins.replaceStrings [ ".nix" ] [ "" ] name;
        value = prev.callPackage (./. + "/${name}") { };
      }
    )
    pluginNames);
}

