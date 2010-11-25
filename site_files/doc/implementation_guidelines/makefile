N=simon_wfreport

$N.pdf: *.tex 
	pdflatex $N.tex
	pdflatex $N.tex

check:
	aspell -l pt -c -t *.tex

clean:
	rm -f *.aux *.toc *. *.bbl *.blg *.pdf *.log *.nav *.out *.snm *.vrb
