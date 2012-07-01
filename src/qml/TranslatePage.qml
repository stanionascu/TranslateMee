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

import QtQuick 1.1
import com.meego 1.0
import QtMultimediaKit 1.1
import "../js/Translator.js" as Translator;
import "../js/Serializer.js" as Serializer;

Page {
    property bool waiting: true;
    property variant spokenLanguages: [];

    id: translatePage;
    orientationLock: PageOrientation.LockPortrait;

    tools: ToolBarLayout {
        id: translateTools;
        visible: true;
        ToolButtonRow {
            ToolButton {
                id: translateButton;
                text: qsTr("Translate");
                enabled: !waiting && !viewHeader.busy;
                onClicked: {
                    translate(inputText.text);
                }
            }
            ToolButton {
                id: speakButton;
                text: qsTr("Speak");
                enabled: false;
                onClicked: {
                    speakButton.enabled = false;
                    var to = toLangSheet.selectedItem.code;
                    Translator.speak(to, translationText.text, onSpeakStream);
                    waiting = true;
                }
            }
        }
    }

    ListModel {
        id: fromLanguagesModel;

        ListElement {
            code: "";
            name: "auto";
            value: "auto";
        }
    }

    ListModel {
        id: toLanguagesModel;
    }

    ViewHeader {
        id: viewHeader;
        title: qsTr("Translate Mee!");
        anchors.top: parent.top;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.bottomMargin: 16;
        height: 72;
        z: 2;
    }

    Flickable {
        visible: !waiting;
        anchors.topMargin: 16;
        anchors.top: viewHeader.bottom;
        anchors.bottom: parent.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        width: parent.width;
        contentHeight: translatorContent.height;
        contentWidth: parent.width;
        z: 1;

        Item {
            anchors.top: parent.top;
            anchors.topMargin: 8;

            id: translatorContent;
            width: parent.width;
            height: translationText.y + translationText.height;

            Item {
                height: 64;
                id: langToolbarItem;
                anchors.top: parent.top;
                anchors.left: parent.left;
                anchors.right: parent.right;

                Button {
                    id: fromLangButton;
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.left: parent.left;
                    text: "Auto-Detect";

                    width: 200;
                    height: 64;

                    onClicked: {
                        if (fromLangSheet.status == DialogStatus.Open)
                            return;

                        fromLangSheet.open();
                    }
                }

                Button {
                    id: switchLangsButton;
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.horizontalCenter: parent.horizontalCenter;
                    iconSource: "image://theme/icon-m-toolbar-refresh-white-selected";
                    width: 64;
                    height: 64;

                    enabled: false;

                    onClicked: {
                        var from = fromLangSheet.selectedIndex;
                        var to = toLangSheet.selectedIndex;
                        fromLangSheet.selectedIndex = to + 1;
                        toLangSheet.selectedIndex = from - 1;

                        fromLangButton.text = fromLangSheet.selectedItem.name;
                        toLangButton.text = toLangSheet.selectedItem.name;

                        translate(inputText.text);
                    }
                }

                Button {
                    id: toLangButton;
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.right: parent.right;
                    text: "Arabic";

                    width: 200;
                    height: 64;

                    onClicked: {
                        if (toLangSheet.status == DialogStatus.Open)
                            return;

                        toLangSheet.open();
                    }
                }
            }

            Label {
                id: fromLabel;
                anchors.topMargin: 16;
                anchors.top: langToolbarItem.bottom;
                anchors.left: parent.left;
                text: qsTr("From:");
            }

            TextArea {
                id: inputText;
                anchors.topMargin: 16;
                anchors.top: fromLabel.bottom;
                anchors.left: parent.left;
                anchors.right: parent.right;
                placeholderText: qsTr("Type or paste text here to translate...");

                onTextChanged: {
                    translationText.text = inputText.text + "...";
                }

                onActiveFocusChanged: {
                    if (!activeFocus) {
                        translationTimer.stop();
                        translationTimer.start();
                    } else {
                        translationTimer.stop();
                    }
                }
            }

            Label {
                id: toLabel;
                anchors.topMargin: 16;
                anchors.top: inputText.bottom;
                anchors.left: parent.left;
                text: qsTr("To:");
            }

            Label {
                id: translationText;
                anchors.topMargin: 16;
                anchors.top: toLabel.bottom;
                anchors.left: parent.left;
                anchors.leftMargin: 16;
                anchors.right: parent.right;
                height: paintedHeight;

                font.pixelSize: 30;
                font.weight: Font.Bold;

                Rectangle {
                    anchors.fill: parent;
                    anchors.topMargin: -12;
                    anchors.bottomMargin: -12;
                    anchors.rightMargin: -12;
                    anchors.leftMargin: -12;
                    color: "#F0F0F0";
                    opacity: 0.2;
                    visible: translationTextMouseArea.pressed;
                }

                MouseArea {
                    anchors.fill: parent;
                    id: translationTextMouseArea;
                    onPressAndHold: {
                        Clipboard.text = translationText.text;
                        informationDialog.titleText = qsTr("Clipboard");
                        informationDialog.message = qsTr("The translation was copied to clipboard.");
                        informationDialog.open();
                    }
                }
            }
        }
    }

    ListSheet {
        id: fromLangSheet;
        model: fromLanguagesModel;

        onAccepted: {
            fromLangButton.text = selectedItem.name;
            translate(inputText.text);
            if (selectedItem.code === "") {
                switchLangsButton.enabled = false;
            } else {
                switchLangsButton.enabled = true;
            }
        }
    }

    ListSheet {
        id: toLangSheet;
        model: toLanguagesModel;

        onAccepted: {
            toLangButton.text = selectedItem.name;
            translate(inputText.text);
        }
    }

    Item {
        z: 2;
        anchors.fill: parent;
        visible: waiting;
        BusyIndicator {
            platformStyle: BusyIndicatorStyle {
                size: "big";
            }
            running: true;
            anchors.verticalCenter: parent.verticalCenter;
            anchors.horizontalCenter: parent.horizontalCenter;
        }
    }

    Timer {
        id: translationTimer;
        interval: 500;
        repeat: false;
        triggeredOnStart: false;

        onTriggered: {
            translationText.text = inputText.text + "...";
            translate(inputText.text);
        }
    }

    Audio {
        id: streamPlayer;

        onError: {
            errorDialog.titleText = qsTr("Could not speak.");
            errorDialog.message = errorString;
            errorDialog.open();
        }
    }

    QueryDialog {
        id: errorDialog;
        acceptButtonText: qsTr("OK");
    }

    QueryDialog {
        id: informationDialog;
        acceptButtonText: qsTr("OK");
    }

    Component.onCompleted: {
        Translator.getLanguagesForTranslate(onLangListUpdated);
        fromLanguagesModel.setProperty(0, "name", qsTr("Auto-Detect"));
    }

    function onLangListUpdated(codes) {
        Translator.getLanguageNames(codes, onLangNamesUpdated);
        for (var i = 0; i < codes.length; i++) {
            fromLanguagesModel.insert(i + 1, {code: codes[i], name: ""});
            toLanguagesModel.insert(i, {code: codes[i], name: ""});

            if (codes[i] == "en") {
                toLangSheet.selectedIndex = i;
            }
        }
        fromLangSheet.selectedIndex = 0;
    }

    function onLangNamesUpdated(names) {
        for (var i = 0; i < names.length; i++) {
            fromLanguagesModel.setProperty(i + 1, "name", names[i]);
            toLanguagesModel.setProperty(i, "name", names[i]);

            if (toLangSheet.selectedIndex == i) {
                toLangButton.text = toLangSheet.selectedItem.name;
            }
            if (fromLangSheet.selectedIndex == i) {
                fromLangButton.text = fromLangSheet.selectedItem.name;
            }

        }
        Translator.getLanguagesForSpeak(onLangSpeakListUpdated)
    }

    function onTranslated(translation) {
        translationText.text = translation;
        viewHeader.busy = false;
    }

    function translate(text) {
        if (text.length === 0)
            return;

        if (!Translator.isRequestPending()) {
            viewHeader.busy = true;
            translationText.text = inputText.text + "...";
            var from = fromLangSheet.selectedItem.code;
            var to = toLangSheet.selectedItem.code;
            Translator.translate(from, to, text, onTranslated);
        } else {
            translationTimer.stop();
            translationTimer.start();
        }
    }

    function onSpeakStream(url) {
        url = decodeURIComponent(url);
        //console.log(url);
        streamPlayer.stop();
        streamPlayer.source = "";
        streamPlayer.source =  url;
        streamPlayer.play();
        waiting = false;
        speakButton.enabled = true;
    }

    function checkIfSpeachAvailable() {
        var to = toLangSheet.selectedItem.code;
        if (spokenLanguages.indexOf(to) >= 0) {
            speakButton.enabled = true;
        } else {
            speakButton.enabled = false;
        }
    }

    function onLangSpeakListUpdated(codes) {
        spokenLanguages = codes;
        checkIfSpeachAvailable();
        waiting = false;
    }
}
