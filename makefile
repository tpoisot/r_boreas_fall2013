R=Rscript
VIEW=zathura
PDF=pdf
CONV= -t beamer
OPT= --highlight-style kate

# File names
SRC = seances
S1 = slides1
S2 = slides2

ALL: seance1 seance2

seance1: $(SRC)/$(S1).Rmd
	$(R) -e "library(knitr); knit('$(SRC)/$(S1).Rmd', '$(S1).md');"
	pandoc $(CONV) $(S1).md -o $(PDF)/$(S1).pdf $(OPT)
	rm $(S1).md

seance2: $(SRC)/$(S2).Rmd
	$(R) -e "library(knitr); knit('$(SRC)/$(S2).Rmd', '$(S2).md');"
	pandoc $(CONV) $(S2).md -o $(PDF)/$(S2).pdf $(OPT)
	rm $(S2).md

