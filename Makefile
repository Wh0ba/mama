ARCHS = arm64
TARGET = ::7.0

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = mama
mama_FILES = $(wildcard *.m) $(wildcard *.swift) 
mama_FRAMEWORKS = UIKit CoreGraphics SpriteKit
mama_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/application.mk


package::
	packages/dab

after-install::
	install.exec "killall \"mama\"" || true
