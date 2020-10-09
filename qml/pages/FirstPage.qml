/***************************************************************************

    FirstPage.qml - Simpletorch, a very simple torch app
    Copyright 2013, 2014 Reto Zingg <g.d0b3rm4n@gmail.com>
    This file is based on the Sailfish SDK template

 ***************************************************************************/

/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.2
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0

Page {
    id: page
    property int morseCounter: 0
    property int morseUnit: 800
    property int morseShort: 1 * morseUnit
    property int morseLong: 3 * morseUnit
    property int morseGapDot: 1 * morseUnit
    property int morseGapLetter: 3 * morseUnit
    property int morseGapWord: 7 * morseUnit
    property int startInterval: 50
    property bool morseSOS: false
    property color torchColor: "white"

    readonly property var torch_color_palette: [
        // real world light colors, mostly from http://planetpixelemporium.com/tutorialpages/light.html
        // sorted by lightness, https://www.hashbangcode.com/article/color-sorting-php
        '#ffffff',  // white aka direct sunlight
        '#fffffb',  // high noon sun
        '#f4fffa',  // standard fluorescent

        '#f2fcff',  // metal halide
        '#fff1e0',  // halogen
        '#d8f7ff',  // mercury vapor

        '#ffd1b2',  // sodium vapor
        '#fffaf4',  // carbon arc
        '#ffd6aa',  // tungsten 100w

        '#ffc58f',  // tungsten 40w
        '#fd5e53',  // sunset orange, https://www.colorhexa.com/fd5e53
        '#ffb74c',  // high pressure sodium

        '#ff9329',  // candle
        '#F31431',  // red alert, https://www.colourlovers.com/color/F31431/Red_Alert
        '#a700ff',  // black light fluorescent
    ]

    Timer {
        id: torchTimer
        interval: startInterval
        running: Qt.application.active
        onTriggered: toggleRectange()
    }

    function toggleRectange() {
        if (morseSOS) {
            morseCounter++;
//            console.debug("morseCounter:" + morseCounter);
            if (torchRectangle.color != "#000000") {
                torchRectangle.color = "black";
            } else if (torchRectangle.color == "#000000"){
                torchRectangle.color = "white"
            }
            switch(morseCounter)
            {
            case 1:
//                console.debug("01 - black - morseGapLetter");
                torchTimer.interval = morseGapLetter
                break;
            case 2:
            case 4:
            case 6:
            case 14:
            case 16:
//                console.debug(morseCounter + " - white - morseShort");
                torchTimer.interval = morseShort;
                torchBusyIndicator.running = false;
                torchAboutToStartText.visible = false;
                break;
            case 8:
            case 10:
            case 12:
//                console.debug(morseCounter +  " - white - morseLong");
                torchTimer.interval = morseLong;
                break;
            case 3:
            case 5:
            case 7:
            case 9:
            case 11:
            case 13:
            case 15:
            case 17:
                // case 7 and 13 (between: S and O; O and S)
                // In SOS no morseGapLetter is used in between letters
                // since it's treaded as one character aka prosign
                // http://www.qsl.net/w8rit/prosigns.htm
//                console.debug(morseCounter + " - black - morseGapDot");
                torchTimer.interval = morseGapDot;
                break;
            case 18:
//                console.debug("18 - white - morseShort");
                torchTimer.interval = morseShort;
                morseCounter = 0;
                break;
            default:
                // do nothing
            }
            torchTimer.start();
        } else {
//            console.debug("Timer is running in vain...")
            torchTimer.stop();
        }
    }

    function toggleTimer(){
        if (torchTimer.running) {
            morseSOS = false;
            torchBusyIndicator.running = false;
            torchAboutToStartText.visible = false;
            torchTimer.stop();
        } else {
            torchTimer.interval = startInterval;
            morseCounter = 0;
            morseSOS = true;
            torchBusyIndicator.running = true;
            torchAboutToStartText.visible = true;
            torchTimer.start();
        }
        torchRectangle.color = torchColor
    }

    function _dbInit(db)
    {
        try {
            db.transaction(function (tx) {
                tx.executeSql('CREATE TABLE IF NOT EXISTS settings (key text, value text, PRIMARY KEY(key))')
            })
            db.changeVersion("", "1.0");
        } catch (err) {
            console.log("Error creating table in database: " + err)
        };
    }

    function _dbGetHandle()
    {
        try {
           var db = LocalStorage.openDatabaseSync("SimpleTorch", "1.0", "App settings", 32, _dbInit)
        } catch (err) {
            console.log("Error opening database: " + err)
        }
        return db
    }

    function applyColor() {
        var db = _dbGetHandle();
        return db.readTransaction(function(tx) {
            var results = tx.executeSql('SELECT value FROM settings WHERE key = "color"')

            if(results.rows.length === 0) {
                torchColor = '#ffffff'
                return
            }
            torchColor = results.rows.item(0).value
        })
    }

    function saveColor() {
        var db = _dbGetHandle();
        db.transaction(function(tx) {
            try {
                var result = tx.executeSql('UPDATE settings SET value = ? WHERE key = "color"', [torchColor])
                if (result.rowsAffected === 0) {
                    tx.executeSql('INSERT INTO settings VALUES (?, ?)', ["color", torchColor])
                }
            } catch (e) {
                console.error(e)
            }
        })
    }

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Change color")
                onClicked: {
                    var dialog = pageStack.push("Sailfish.Silica.ColorPickerDialog")
                    dialog.colors = torch_color_palette
                    dialog.accepted.connect(function() {
                        torchColor = dialog.color
                        torchRectangle.color = torchColor
                        saveColor()
                    })
                }
            }

            MenuItem {
                 text: qsTr("Toggle morseing SOS")
                 onClicked: toggleTimer()
             }
        }

        Rectangle{
            id: torchRectangle
            anchors.fill: parent
            color: torchColor

            BusyIndicator {
                id: torchBusyIndicator
                anchors.centerIn: parent
                size: BusyIndicatorSize.Large
                running: false
            }
            Label {
                id: torchAboutToStartText
                visible: false
                anchors.bottom: torchBusyIndicator.top
                anchors.bottomMargin: Theme.paddingLarge
                anchors.left: parent.left
                anchors.right: parent.right
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                color: Theme.highlightColor
                font.family: Theme.fontFamilyHeading
                font.pixelSize: Theme.fontSizeExtraLarge
                text: "SOS blinking starts\nin " + morseGapLetter/1000  + "s"
            }
        }
        SimpleTorchScreenBlank{
            activated: Qt.application.active
        }
    }

    Component.onCompleted: {
        applyColor()
    }
}
