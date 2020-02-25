/*
 * Copyright (C) 2018  SuperGreenLab <towelie@supergreenlab.com>
 * Author: Constantin Clauzel <constantin.clauzel@gmail.com>
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
 */

import 'package:flutter/material.dart';

class FeedCardObservations extends StatelessWidget {
  final String message;

  const FeedCardObservations(this.message);

  @override
  Widget build(BuildContext context) {
    return Padding(
                    padding: const EdgeInsets.only(
                        top: 16.0, left: 8.0, right: 8.0, bottom: 16.0),
                    child: Text(message,
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                  );
  }

}