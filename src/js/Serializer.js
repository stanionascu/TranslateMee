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

function get(params) {
    var result = "";
    for (var prop in params) {
        result += "&" + prop + "=" + encodeURIComponent(params[prop]);
    }
    return result;
}

function fromArray(array) {
    var result = "[";
    for (var i = 0; i < array.length; i++) {
        result += "\"" + array[i] + "\"";
        if (i < array.length - 1) {
            result += ",";
        }
    }
    result += "]"
    return result;
}
