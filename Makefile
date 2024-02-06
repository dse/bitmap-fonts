SRC_FONTS  := $(wildcard src/*.font.txt)
SRC_CHARS  := $(wildcard src/*.chars.txt)
BDFS       := $(patsubst src/%.font.txt,dist/bdf/%.bdf,$(SRC_FONTS))
TTFS       := $(patsubst src/%.font.txt,dist/ttf/%.ttf,$(SRC_FONTS))
SFDS       := $(patsubst src/%.font.txt,dist/sfd/%.sfd,$(SRC_FONTS))
# BDFBDF := ~/git/dse.d/perl-font-bitmap/bin/bdfbdf
# BDFBDF_OPTIONS :=
BDFBDF := ~/git/dse.d/perl-font-bdf/bin/bdf2bdf
BDFBDF_OPTIONS :=
BITMAPFONT2TTF := bitmapfont2ttf
BITMAPFONT2TTF_OPTIONS :=

TARGETS := $(BDFS) $(TTFS) $(SFDS)

default: $(TARGETS)
sfd: $(SFDS)

dist/bdf/%.bdf: src/%.font.txt Makefile
	mkdir -p dist/bdf || true
	$(BDFBDF) $(BDFBDF_OPTIONS) $< > $@.tmp.bdf
	mv $@.tmp.bdf $@
dist/sfd/%.sfd: dist/bdf/%.bdf Makefile
	mkdir -p dist/sfd || true
	$(BITMAPFONT2TTF) $(BITMAPFONT2TTF_OPTIONS) $< $@.tmp.sfd
	mv $@.tmp.sfd $@
dist/ttf/%.ttf: dist/bdf/%.bdf Makefile
	mkdir -p dist/ttf || true
	$(BITMAPFONT2TTF) $(BITMAPFONT2TTF_OPTIONS) $< $@.tmp.ttf
	mv $@.tmp.ttf $@

clean:
	/bin/rm $(SFDS) $(BDFS) $(TTFS) */*.tmp.* >/dev/null 2>/dev/null || true

