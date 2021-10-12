all: paper.pdf
	open -a Skim paper.pdf

paper.pdf: paper.md paper.bib figures
	docker run -v "$(PWD):/data" faroit/whedon 2>&1 | grep Warning

figures:
	$(MAKE) -C figures all

clean:
	$(MAKE) -C figures clean

.PHONY: figures all
