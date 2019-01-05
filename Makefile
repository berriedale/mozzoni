
OBJDIR:=obj
GNATTEST_HARNESS_DIR=$(OBJDIR)/gnattest/harness
GPRFLAGS=-XALOG_VERSION=""

all: help

build: $(OBJDIR)/mozzonid ## Build the mozzoni daemon

check: build unit acceptance ## Run all available tests 

unit: prepare-test-harness ## Run the GNATtest-based unit tests.
	$(GNATTEST_HARNESS_DIR)/test_runner --exit-status=on

acceptance: build ## Run the Python-based acceptance tests (see acceptance/)
	python -m unittest discover -s acceptance

clean: ## Remove all temporary files not tracked by Git
	git clean -xf

prepare-test-harness: ## Compile the GNATtest test harness
	if [ ! -d $(GNATTEST_HARNESS_DIR) ]; then \
		$(MAKE) regenerate-test-harness; \
	fi;
	(cd $(GNATTEST_HARNESS_DIR) && gprbuild -Ptest_driver.gpr $(GPRFLAGS) )

regenerate-test-harness: ## Regenerate the GNATtest test harness from the sources
	gnat test -dd -Pmozzonid.gpr $(GPRFLAGS)

##############################

$(OBJDIR)/mozzonid:
	gprbuild -Pmozzoni.gpr $(GPRFLAGS)


# Cute hack thanks to:
# https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help: ## Display this help text
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


.PHONY: acceptance all build check clean help unit \
	prepare-test-harness regenerate-test-harness
