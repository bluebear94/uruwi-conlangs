TEX=xelatex
TEXFLAGS=-interaction=nonstopmode -halt-on-error
LATEXMK=latexmk
LATEXMKFLAGS=\
	-xelatex \
	-output-directory=out \
	-quiet \
	-interaction=nonstopmode \
	-latexoption=-halt-on-error

all: out/5.pdf out/6.pdf out/7.pdf out/oz.pdf out/4.pdf out/8.pdf out/8.5.pdf out/7_1.pdf out/9.pdf out/wb.pdf out/10.pdf out/7_1_1.pdf

out/4.pdf: 4/dict/dict.tex

out/5.pdf: 5/dict/dict.tex

out/6.pdf: 6/dict/dict.tex

out/7.pdf: 7/dict/dict.tex

out/7_1.pdf: 7_1/dict/dict.tex

out/7_1_1.pdf: 7_1_1/dict/dict.tex

out/8.pdf: 8/dict/dict.tex

out/8.5.pdf: 8.5/dict/dict.tex

out/9.pdf: 9/dict/dict.tex

out/10.pdf: 10/dict/dict.tex

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
	$(LATEXMK) $(LATEXMKFLAGS) -jobname=$* $< || (rm $@; false)
	$(LATEXMK) $(LATEXMKFLAGS) -jobname=$* $< || (rm $@; false)

clean:
	rm -rf out

yukkuri:
	@echo "ゆっくりしていってね！"
