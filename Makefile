
OBJDIR:=obj
GNATTEST_HARNESS_DIR=$(OBJDIR)/gnattest/harness
GPRFLAGS=-XALOG_VERSION=""

all: build check

build: $(OBJDIR)/mozzonid

check: build unit acceptance

unit: prepare-test-harness
	$(GNATTEST_HARNESS_DIR)/test_runner --exit-status=on

acceptance: build
	python -m unittest discover -s acceptance

clean:
	git clean -xf

prepare-test-harness:
	if [ ! -d $(GNATTEST_HARNESS_DIR) ]; then \
		$(MAKE) regenerate-test-harness; \
	fi;
	(cd $(GNATTEST_HARNESS_DIR) && gprbuild -Ptest_driver.gpr $(GPRFLAGS) )

regenerate-test-harness:
	gnat test -dd -Pmozzonid.gpr $(GPRFLAGS)

##############################

$(OBJDIR)/mozzonid:
	gprbuild -Pmozzoni.gpr $(GPRFLAGS)


.PHONY: acceptance all build check clean unit \
	prepare-test-harness regenerate-test-harness
