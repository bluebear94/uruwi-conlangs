TEX=xelatex
TEXFLAGS=-interaction=nonstopmode -halt-on-error

all: out/5.pdf out/6.pdf out/7.pdf out/oz.pdf out/4.pdf out/8.pdf out/8.5.pdf out/7_1.pdf out/9.pdf

out/4.pdf: 4/dict/dict.tex

out/5.pdf: 5/dict/dict.tex

out/6.pdf: 6/dict/dict.tex

out/7.pdf: 7/dict/dict.tex

out/7_1.pdf: 7_1/dict/dict.tex

out/8.pdf: 8/dict/dict.tex

out/8.5.pdf: 8.5/dict/dict.tex

out/9.pdf: 9/dict/dict.tex

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
	$(TEX) $(TEXFLAGS) -jobname=$* -output-directory=out $< || (rm $@; false)
	$(TEX) $(TEXFLAGS) -jobname=$* -output-directory=out $< || (rm $@; false)

clean:
	rm -rf out

yukkuri:
	@echo "ゆっくりしていってね！"
