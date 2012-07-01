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

#include "clipboard.h"

#include <QApplication>
#include <QClipboard>

namespace {
    QClipboard *g_qClipboard = NULL;
    Clipboard *g_instance = NULL;
}

Clipboard::Clipboard(QObject *parent) :
    QObject(parent)
{
    ::g_qClipboard = QApplication::clipboard();
    connect(::g_qClipboard, SIGNAL(dataChanged()), this, SIGNAL(textChanged()));
}

Clipboard::~Clipboard()
{
}

Clipboard *Clipboard::instance()
{
    if (!::g_instance) {
        ::g_instance = new Clipboard;
    }
    return ::g_instance;
}

void Clipboard::setText(const QString &text)
{
    ::g_qClipboard->setText(text);
}

QString Clipboard::text() const
{
    return ::g_qClipboard->text();
}
