# Shorewall6 Makefile to restart if config-files are newer than last restart
VARDIR=$(shell /sbin/shorewall6 show vardir)
CONFDIR=/etc/shorewall6
RESTOREFILE?=firewall
all: $(VARDIR)/${RESTOREFILE}

$(VARDIR)/${RESTOREFILE}: $(CONFDIR)/*
	@/sbin/shorewall6 -q save >/dev/null; \
	if \
	    /sbin/shorewall6 -q restart >/dev/null 2>&1; \
	then \
	    /sbin/shorewall6 -q save >/dev/null; \
	else \
	    /sbin/shorewall6 -q restart 2>&1 | tail >&2; \
	fi

clean:
	@rm -f $(CONFDIR)/*~ $(CONFDIR)/.*~
.PHONY: clean

# EOF
