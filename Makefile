TEX=xelatex
TEXFLAGS=-interaction=nonstopmode

all: out/5.pdf out/6.pdf out/7.pdf

out/5.pdf: 5/dict/dict.tex

out/6.pdf: 6/dict/dict.tex

out/7.pdf: 7/dict/dict.tex

%/dict/dict.tex: \
		%/dict/main.dict \
		%/dict/options.json \
		workfiles/dict-to-tex.pl6
	perl6 workfiles/dict-to-tex.pl6 \
		$< \
		$@ \
		$*/dict/options.json

out/%.pdf: %/main.tex common/uruwi.sty
	mkdir -p out
	$(TEX) $(TEXFLAGS) -jobname=$* -output-directory=out $<
	$(TEX) $(TEXFLAGS) -jobname=$* -output-directory=out $<

clean:
	rm -rf out
