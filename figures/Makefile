all:  hybrid.pdf

%.pdf: %.tex
	pdflatex --interaction=nonstopmode $^

clean:
	rm *.log *.pdf *.aux