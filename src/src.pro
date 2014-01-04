TEMPLATE = app
TARGET = harbour-simpletorch
CONFIG += sailfishapp

SOURCES += harbour-simpletorch.cpp

CONFIG(release, debug|release) {
    DEFINES += QT_NO_DEBUG_OUTPUT
}
