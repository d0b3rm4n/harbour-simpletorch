# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed

CONFIG += sailfishapp_qml

png-files.path = /usr/share/harbour-simpletorch/data
png-files.files = data/torch-001.png

INSTALLS = png-files

OTHER_FILES += data/torch-001.png \
               rpm/harbour-simpletorch.spec \
               qml/*.qml \
               qml/cover/*.qml \
               qml/pages/*.qml
