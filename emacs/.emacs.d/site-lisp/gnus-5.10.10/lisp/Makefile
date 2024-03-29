prefix = /usr/local
datarootdir = ${prefix}/share
datadir = ${datarootdir}
lispdir = $(datadir)/emacs/site-lisp/gnus
srcdir = .
subdir = lisp
top_srcdir = ..

EMACS = emacs
FLAGS = -batch -q -no-site-file -l $(srcdir)/dgnushack.el
INSTALL = /usr/bin/install -c
INSTALL_DATA = ${INSTALL} -m 644
SHELL = /bin/sh

W3DIR = no
URLDIR = /usr/local/share/emacs/23.2/lisp/url/
EMACS_COMP = URLDIR=$(URLDIR) W3DIR=$(W3DIR) lispdir="$(lispdir)" srcdir=$(srcdir) $(EMACS) $(FLAGS)

all total: clean-some gnus-load.el
	$(EMACS_COMP) -f dgnushack-compile

clean-some:
	rm -f *.elc gnus-load.el auto-autoloads.* custom-load.*

warn: clean-some gnus-load.el
	$(EMACS_COMP) --eval '(dgnushack-compile t)' 2>&1 | egrep -v "variable G|inhibit-point-motion-hooks|coding-system|temp-results|variable gnus|variable nn|scroll-in-place|deactivate-mark|filladapt-mode|byte-code-function-p|print-quoted|ps-right-header|ps-left-header|article-inhibit|print-escape|ssl-program-arguments|message-log-max"

# The "clever" rule is unsafe, since redefined macros are loaded from
# .elc files, and not the .el file.
clever some l: gnus-load.el
	$(EMACS_COMP) -f dgnushack-compile

install: install-el-elc list-installed-shadows

# This entry will never install .el files if there are no .elc files.
install-el: gnus-load.el
	$(SHELL) $(top_srcdir)/mkinstalldirs "$(lispdir)"
	$(INSTALL_DATA) gnus-load.el "$(lispdir)/gnus-load.el"
	@for p in *.elc; do \
	  p=`basename $$p c`; \
	  if [ -f "$(srcdir)/$$p" ]; then \
	    echo "$(INSTALL_DATA) $$p \"$(lispdir)/$$p\""; \
	    $(INSTALL_DATA) $(srcdir)/$$p "$(lispdir)/$$p"; \
	  fi; \
	done

install-elc: clever
	rm -f dgnushack.elc
	$(SHELL) $(top_srcdir)/mkinstalldirs "$(lispdir)"
	@for p in *.elc; do \
	  echo "$(INSTALL_DATA) $$p \"$(lispdir)/$$p\""; \
	  $(INSTALL_DATA) $$p "$(lispdir)/$$p"; \
	done

install-el-elc: clever
	rm -f dgnushack.elc
	$(SHELL) $(top_srcdir)/mkinstalldirs "$(lispdir)"
	$(INSTALL_DATA) gnus-load.el "$(lispdir)/gnus-load.el"
	@for p in *.elc; do \
	  q=`basename $$p c`; \
	  if [ -f "$(srcdir)/$$q" ]; then \
	    echo "$(INSTALL_DATA) $$q \"$(lispdir)/$$q\""; \
	    $(INSTALL_DATA) $(srcdir)/$$q "$(lispdir)/$$q"; \
	  fi; \
	  echo "$(INSTALL_DATA) $$p \"$(lispdir)/$$p\""; \
	  $(INSTALL_DATA) $$p "$(lispdir)/$$p"; \
	done

list-installed-shadows:
	$(EMACS_COMP) -f dgnushack-find-lisp-shadows

remove-installed-shadows:
	$(EMACS_COMP) -f dgnushack-remove-lisp-shadows

uninstall:
	for p in *.elc; do \
	  rm -f "$(lispdir)/$$p"; \
	done
	cd $(srcdir); \
	for p in *.el; do \
	  rm -f "$(lispdir)/$$p"; \
	done

tags:
	etags *.el

separately:
	rm -f *.elc ; for i in *.el; do $(EMACS) $(FLAGS) -f batch-byte-compile $$i; done

pot:
	xpot -drgnus -r`cat ./version` *.el > rgnus.pot

gnus-load.el:
	$(EMACS_COMP) -f dgnushack-make-cus-load $(srcdir)
	$(EMACS_COMP) -f dgnushack-make-auto-load $(srcdir)
	$(EMACS_COMP) -f dgnushack-make-load

clean:
	rm -f *.elc *.orig *.rej *~ auto-autoloads.* custom-load.* gnus-load.el

distclean: clean
	rm -f Makefile

Makefile: $(srcdir)/Makefile.in ../config.status
	cd .. \
	  && CONFIG_FILES=$(subdir)/$@ CONFIG_HEADERS= $(SHELL) ./config.status

# Tell versions [3.59,3.63) of GNU make to not export all variables.
# Otherwise a system limit (for SysV at least) may be exceeded.
.NOEXPORT:
