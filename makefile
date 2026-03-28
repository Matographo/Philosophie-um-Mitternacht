# =============================================================================
# Makefile für das Buch-Projekt
# =============================================================================
# Verwendung:
#   make              - PDF erstellen
#   make clean        - Build-Artefakte entfernen
#   make cleanall     - Alles inkl. PDF entfernen
#   make install-deps - Fehlende TeX-Pakete installieren
# =============================================================================

SRC_DIR := src/main/latex
BUILD_DIR := build
AUX_DIR := $(BUILD_DIR)/aux
DIST_DIR := $(BUILD_DIR)
MAIN_TEX := main.tex
MAIN_PDF := $(basename $(MAIN_TEX)).pdf

# Alle relevanten Quellen tracken
SRC_FILES := $(shell find $(SRC_DIR) -type f \( -name '*.tex' -o -name '*.bib' -o -name '*.sty' -o -name '*.png' -o -name '*.jpg' -o -name '*.pdf' \))

all: $(DIST_DIR)/$(MAIN_PDF)

$(DIST_DIR)/$(MAIN_PDF): $(SRC_FILES)
	@mkdir -p $(AUX_DIR)
	@rsync -a --checksum -f"+ */" -f"+ *" -f"- *" --link-dest="$(abspath $(SRC_DIR))" $(SRC_DIR)/ $(AUX_DIR)/
	@cd $(AUX_DIR) && latexmk -pdf $(MAIN_TEX)
	@cp $(AUX_DIR)/$(MAIN_PDF) $(DIST_DIR)/

clean:
	@rm -rf $(AUX_DIR)

cleanall: clean
	@rm -f $(DIST_DIR)/$(MAIN_PDF)
	@rm -fr $(DIST_DIR)

# -----------------------------------------------------------------------------
# Abhängigkeiten installieren
# -----------------------------------------------------------------------------
install-deps:
	@echo "Installiere benötigte TeX-Pakete..."
	@./install.sh

.PHONY: all clean cleanall install-deps
