INPUT_FILENAME ?= test_data.csv

.phoney: pdf pdfs clean

pdf:
	gawk 'BEGIN { RS=","; ORS="\n" } { print }' ${INPUT_FILENAME} > data.dat
	sed 's/_//g' data.dat > data_stripped.dat
	pdflatex -synctex=1 -interaction=nonstopmode template.tex
	rm data.dat data_stripped.dat	

pdfs: pdf
	pdftk template.pdf burst output ; \
	ls pg_000* > pdf.list
	sed "s/,.*//" ${INPUT_FILENAME} > name.list
	sed -i 's/ /_/g' name.list
	paste -d ' ' pdf.list name.list | sed -e "s/^/mv /" -e "s/$$/.pdf/" > cmds.list
	sh cmds.list
	rm *.list template.pdf
	
clean:
	rm *.pdf *.txt *.aux *.dvi *.log *.gz
