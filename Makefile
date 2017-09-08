TEX=xelatex
TEXFLAGS=-interaction=nonstopmode

all: out/5.pdf out/6.pdf out/7.pdf

out/%.pdf: %/main.tex
	$(TEX) $(TEXFLAGS) -output-directory=out $< || \
	$(TEX) $(TEXFLAGS) -output-directory=out $<
	mv out/main.pdf $@

