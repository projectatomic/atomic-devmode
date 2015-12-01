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
