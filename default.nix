{ pkgs ? import <nixpkgs> { }
, theme ? "neko-spin"
, bgColor ? "1, 1, 1"
}:
pkgs.stdenv.mkDerivation {
  pname = "mans-plymouth";
  version = "0.1.4";

  src = ./src;

  # buildInputs = [ pkgs.ffmpeg ];

  buildPhase = ''
    # Create theme directory
    mkdir -p "${theme}"
    
    # Process plymouth file
    cp template.plymouth "${theme}/${theme}.plymouth"
    substituteInPlace "${theme}/${theme}.plymouth" \
      --replace 'THEME' "${theme}" \
      --replace 'generic' "${theme}"
    
    # Process script file (если нужно)
    cp generic.script "${theme}/${theme}.script"
    substituteInPlace "${theme}/${theme}.script" \
      --replace 'Window.SetBackgroundTopColor (0.16, 0.00, 0.12);' \
                'Window.SetBackgroundTopColor ${bgColor};'
  '';

  installPhase = ''
    # Install all theme files
    install -m 755 -D -t "$out/share/plymouth/themes/${theme}" \
      "${theme}/${theme}.plymouth" \
      "${theme}/${theme}.script"
    
    # Install PNG assets (если есть)
    install -m 644 -D -t "$out/share/plymouth/themes/${theme}" \
      "${theme}/"*.png
    
    # Fix paths in installed files
    substituteInPlace "$out/share/plymouth/themes/${theme}/${theme}.plymouth" \
      --replace "/usr/" "$out/"
  '';
}