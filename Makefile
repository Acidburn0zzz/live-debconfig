# Makefile

## live-debconfig(7) - System Configuration Scripts
## Copyright (C) 2006-2013 Daniel Baumann <daniel@debian.org>
##
## This program comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
## This is free software, and you are welcome to redistribute it
## under certain conditions; see COPYING for details.


SHELL := sh -e

LANGUAGES = $(shell cd manpages/po && ls)

SCRIPTS = bin/* scripts/*/*

all: build

test:
	@echo -n "Checking for syntax errors"

	@for SCRIPT in $(SCRIPTS); \
	do \
		if [ -x $${SCRIPT} ]; \
		then \
			sh -n $${SCRIPT}; \
			echo -n "."; \
		fi; \
	done

	@echo " done."

	@if [ -x "$$(which checkbashisms 2>/dev/null)" ]; \
	then \
		echo -n "Checking for bashisms"; \
		for SCRIPT in $(SCRIPTS); \
		do \
			if [ -x $${SCRIPT} ]; \
			then \
				checkbashisms -f -x $${SCRIPT}; \
				echo -n "."; \
			fi; \
		done; \
		echo " done."; \
	else \
		echo "W: checkbashisms - command not found"; \
		echo "I: checkbashisms can be obtained from: "; \
		echo "I:   http://git.debian.org/?p=devscripts/devscripts.git"; \
		echo "I: On Debian based systems, checkbashisms can be installed with:"; \
		echo "I:   apt-get install devscripts"; \
	fi

build:
	@echo "Nothing to build."

install:
	# Installing scripts
	mkdir -p $(DESTDIR)/bin
	cp bin/* $(DESTDIR)/bin

	mkdir -p $(DESTDIR)/lib/live
	cp -r scripts/* $(DESTDIR)/lib/live

	# Installing docs
	mkdir -p $(DESTDIR)/usr/share/doc/live-debconfig
	cp -r COPYING examples $(DESTDIR)/usr/share/doc/live-debconfig

	# Installing manpages
	for MANPAGE in manpages/en/*; \
	do \
		SECTION="$$(basename $${MANPAGE} | awk -F. '{ print $$2 }')"; \
		install -D -m 0644 $${MANPAGE} $(DESTDIR)/usr/share/man/man$${SECTION}/$$(basename $${MANPAGE}); \
	done

	for LANGUAGE in $(LANGUAGES); \
	do \
		for MANPAGE in manpages/$${LANGUAGE}/*; \
		do \
			SECTION="$$(basename $${MANPAGE} | awk -F. '{ print $$3 }')"; \
			install -D -m 0644 $${MANPAGE} $(DESTDIR)/usr/share/man/$${LANGUAGE}/man$${SECTION}/$$(basename $${MANPAGE} .$${LANGUAGE}.$${SECTION}).$${SECTION}; \
		done; \
	done

uninstall:
	# Uninstalling scripts
	rm -rf $(DESTDIR)/lib/live $(DESTDIR)/lib/live/debconfig
	rmdir --ignore-fail-on-non-empty $(DESTDIR)/lib/live > /dev/null 2>&1 || true
	rmdir --ignore-fail-on-non-empty $(DESTDIR)/lib > /dev/null 2>&1 || true

	# Uninstalling docs
	rm -rf $(DESTDIR)/usr/share/doc/live-debconfig
	rmdir --ignore-fail-on-non-empty $(DESTDIR)/usr/share/doc > /dev/null 2>&1 || true
	rmdir --ignore-fail-on-non-empty $(DESTDIR)/usr/share > /dev/null 2>&1 || true
	rmdir --ignore-fail-on-non-empty $(DESTDIR)/usr > /dev/null 2>&1 || true

	# Uninstalling manpages
	for MANPAGE in manpages/en/*; \
	do \
		SECTION="$$(basename $${MANPAGE} | awk -F. '{ print $$2 }')"; \
		rm -f $(DESTDIR)/usr/share/man/man$${SECTION}/$$(basename $${MANPAGE} .en.$${SECTION}).$${SECTION}; \
		rmdir --ignore-fail-on-non-empty $(DESTDIR)/usr/share/man/man$${SECTION} > /dev/null 2>&1 || true; \
		rmdir --ignore-fail-on-non-empty $(DESTDIR)/usr/share/man > /dev/null 2>&1 || true; \
		rmdir --ignore-fail-on-non-empty $(DESTDIR)/usr/share > /dev/null 2>&1 || true; \
		rmdir --ignore-fail-on-non-empty $(DESTDIR)/usr > /dev/null 2>&1 || true; \
		rmdir --ignore-fail-on-non-empty $(DESTDIR) > /dev/null 2>&1 || true; \
	done

	for LANGUAGE in $(LANGUAGES); \
	do \
		for MANPAGE in manpages/$${LANGUAGE}/*; \
		do \
			SECTION="$$(basename $${MANPAGE} | awk -F. '{ print $$3 }')"; \
			rm -f $(DESTDIR)/usr/share/man/$${LANGUAGE}/man$${SECTION}/$$(basename $${MANPAGE} .$${LANGUAGE}.$${SECTION}).$${SECTION}; \
			rmdir --ignore-fail-on-non-empty $(DESTDIR)/usr/share/man/$${LANGUAGE}/man$${SECTION} > /dev/null 2>&1 || true; \
			rmdir --ignore-fail-on-non-empty $(DESTDIR)/usr/share/man/$${LANGUAGE} > /dev/null 2>&1 || true; \
			rmdir --ignore-fail-on-non-empty $(DESTDIR)/usr/share/man > /dev/null 2>&1 || true; \
			rmdir --ignore-fail-on-non-empty $(DESTDIR)/usr/share > /dev/null 2>&1 || true; \
			rmdir --ignore-fail-on-non-empty $(DESTDIR)/usr > /dev/null 2>&1 || true; \
			rmdir --ignore-fail-on-non-empty $(DESTDIR) > /dev/null 2>&1 || true; \
		done; \
	done

clean:

distclean: clean

reinstall: uninstall install
