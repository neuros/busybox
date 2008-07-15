#########################################################################################
# This makefile is for an external application/library in the Neuros source tree.
# Available options are:
#
# - install: use only this during normal builds. will just install pre-build binaries.
# - all: this will download the source, patch it and rebuild it to generate from 
#            scratch the pre-built binaries. You may need some special tools to re-build.
# - clean: if you do a build, this will restore the build back to clean but leave dists cache.
# - cleanall: if you do a rebuild, this will restore the pristine env as before you did it by removing dists cache
#
# App: busybox shell
# Version: 1.11.1
# Extra tools for build: wget dialog ncurses ncurses-dev
#########################################################################################

ifndef PRJROOT
    $(error You must first source the BSP environment: "source neuros-env")
endif

TVER=1.11.1
TDIR=_build/busybox-$(TVER)
TARCHIVE=busybox-$(TVER).tar.bz2
TURL=http://busybox.net/downloads/$(TARCHIVE)
DISTS=$(shell pwd)/dists

.PHONY: install clean

# Just run this during the normal neuros build procedure.
# It will install the pre-built binaries to the OSD rootfs.
# This will also install headers and libraries into the toolchain, so
# you can use them if you want.
#
install: all
	make -C $(TDIR) install

# This will rebuild everything, starting from downloading the source
# to building it and re-generating the stuff in the "binaries" dir.
# 
all: $(TDIR)/Makefile
	make -C $(TDIR)

$(TDIR)/Makefile: $(TDIR)/configure
	cp configs/defconfig-$(TVER) $(TDIR)/.config

$(TDIR)/configure: _build/$(TARCHIVE)
	tar -C _build -xvjf dists/$(TARCHIVE)

_build/$(TARCHIVE):
	mkdir -p _build
	mkdir -p dists
	@if test ! -f dists/$(TARCHIVE); then wget -N -P dists $(TURL); fi

cleanall: clean
	-rm -rfv dists

clean:
	-rm -rfv _build

