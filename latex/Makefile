PDF = report.pdf
MAIN = main.tex

.PHONY: all content clean

all: content $(PDF)

content: content.tex

content.tex: ../rrrrrreporrrrrrt.md tools/md_to_tex.py
	python3 tools/md_to_tex.py

$(PDF): $(MAIN) content.tex $(wildcard figures/plottwists/*.png)
	latexmk -pdf -interaction=nonstopmode -halt-on-error -jobname=report $(MAIN)

clean:
	latexmk -C -jobname=report $(MAIN)
