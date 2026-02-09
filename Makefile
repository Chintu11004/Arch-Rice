# ---- Config ----
QS      ?= qs
QSB     ?= /usr/lib/qt6/bin/qsb
GLSL    ?= 320es

SHADER_DIR := shaders

# Find source shader files
FRAG_SRC := $(shell find $(SHADER_DIR) -type f -name '*.frag')
//VERT_SRC := $(shell find $(SHADER_DIR) -type f -name '*.vert')

# Output .qsb targets
FRAG_QSB := $(FRAG_SRC:.frag=.frag.qsb)
VERT_QSB := $(VERT_SRC:.vert=.vert.qsb)

QSB_OUT := $(FRAG_QSB) $(VERT_QSB)

# ---- Targets ----
.PHONY: all shaders run clean
all: shaders

shaders: $(QSB_OUT)
	@echo "✅ Shaders compiled."

run: shaders
	@echo "🚀 Running qs..."
	@$(QS)

clean:
	@rm -f $(QSB_OUT)
	@echo "🧹 Removed compiled shaders."

# ---- Pattern rules ----
%.frag.qsb: %.frag
	@echo "Compiling $< -> $@"
	@$(QSB) --glsl $(GLSL) -o $@ $<

%.vert.qsb: %.vert
	@echo "Compiling $< -> $@"
	@$(QSB) --glsl $(GLSL) -o $@ $<

