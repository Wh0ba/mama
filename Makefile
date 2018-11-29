ARCHS = arm64

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = mama
mama_FILES = main.m AppDelegate.m ViewController.m myScene.m menuScene.m
mama_FRAMEWORKS = UIKit CoreGraphics SpriteKit
mama_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/application.mk


package::
	packages/dab

after-install::
	install.exec "killall \"mama\"" || true
