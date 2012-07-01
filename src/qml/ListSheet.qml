/*************************************************************************
 * This file is part of Translate Mee! for Nokia N9.
 * Copyright (C) 2012 Stanislav Ionascu <stanislav.ionascu@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 ***************************************************************************/

import QtQuick 1.0
import com.meego 1.0
import "../js/UI.js" as UI;

Sheet {
    property alias selectedItem: langListView.currentItem;
    property alias selectedIndex: langListView.currentIndex;
    property alias model: langListView.model;

    property int _privIndexOnOpen: -1;

    id: sheet;

    acceptButtonText: qsTr("Select");
    rejectButtonText: qsTr("Cancel");

    content: Flickable {
        id: flickable;
        anchors.fill: parent;
        ListView {
            id: langListView;
            anchors.fill: parent;
            delegate: Item {
                property string name: model.name;
                property string code: model.code;

                BorderImage {
                    id: background;
                    source: mouseArea.pressed ? UI.LIST_ITEM_BACKGROUND : (selectedIndex == model.index ? UI.LIST_ITEM_ACTIVE_BACKGROUND : "");
                    anchors.fill: parent;
                }
                MouseArea {
                    id: mouseArea;
                    anchors.fill: parent;
                    onClicked: {
                        langListView.currentIndex = model.index;
                    }
                }

                width: parent.width;
                height: 80;
                Label {
                    id: titleLabel;
                    anchors.left: parent.left;
                    anchors.leftMargin: 20;
                    anchors.verticalCenter: parent.verticalCenter;
                    text: parent.name;
                    font.pixelSize: 36;
                }
            }
            onModelChanged: {
                selectedIndex = 0;
            }
        }
    }

    ScrollDecorator {
        flickableItem: flickable;
    }

    onStatusChanged: {
        if (status == DialogStatus.Open) {
            _privIndexOnOpen = selectedIndex;
        }
    }

    onRejected: {
        selectedIndex = _privIndexOnOpen;
    }
}
