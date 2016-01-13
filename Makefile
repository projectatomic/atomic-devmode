# Copyright (C) 2015-2016 Red Hat, Inc.
#
# This file is part of atomic-devmode.
#
# atomic-devmode is free software: you can redistribute it
# and/or modify it under the terms of the GNU Lesser General
# Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your
# option) any later version.
#
# atomic-devmode is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
# PURPOSE.  See the GNU Lesser General Public License for
# more details.
#
# You should have received a copy of the GNU Lesser General
# Public License along with atomic-devmode. If not, see
# <http://www.gnu.org/licenses/>.

.PHONY: all
all:
	@echo "Nothing to make."

LIB = $(DESTDIR)/usr/lib/atomic-devmode
LIBEXEC = $(DESTDIR)/usr/libexec/atomic-devmode

.PHONY: install
install:
	install -d -m 755 $(LIB)
	install -m 644 lib/* $(LIB)
	install -d -m 755 $(LIBEXEC)
	install -m 755 libexec/* $(LIBEXEC)

.PHONY: archive
archive:
	@if ! git diff-index --quiet HEAD; then \
		echo "WARNING: not all changes have been committed."; \
	fi
	git archive --format=tar.gz --prefix=atomic-devmode/ HEAD > \
		atomic-devmode.tar.gz
