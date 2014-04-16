SRC = $(wildcard *.md)

PDFS=$(SRC:.md=.pdf)
HTML=$(SRC:.md=.html)
LATEX_TEMPLATE=./pandoc-templates/default.latex

all:    clean $(PDFS) $(HTML)

pdf:   clean $(PDFS)
html:  clean $(HTML)

%.html: %.md
	python resume.py html $(GRAVATAR_OPTION) < $< | pandoc -t html -c resume.css -o $@
	pandoc --from=markdown --to=rst --output=./docs/source/resume.rst resume.md
	cd ./docs && $(MAKE) html

%.pdf:  %.md $(LATEX_TEMPLATE)
	python resume.py tex < $< | pandoc --template=$(LATEX_TEMPLATE) -H header.tex -o $@
	pandoc --from=markdown --to=rst --output=./docs/source/resume.rst resume.md
	cd ./docs && $(MAKE) latexpdf

ifeq ($(OS),Windows_NT)
  # on Windows
  RM = cmd //C del
else
  # on Unix
  RM = rm -f
endif

clean:
	$(RM) *.html *.pdf
	$(RM) ./docs/source/resume.rst
	cd ./docs && $(MAKE) clean

$(LATEX_TEMPLATE):
	git submodule update --init
