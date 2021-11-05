all: paper_arxiv.pdf
	open -a Skim paper_arxiv.pdf

paper.pdf: paper.md paper.bib figures
	docker run -v "$(PWD):/data" faroit/whedon 2>&1 | grep Warning

paper_arxiv.pdf: paper_arxiv.tex paper.bib figures
	pdflatex paper_arxiv.tex && pdflatex paper_arxiv.tex && bibtex paper_arxiv && pdflatex paper_arxiv.tex

figures:
	$(MAKE) -C figures all

clean:
	rm *.log *.pdf *.aux *.blg *.out *.bbl

clean_all: clean
	$(MAKE) -C figures clean

.PHONY: figures all
