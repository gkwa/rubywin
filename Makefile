name=rubywin

MAKEFLAGS += --warn-undefined-variables

GIT = git
MAKENSIS = makensis
RM = rm -f
UNIX2DOS = unix2dos

include VERSION.mk
version=$(majorv).$(minorv).$(microv).$(qualifierv)
version_short=$(version)

ifeq ($(qualifierv),0)
	version_short=$(majorv).$(minorv).$(microv)
	ifeq ($(microv),0)
		version_short=$(majorv).$(minorv)
	endif
endif

PRINT_DIR =
ifneq ($(findstring $(MAKEFLAGS),w),w)
	PRINT_DIR = --no-print-directory
endif

MAKENSIS_SW  =
QUIET_MAKENSIS =
QUIET_GEN =
QUIET_UNIX2DOS =
ifneq ($(findstring $(MAKEFLAGS),s),s)
ifndef V
	QUIET_MAKENSIS = @echo '   ' MAKENSIS $@;
	QUIET_UNIX2DOS = @echo '   ' UNIX2DOS $@;
	QUIET_GEN      = @echo '   ' GEN $@;
	export V

	UNIX2DOS += --quiet
	MAKENSIS_SW += /V2
endif
endif

installer=$(name)_v$(version_short).exe

changelog=$(installer)-changelog.txt

PS_SW =
PS_SW += -inputformat none
PS_SW += -executionpolicy bypass
PS_SW += -noprofile
PS_SW += -noninteractive

test:
	powershell $(PS_SW) -file install.ps1


clean:
	$(RM) $(installer)
	$(RM) Uninstall.bat
	$(RM) $(changelog)

.PHONY: upload
.PHONY: changelog
.PHONY: test
.PHONY: debug
.PHONY: un
.PHONY: uninstall
.PHONY: si
.PHONY: silent_install
.PHONY: test2
.PHONY: clean
