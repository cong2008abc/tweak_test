THEOS_DEVICE_IP = localhost
THEOS_DEVICE_PORT = 2222

TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = iOSRETargetApp


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = iOSREHookerTweak

iOSREHookerTweak_FILES = Tweak.xm
iOSREHookerTweak_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
