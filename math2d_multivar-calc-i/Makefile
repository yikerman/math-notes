TEX = pdflatex
FLAGS = -interaction=nonstopmode
SRC = main.tex
OUT = main.pdf

.PHONY: all clean

all: $(OUT)

$(OUT): $(SRC) ../preamble.tex $(wildcard sections/*.tex)
	$(TEX) $(FLAGS) $(SRC)
	$(TEX) $(FLAGS) $(SRC)

clean:
	rm -f *.aux *.log *.out *.toc *.pdf
