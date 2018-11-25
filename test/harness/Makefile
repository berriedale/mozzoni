# Check if we are running on Windows
ifeq ($(OS),Windows_NT)
	EXE_EXT=.exe
else
	EXE_EXT=
endif

# Executables
GPRBUILD=gprbuild
GPRCLEAN=gprclean
GNATCOV=gnatcov

# Number of processes used to build
# (default 0 is using maximum available cores)
NUMPROC=0

# Switches for gprbuild
# To be defined if there is a specific target and/or runtime, etc
BUILDERFLAGS=

# Project-specific switches
# To be defined to customize the build
GPRFLAGS=

# List of projects to build
PRJS = \
	Mozzoni.Command_Loader.Test_Data.Tests \
	Mozzoni.Commands.Keys.Test_Data.Tests \
	Mozzoni.Commands.Test_Data.Tests \
	Mozzoni.Dispatch.Test_Data.Tests \
	Mozzoni.Parser.Test_Data.Tests \
	Mozzoni.Test_Data.Tests

CKPTS = $(patsubst %,%-gnatcov-cov,$(PRJS))
GNATCOV_LEVEL=stmt+decision
GNATCOV_OUTPUT_FMT=dhtml

.PHONY: all

all: $(patsubst %,%-build,$(PRJS))

%-build: %/test_driver.gpr
	$(GPRBUILD) $(BUILDERFLAGS) -P$< $(GPRFLAGS) -gargs -j$(NUMPROC)

%-build-cov: %/test_driver.gpr
	$(GPRBUILD) $(BUILDERFLAGS) -P$< $(GPRFLAGS) -gargs -j$(NUMPROC) -cargs -g -fdump-scos -fpreserve-control-flow

%-gnatcov-run: %-build-cov
	$(GNATCOV) run --level=$(GNATCOV_LEVEL) -P$*/test_driver.gpr  $*/*-test_runner$(EXE_EXT) -o $*-gnattest.trace

%-gnatcov-cov: %-gnatcov-run
	$(GNATCOV) coverage --save-checkpoint=$*-gnattest.ckpt -a $(GNATCOV_OUTPUT_FMT) --level=$(GNATCOV_LEVEL) -P$*/test_driver.gpr $*-gnattest.trace

gnatcov-consolidate: $(CKPTS)
	$(GNATCOV) coverage -P../../../ops.gpr $(patsubst %,-C %-gnattest.ckpt,$(PRJS)) -a $(GNATCOV_OUTPUT_FMT) --level=$(GNATCOV_LEVEL)

coverage: gnatcov-consolidate

clean: $(patsubst %,%-clean,$(PRJS))

%-clean: %/test_driver.gpr
	$(GPRCLEAN) $(BUILDERFLAGS) -P$<
