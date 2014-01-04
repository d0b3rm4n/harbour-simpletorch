TARGET = simpleTorchDbus

QT += dbus qml

QT -= gui

TEMPLATE = lib
CONFIG += qt plugin hide_symbols

DEFINES += QT_VERSION_5

target.path = /usr/share/harbour-simpletorch/lib
INSTALLS += target

qmldir.files += $$_PRO_FILE_PWD_/qmldir
qmldir.path +=  $$target.path/harbour/simpletorch/dbus
INSTALLS += qmldir

SOURCES += \
    plugin.cpp \
    declarativedbusadaptor.cpp \
    declarativedbusinterface.cpp

HEADERS += \
    declarativedbusadaptor.h \
    declarativedbusinterface.h
