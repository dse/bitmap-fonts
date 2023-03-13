SRC_FONTS  := $(wildcard src/*.font.txt)
SRC_CHARS  := $(wildcard src/*.chars.txt)
BDFS       := $(patsubst src/%.font.txt,bdf/%.bdf,$(SRC_FONTS))
TTFS       := $(patsubst src/%.font.txt,ttf/%.ttf,$(SRC_FONTS))
SFDS       := $(patsubst src/%.font.txt,sfd/%.sfd,$(SRC_FONTS))
BDFBDF := ~/git/dse.d/perl-font-bitmap/bin/bdfbdf
BDFBDF_OPTIONS :=
BITMAPFONT2TTF := bitmapfont2ttf
BITMAPFONT2TTF_OPTIONS :=

TARGETS := $(BDFS) $(TTFS) $(SFDS)

default: $(TARGETS)
sfd: $(SFDS)

bdf/%.bdf: src/%.font.txt Makefile
	mkdir -p bdf || true
	$(BDFBDF) $(BDFBDF_OPTIONS) $< > $@.tmp.bdf
	mv $@.tmp.bdf $@
sfd/%.sfd: bdf/%.bdf Makefile
	mkdir -p sfd || true
	$(BITMAPFONT2TTF) $(BITMAPFONT2TTF_OPTIONS) $< $@.tmp.sfd
	mv $@.tmp.sfd $@
ttf/%.ttf: bdf/%.bdf Makefile
	mkdir -p ttf || true
	$(BITMAPFONT2TTF) $(BITMAPFONT2TTF_OPTIONS) $< $@.tmp.ttf
	mv $@.tmp.ttf $@

ttf/2316-1%.ttf: bdf/2316-1%.bdf Makefile
	mkdir -p ttf || true
	$(BITMAPFONT2TTF) $(BITMAPFONT2TTF_OPTIONS) --top=0.5 $< $@.tmp.ttf
	mv $@.tmp.ttf $@
ttf/2316-2%.ttf: bdf/2316-2%.bdf Makefile
	mkdir -p ttf || true
	$(BITMAPFONT2TTF) $(BITMAPFONT2TTF_OPTIONS) --top=0.625 $< $@.tmp.ttf
	mv $@.tmp.ttf $@
ttf/2316-3%.ttf: bdf/2316-3%.bdf Makefile
	mkdir -p ttf || true
	$(BITMAPFONT2TTF) $(BITMAPFONT2TTF_OPTIONS) --top=0.6875 $< $@.tmp.ttf
	mv $@.tmp.ttf $@
ttf/2316-4%.ttf: bdf/2316-4%.bdf Makefile
	mkdir -p ttf || true
	$(BITMAPFONT2TTF) $(BITMAPFONT2TTF_OPTIONS) --top=0.75 $< $@.tmp.ttf
	mv $@.tmp.ttf $@

clean:
	/bin/rm $(BDFS) $(TTFS) */*.tmp.* >/dev/null 2>/dev/null || true

