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

.pragma library
Qt.include("Serializer.js")

var appId = "75AC1335C15B5C763CE302528B2E65DDB42E4087";
var service = "http://api.microsofttranslator.com/V2/Ajax.svc/";

var API_GetLanguagesForTranslate = "GetLanguagesForTranslate";
var API_GetLanguagesForSpeak = "GetLanguagesForSpeak";
var API_GetLanguageNames = "GetLanguageNames";
var API_Detect = "Detect";
var API_Translate = "Translate";
var API_Speak = "Speak";
var POST = "POST";
var GET = "GET";
var STATUS_OK = 200;
var _privateIsRequestPending = false;

function getLanguagesForTranslate(callback) {
    doRequest(API_GetLanguagesForTranslate, callback, GET);
}

function getLanguageNames(codes, callback) {
    doRequest(API_GetLanguageNames, callback, GET, get({locale: "en", languageCodes: fromArray(codes)}));
}

function getLanguagesForSpeak(callback) {
    doRequest(API_GetLanguagesForSpeak, callback, GET);
}

function detect(text, callback) {
    doRequest(API_Detect, callback, GET, get({text: text}));
}

function translate(from, to, text, callback) {
    doRequest(API_Translate, callback, GET, get({from: from, to: to, text: text}));
}

function speak(language, text, callback) {
    doRequest(API_Speak, callback, GET, get({language: language, text: text}));
}

function doRequest(apiCall, callback, method, get) {
    var uri = service + apiCall + "?appId=" + appId + (get === undefined ? "" : get);
    //console.log(uri);
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == XMLHttpRequest.DONE) {
            //console.log(doc.status);
            if (doc.status == STATUS_OK) {
                //console.log(doc.responseText);
                callback(eval(doc.responseText));
            } else {
                console.log(doc.responseText);
            }
            _privateIsRequestPending = false;
        }
    }

    doc.open(method, uri);
    doc.send();
    _privateIsRequestPending = true;
}

function isRequestPending()
{
    return _privateIsRequestPending;
}
