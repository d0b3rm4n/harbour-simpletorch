# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed

CONFIG += sailfishapp

png-files.path = /usr/share/harbour-simpletorch/data
png-files.files = data/*.png

INSTALLS = png-files

OTHER_FILES += qml/harbour-simpletorch.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-simpletorch.spec \
    harbour-simpletorch.desktop \
    qml/pages/FirstPage.qml \
    data/torch-001.png \
    qml/pages/SimpleTorchScreenBlank.qml


TEMPLATE = subdirs
SUBDIRS = src/dbus src
