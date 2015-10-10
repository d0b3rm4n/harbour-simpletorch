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

icon108.path  = /usr/share/icons/hicolor/108x108/apps
icon108.files = data/108x108/harbour-simpletorch.png
icon128.path  = /usr/share/icons/hicolor/128x128/apps
icon128.files = data/128x128/harbour-simpletorch.png
icon256.path  = /usr/share/icons/hicolor/256x256/apps
icon256.files = data/256x256/harbour-simpletorch.png

INSTALLS = png-files icon108 icon128 icon256

OTHER_FILES += rpm/harbour-simpletorch.spec \
               qml/*.qml \
               qml/cover/*.qml \
               qml/pages/*.qml
