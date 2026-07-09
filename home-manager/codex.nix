{ lib, ... }:

{
  home.activation.codexConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    codex_dir="$HOME/.codex"
    codex_config="$codex_dir/config.toml"
    codex_template=${../.codex/user-config.toml}

    mkdir -p "$codex_dir"

    if [ -L "$codex_config" ]; then
      tmp_config="$(mktemp "$codex_dir/config.toml.XXXXXX")"

      if [ -e "$codex_config" ]; then
        cp "$codex_config" "$tmp_config"
      else
        cp "$codex_template" "$tmp_config"
      fi

      rm "$codex_config"
      mv "$tmp_config" "$codex_config"
      chmod u+rw "$codex_config"
    elif [ ! -e "$codex_config" ]; then
      cp "$codex_template" "$codex_config"
      chmod u+rw "$codex_config"
    else
      chmod u+w "$codex_config"
    fi
  '';
}
