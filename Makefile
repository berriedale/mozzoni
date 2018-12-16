
OBJDIR:=obj
GNATTEST_HARNESS_DIR=$(OBJDIR)/gnattest/harness

all: build check

build: $(OBJDIR)/mozzonid

check: build prepare-test-harness
	$(GNATTEST_HARNESS_DIR)/test_runner --exit-status=on
	python -m unittest discover -s acceptance

clean:
	git clean -xf

prepare-test-harness:
	if [ ! -d $(GNATTEST_HARNESS_DIR) ]; then \
		$(MAKE) regenerate-test-harness; \
	fi;
	(cd $(GNATTEST_HARNESS_DIR) && gprbuild -Ptest_driver.gpr)

regenerate-test-harness:
	gnat test -dd -Pmozzoni.gpr

##############################

$(OBJDIR)/mozzonid:
	gprbuild


.PHONY: all build check clean \
	prepare-test-harness regenerate-test-harness
