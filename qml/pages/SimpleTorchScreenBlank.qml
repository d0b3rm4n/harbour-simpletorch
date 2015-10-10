/***************************************************************************

    SimpleTorchScreenBlank.qml - Simpletorch, a very simple torch app
    Copyright 2014 Reto Zingg <g.d0b3rm4n@gmail.com>

 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the Free Software           *
 *   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,            *
 *   MA 02110-1301, USA.                                                   *
 *                                                                         *
 ***************************************************************************/

import QtQuick 2.2
import org.nemomobile.dbus 2.0

Timer {
    id: simpleTorchTimer

    property alias activated: simpleTorchTimer.running

    property DBusInterface _dbus: DBusInterface {
        id: simpleTorchDbus

        service: "com.nokia.mce"
        path: "/com/nokia/mce/request"
        iface: "com.nokia.mce.request"
        bus: DBus.SystemBus
    }

    onTriggered: simpleTorchDbus.call("req_display_blanking_pause", undefined)
    interval: 59847
    repeat: true
    triggeredOnStart: true

    onRunningChanged: {
        if (!activated) {
            simpleTorchDbus.call("req_display_cancel_blanking_pause", undefined)
        }
    }
}
