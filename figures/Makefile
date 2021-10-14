all:  hybrid.pdf residual.pdf

%.pdf: %.tex
	pdflatex --interaction=nonstopmode $^

clean:
	rm *.log *.pdf *.aux