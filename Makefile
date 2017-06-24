# Ensure emacs always runs from this makefile's PWD
EMACS_LIBS=-l core/core.el
EMACS=emacs --batch --eval '(setq user-emacs-directory default-directory)' $(EMACS_LIBS)
TEST_EMACS=$(EMACS) --eval '(setq noninteractive nil)' $(EMACS_LIBS)
TESTS=$(shell find test/ -type f -name 'test-*.el')
MODULES=$(shell find modules/ -maxdepth 2 -type d)

# Tasks
all: autoloads autoremove install update

install: init.el .local/autoloads.el
	@$(EMACS) -f doom/packages-install

update: init.el .local/autoloads.el
	@$(EMACS) -f doom/packages-update

autoremove: init.el .local/autoloads.el
	@$(EMACS) -f doom/packages-autoremove

autoloads: init.el
	@$(EMACS) -f doom/reload-autoloads

recompile: init.el
	@$(EMACS) -f doom/recompile

compile: init.el clean
	@$(EMACS) -f doom/compile

core: init.el clean
	@$(EMACS) -f doom/compile -- init.el core

$(MODULES): init.el .local/autoloads.el
	@rm -fv $(shell find $@ -maxdepth 2 -type f -name '*.elc')
	@$(EMACS) -f doom/compile -- $@

clean:
	@$(EMACS) -f doom/clean-compiled

clean-cache:
	@$(EMACS) -f doom/clean-cache

clean-pcache:
	@$(EMACS) -l persistent-soft --eval '(delete-directory pcache-directory t)'

test: init.el .local/autoloads.el
	@$(EMACS) -f doom-run-tests

test\:core $(patsubst %, test\:%, $(MODULES)): init.el .local/autoloads.el
	@$(EMACS) -f doom-run-tests -- $(subst test:, , $@)

# run tests interactively
testi: init.el .local/autoloads.el
	@$(EMACSI) -f doom-run-tests -f ert

$(TESTS): init.el .local/autoloads.el
	@$(TEST_EMACS) $(patsubst %,-l %, $@) -l test/run.el

doctor:
	@./bin/doctor

#
init.el:
	@[ -e init.el ] || $(error No init.el file; create one or copy init.example.el)

.local/autoloads.el:
	@$(EMACS) -f doom-initialize-autoloads

%.elc: %.el
	@$(EMACS) -f doom/compile -- $<


.PHONY: all test $(TESTS) $(MODULES)
