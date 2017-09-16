TEX=xelatex
TEXFLAGS=-interaction=nonstopmode

all: out/5.pdf out/6.pdf out/7.pdf

out/%.pdf: %/main.tex common/uruwi.sty
	mkdir -p out
	$(TEX) $(TEXFLAGS) -jobname=$* -output-directory=out $<
	$(TEX) $(TEXFLAGS) -jobname=$* -output-directory=out $<

clean:
	rm -rf out
