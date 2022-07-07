THEOS_DEVICE_IP = localhost
THEOS_DEVICE_PORT = 2222
ARCHS = arm64
TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = iOSRETargetApp

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = iOSRETargetApp

iOSRETargetApp_FILES = main.m CCAppDelegate.m CCRootViewController.mm
iOSRETargetApp_FRAMEWORKS = UIKit CoreGraphics
iOSRETargetApp_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/application.mk

after-install::
	install.exec "su mobile -c uicache"
