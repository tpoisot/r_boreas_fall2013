R=Rscript
VIEW=zathura
PDF=pdf
CONV= -t beamer
OPT= --highlight-style kate

# File names
SRC = seances
S1 = slides1

ALL: seance1

seance1: $(SRC)/$(S1).Rmd
	$(R) -e "library(knitr); knit('$(SRC)/$(S1).Rmd', '$(S1).md');"
	pandoc $(CONV) $(S1).md -o $(PDF)/$(S1).pdf $(OPT)
	rm $(S1).md
