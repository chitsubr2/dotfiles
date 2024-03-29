prefix = /usr/local
datarootdir = ${prefix}/share
infodir = ${datarootdir}/info
srcdir = .
subdir = texi
top_srcdir = ..


TEXI2DVI=texi2dvi
TEXI2PDF=texi2pdf
MAKEINFO=makeinfo
EMACS=emacs
EMACSCOMP=$(EMACS) -batch -q -no-site-file
EMACSINFO=$(EMACSCOMP) -l $(srcdir)/infohack.el -f batch-makeinfo
PDFLATEX=pdflatex
LATEX=no
DVIPS=dvips
INSTALL = /usr/bin/install -c
INSTALL_DATA = ${INSTALL} -m 644
SHELL = /bin/sh
PAPERTYPE=a4
INFO_DEPS=gnus message emacs-mime sieve pgg
REFCARD=gnus-refcard
LOGO=gnus-logo

all: $(INFO_DEPS)

most: texi2latex.elc latex latexps

.SUFFIXES: .texi .dvi .ps .pdf .latexi .dvi-x .pdf-x

.texi:
	if test "x$(MAKEINFO)" != "xno" ; then \
	  $(MAKEINFO) -I $(srcdir) -o $* $<; \
	else \
	  rm -f $@; \
	  $(EMACSINFO) $<; \
	fi

dvi: gnus.dvi message.dvi $(REFCARD).dvi emacs-mime.dvi sieve.dvi pgg.dvi

pdf: gnus.pdf message.pdf $(REFCARD).pdf emacs-mime.pdf sieve.pdf pgg.pdf

.texi.dvi :
	sed -e '/@iflatex/,/@end iflatex/d' $< > gnustmp.texi
	$(TEXI2DVI) -I $(srcdir) gnustmp.texi
	cp gnustmp.dvi $*.dvi
	rm -f gnustmp.*

.dvi.ps :
	TEXPICTS=$(srcdir) $(DVIPS) -t $(PAPERTYPE) -f $< > $@

.texi.pdf :
	sed -e '/@iflatex/,/@end iflatex/d' $< > gnustmp.texi
	$(TEXI2PDF) -I $(srcdir) gnustmp.texi
	cp gnustmp.pdf $*.pdf
	rm -f gnustmp.*

$(LOGO).pdf:	$(LOGO).eps
	epstopdf $< --outfile=$@

$(REFCARD).dvi: $(REFCARD).tex $(LOGO).eps
	TEXINPUTS=$(srcdir):$$TEXINPUTS:: $(LATEX) $(REFCARD).tex

$(REFCARD).pdf: $(REFCARD).tex $(LOGO).pdf
	TEXINPUTS=$(srcdir):$$TEXINPUTS:: $(PDFLATEX) $(REFCARD).tex

gnus-booklet.dvi: $(REFCARD).tex $(LOGO).eps
	if [ "$(PAPERTYPE)" == a4 ]; then \
	  TEXINPUTS=$(srcdir):$$TEXINPUTS:: \
          $(LATEX) '\def\booklettrue{}\input{$(REFCARD)}' ;\
	else \
	  TEXINPUTS=$(srcdir):$$TEXINPUTS:: \
          $(LATEX) '\def\booklettrue{}\def\letterpapertrue{}\input{$(REFCARD)}' ;\
	fi
	mv $(REFCARD).dvi $@

gnus-booklet.pdf: $(REFCARD).tex  $(LOGO).pdf
	if [ "$(PAPERTYPE)" == a4 ]; then \
	  TEXINPUTS=$(srcdir):$$TEXINPUTS:: \
          $(PDFLATEX) '\def\booklettrue{}\input{$(REFCARD)}' ;\
	else \
	  TEXINPUTS=$(srcdir):$$TEXINPUTS:: \
          $(PDFLATEX) '\def\booklettrue{}\def\letterpapertrue{}\input{$(REFCARD)}' ;\
	fi
	mv $(REFCARD).pdf $@

gnus-faq-full-update: gnus-faq-clean gnus-faq-texi

gnus-faq.xml:
	cvs -z3 -d:pserver:anonymous@cvs.sourceforge.net:/cvsroot/gnus \
	  co -p gnus-faq/src/gnus-faq.xml > $@.tmp
	head -n 1 $@.tmp | grep '^<.xml version' || \
	  { echo "Update of $@ failed."; : rm $@.tmp; exit 1; }
	mv $@.tmp $@

gnus-faq-texi: gnus-faq.xml xml2texi.sh xml2texi.scm
	./xml2texi.sh $< $@.tmp
	@echo
# FIXME: This should be done in xml2texi.scm or gnus-faq.xml should be
# changed:
	sed '/[$$]Id:.*[$$]/d' < $@.tmp > $@

gnus-faq-clean:
	rm -f gnus-faq.xml gnus-faq.*.tmp gnus-faq.texi

almost-clean:
	rm -f *.[cgk]idx *.aux *.cp *.cps *.dvi *.dvi-x *.fn *.ky	\
	*.kys *.latexi *.log *.orig *.pdf *.pdf-x *.pg *.rej		\
	*.tmplatexi *.toc *.tp *.vr gnus.*.bak gnus.[cgk]ind gnus.idx	\
	gnus.ilg gnus.ind gnus.latexi*~* gnus.out gnus.tmplatexi1	\
	gnustmp.texi picons.tex smiley.tex texput.log thumb*.png	\
	thumbdta.tex xface.tex *.tpt gnus-manual-*.pdf gnus-manual-*.ps.gz

makeinfo:
	makeinfo -o gnus gnus.texi
	makeinfo -o message message.texi

texi2latex.elc: texi2latex.el
	srcdir=$(srcdir)/../lisp $(EMACSCOMP) -l $(srcdir)/../lisp/dgnushack.el --eval '(byte-compile-file "$(srcdir)/texi2latex.el")'

latex: gnus.latexi gnus-faq.latexi message.latexi emacs-mime.latexi sieve.latexi pgg.latexi

gnus.latexi gnus-faq.latexi message.latexi emacs-mime.latexi sieve.latexi pgg.latexi: $(srcdir)/gnus.texi $(srcdir)/gnus-faq.texi $(srcdir)/message.texi $(srcdir)/emacs-mime.texi $(srcdir)/sieve.texi $(srcdir)/pgg.texi texi2latex.elc
	srcdir=$(srcdir) $(EMACSCOMP) -l ./texi2latex.elc -f latexi-translate

.latexi.dvi-x:
	make gnusconfig.tex
	make tmps
	rm -f gnus.aux gnus.toc
	cp $< gnus.tmplatexi
	TEXINPUTS=$(srcdir):$$TEXINPUTS $(LATEX) gnus.tmplatexi
	$(srcdir)/splitindex
	makeindex -o gnus.kind gnus.kidx
	makeindex -o gnus.cind gnus.cidx
	makeindex -o gnus.gind gnus.gidx
	sed 's/\\char 5E\\relax {}/\\symbol{"5E}/' < gnus.kind > gnus.tmpkind
	mv gnus.tmpkind gnus.kind
	egrep -v "end\{document\}" $< > gnus.tmplatexi
	cat $(srcdir)/postamble.tex >> gnus.tmplatexi
	TEXINPUTS=$(srcdir):$$TEXINPUTS $(LATEX) gnus.tmplatexi
	TEXINPUTS=$(srcdir):$$TEXINPUTS $(LATEX) gnus.tmplatexi
	mv gnus.dvi $@

.latexi.pdf-x:
	make gnusconfig.tex
	make tmps
	cd ps; make pdf
	rm -f gnus.aux gnus.toc
	cp $< gnus.tmplatexi
	TEXINPUTS=$(srcdir):$$TEXINPUTS $(PDFLATEX) gnus.tmplatexi
	$(srcdir)/splitindex
	makeindex -o gnus.kind gnus.kidx
	makeindex -o gnus.cind gnus.cidx
	makeindex -o gnus.gind gnus.gidx
	sed 's/\\char 5E\\relax {}/\\symbol{"5E}/' < gnus.kind > gnus.tmpkind
	mv gnus.tmpkind gnus.kind
	egrep -v "end\{document\}" $< > gnus.tmplatexi
	cat $(srcdir)/postamble.tex >> gnus.tmplatexi
	TEXINPUTS=$(srcdir):$$TEXINPUTS $(PDFLATEX) gnus.tmplatexi
	#thumbpdf gnus.pdf
	#TEXINPUTS=$(srcdir):$$TEXINPUTS $(PDFLATEX) gnus.tmplatexi
	mv gnus.pdf $@

latexps: gnus.dvi-x
	TEXPICTS=$(srcdir) $(DVIPS) -t a4 -f $< > gnus.ps

latexpdf: gnus.pdf-x
	mv gnus.pdf-x gnus.pdf

gnus-manual-a4.latexi: gnus.latexi
	cp $< $@

gnus-manual-standard.latexi: gnus.latexi
	sed 's/,a4paper/,letterpaper/' $< > $@

gnus-manual-a4.ps.gz: gnus-manual-a4.dvi-x
	TEXPICTS=$(srcdir) $(DVIPS) -t a4 -f $< | gzip -c > $@

gnus-manual-standard.ps.gz: gnus-manual-standard.dvi-x
	TEXPICTS=$(srcdir) $(DVIPS) -t letter -f $< | gzip -c > $@

pdfs: gnus-manual-a4.pdf-x gnus-manual-standard.pdf-x
	mv gnus-manual-a4.pdf-x gnus-manual-a4.pdf
	mv gnus-manual-standard.pdf-x gnus-manual-standard.pdf

pss: latexps

complete: pss

psout: latexboth out

latexboth: gnus-manual-a4.ps.gz gnus-manual-standard.ps.gz

out:
	scp gnus-manual-*.ps.gz gnus-manual-*.pdf www@quimby:html/gnus/documents

clean: almost-clean
	rm -f gnus.dvi gnus.ps texi2latex.elc
	rm -f gnus-manual-a4.* gnus-manual-standard.*

distclean: clean
	rm -f *.orig *.rej *.elc *~ gnus-[0-9] gnus-[0-9][0-9] Makefile
	rm -f message-[0-9]
	rm -f $(INFO_DEPS)
	rm -f gnusconfig.tex
	rm -f gnus-faq.xml gnus-faq.*.tmp

install: $(INFO_DEPS)
	$(SHELL) $(top_srcdir)/mkinstalldirs "$(infodir)"
	@list='$(INFO_DEPS)'; \
	for file in $$list; do \
	  for ifile in `echo $$file $$file-[0-9] $$file-[0-9][0-9]`; do \
	    if test -f $$ifile; then \
	      echo "$(INSTALL_DATA) $$ifile \"$(infodir)/$$ifile\""; \
	      $(INSTALL_DATA) $$ifile "$(infodir)/$$ifile"; \
	    else : ; fi; \
	  done; \
	done
	@if $(SHELL) -c 'install-info --version | sed 1q | fgrep -s -v -i debian' >/dev/null 2>&1; then \
	  list='$(INFO_DEPS)'; \
	  for file in $$list; do \
	    echo "install-info --info-dir=\"$(infodir)\" \"$(infodir)/$$file\"";\
	    install-info --info-dir="$(infodir)" "$(infodir)/$$file" || :;\
	  done; \
	else : ; fi

uninstall:
	@list='$(INFO_DEPS)'; \
	for file in $$list; do \
	  for ifile in `echo $$file $$file-[0-9] $$file-[0-9][0-9]`; do \
	    rm -f "$(infodir)/$$ifile"; \
	  done; \
	done
	@if $(SHELL) -c 'install-info --version | sed 1q | fgrep -s -v -i debian' >/dev/null 2>&1; then \
	  list='$(INFO_DEPS)'; \
	  for file in $$list; do \
	    echo "install-info --delete --info-dir=\"$(infodir)\" \"$(infodir)/$$file\"";\
	    install-info --delete --info-dir="$(infodir)" "$(infodir)/$$file" || :;\
	  done; \
	else : ; fi

tmps:
	cd ps; make all
	for j in ps/picons-*.ps; do \
		i=ps/`basename $$j .ps`; \
		echo "\\gnuspicon{$$i}"; done > picons.tex
	for j in ps/xface-*.ps; do \
		i=ps/`basename $$j .ps`; \
		if [ -n "$$a" ]; then a=""; echo "{$$i}"; else \
		a="h"; echo -n "\\gnusxface{$$i}"; fi done > xface.tex; \
		if [ -n "$$a" ]; then echo "{$$i}" >> xface.tex; fi
	for j in ps/smiley-*.ps; do \
		i=ps/`basename $$j .ps`; \
		if [ -n "$$a" ]; then a=""; echo "{$$i}"; else \
		a="h"; echo -n "\\gnussmiley{$$i}"; fi done > smiley.tex; \
		if [ -n "$$a" ]; then echo "{$$i}" >> smiley.tex; fi
pspackage:
	cd ps; make almost-clean
	tar czvf pspackage.tar.gz gnus-faq.texi gnus.texi herds misc pagestyle.sty picons pixidx.sty postamble.tex ps screen smilies splitindex texi2latex.el xface Makefile README etc

Makefile: $(srcdir)/Makefile.in ../config.status
	cd .. \
	  && CONFIG_FILES=$(subdir)/$@ CONFIG_HEADERS= $(SHELL) ./config.status

gnusconfig.tex: $(srcdir)/gnusconfig.tex.in ../config.status
	cd .. \
	  && CONFIG_FILES=$(subdir)/$@ CONFIG_HEADERS= $(SHELL) ./config.status

# Tell versions [3.59,3.63) of GNU make to not export all variables.
# Otherwise a system limit (for SysV at least) may be exceeded.
.NOEXPORT:
