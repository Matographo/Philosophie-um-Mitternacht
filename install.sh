#!/bin/bash
# =============================================================================
# Install-Script für das Buch-Projekt
# =============================================================================
# Installiert alle für dieses Projekt benötigten TeX-Pakete.
# Unterstützt: TeX Live (Linux/macOS), MiKTeX (optional)
# =============================================================================

set -e

echo "============================================"
echo "LaTeX-Abhängigkeiten werden installiert..."
echo "============================================"

# Erkennung der TeX-Distribution
detect_tex_distro() {
    if command -v tlmgr &> /dev/null; then
        echo "texlive"
    elif command -v mpm &> /dev/null; then
        echo "miktex"
    elif command -v apt-get &> /dev/null; then
        echo "apt"
    else
        echo "unknown"
    fi
}

# Liste der benötigten Pakete
PACKAGES=(
    # Kern-Pakete
    "texlive-latex-base"
    "texlive-latex-extra"
    "texlive-latex-recommended"
    "texlive-publishers"
    
    # Spezifische Pakete für dieses Projekt
    "texlive-pictures"        # TikZ, pgf
    "texlive-science"          # amsmath, amssymb
    "texlive-fonts-recommended" # mathpazo
    "texlive-humanities"       # babel-german
    "texlive-bibtex-extra"     # biber
    "texlive-generic-extra"    # xstring
    "texlive-games"            # todonotes
    "texlive-music"            # booktabs
    
    # Zusätzliche Werkzeuge
    "latexmk"
    "biber"
    "make"
    "rsync"
)

install_texlive() {
    echo "Erkannt: TeX Live"
    echo ""
    echo "Bitte führen Sie aus:"
    echo "  tlmgr install ${PACKAGES[*]}"
    echo ""
    echo "Oder für eine vollständige Installation:"
    echo "  tlmgr install scheme-full"
    echo ""
    echo "Bei Fragen: https://tug.org/texlive/"
}

install_apt() {
    echo "Erkannt: apt (Debian/Ubuntu)"
    echo ""
    echo "Installiere Pakete..."
    sudo apt-get update
    sudo apt-get install -y "${PACKAGES[@]}"
    echo ""
    echo "Fertig!"
}

install_miktex() {
    echo "Erkannt: MiKTeX"
    echo ""
    echo "MiKTeX sollte fehlende Pakete automatisch herunterladen."
    echo "Falls nicht, öffnen Sie die MiKTeX Console und installieren Sie:"
    echo "  - texlive-latex-base"
    echo "  - texlive-latex-extra"
    echo "  - texlive-pictures"
    echo "  - biber"
    echo "  - latexmk"
}

install_unknown() {
    echo "Keine bekannte TeX-Distribution gefunden."
    echo ""
    echo "Bitte installieren Sie eine der folgenden:"
    echo "  - TeX Live: https://tug.org/texlive/"
    echo "  - MiKTeX: https://miktex.org/"
    echo "  - MacTeX (macOS): https://tug.org/mactex/"
    echo ""
    echo "Nach der Installation führen Sie dieses Script erneut aus."
    exit 1
}

# Hauptprogramm
DISTRO=$(detect_tex_distro)

case "$DISTRO" in
    texlive)
        install_texlive
        ;;
    apt)
        install_apt
        ;;
    miktex)
        install_miktex
        ;;
    *)
        install_unknown
        ;;
esac

echo "============================================"
echo "Fertig!"
echo "============================================"
