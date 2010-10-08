PKG=scap-workbench
WRK_PKG=scap_workbench
VERSION="0.0.1"

PY_LIB := $(shell python -c "from distutils.sysconfig import get_python_lib; print get_python_lib()")
PY_VER := python$(shell python -c "import sys; print sys.version[:3]")

PREFIX=$(DESTDIR)/usr
BINDIR=$(PREFIX)/bin
SBINDIR=$(PREFIX)/sbin
DATADIR=$(PREFIX)/share
MANDIR=$(DATADIR)/man
PKGDATADIR=$(DATADIR)/$(WRK_PKG)
PKGIMAGESDIR=$(PKGDATADIR)/images
LIBEXECDIR=$(PREFIX)/libexec
SYSCONFDIR=$(DESTDIR)/etc
PYTHON_LIB=$(DESTDIR)$(PY_LIB)
PYTHON_LIB_PKG=$(PYTHON_LIB)/$(WRK_PKG)

INSTALL=/usr/bin/install -c
MODE_DIR = -m 755
MODE_EXEC = -m 755
MODE_REG = -m 644


install:
	test -d $(BINDIR) || $(INSTALL) $(MODE_DIR) -d $(BINDIR)
	test -d $(SYSCONFDIR)/$(PKG) || $(INSTALL) $(MODE_DIR) -d $(SYSCONFDIR)/$(PKG)
	test -d $(DATADIR)/$(PKG) || $(INSTALL) $(MODE_DIR) -d $(DATADIR)/$(PKG)
	test -d $(PYTHON_LIB) || $(INSTALL) $(MODE_DIR) -d $(PYTHON_LIB)
	test -d $(PYTHON_LIB_PKG) || $(INSTALL) $(MODE_DIR) -d $(PYTHON_LIB_PKG)
	$(INSTALL) $(MODE_EXEC) src/bin/$(PKG) $(BINDIR)/$(PKG)
	$(INSTALL) $(MODE_REG) src/$(WRK_PKG)/*.py $(PYTHON_LIB_PKG)
	$(INSTALL) $(MODE_REG) src/etc/logger.conf $(SYSCONFDIR)/$(PKG)/logger.conf
	$(INSTALL) $(MODE_REG) src/glade/*.glade $(DATADIR)/$(PKG)

archive: clean
	@rm -rf $(PKG)-$(VERSION).tar.bz2
	@rm -rf /tmp/$(PKG)-$(VERSION)
	@mkdir /tmp/$(PKG)-$(VERSION)
	@cp -a COPYING README Makefile src /tmp/$(PKG)-$(VERSION)
	@dir=$$PWD; cd /tmp; tar --bzip2 -cSpf $$dir/$(PKG)-$(VERSION).tar.bz2 $(PKG)-$(VERSION)
	@rm -rf /tmp/$(PKG)-$(VERSION)
	@echo "The archive is in $(PKG)-$(VERSION).tar.bz2"

clean:
	@rm -rfv *.pyc
