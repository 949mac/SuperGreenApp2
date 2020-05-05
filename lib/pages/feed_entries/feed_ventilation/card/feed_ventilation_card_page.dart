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
import 'package:super_green_app/pages/feed_entries/feed_ventilation/card/feed_ventilation_state.dart';
import 'package:super_green_app/pages/feeds/feed/bloc/feed_bloc_entry_state.dart';
import 'package:super_green_app/widgets/feed_card/feed_card.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_date.dart';
import 'package:super_green_app/widgets/feed_card/feed_card_title.dart';
import 'package:super_green_app/widgets/fullscreen_loading.dart';

class FeedVentilationCardPage extends StatelessWidget {
  final Animation animation;
  final FeedBlocEntryState state;

  const FeedVentilationCardPage(this.animation, this.state, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state is FeedBlocEntryStateLoaded) {
      return _renderLoaded(context, state);
    }
    return _renderLoading(context);
  }

  Widget _renderLoading(BuildContext context) {
    return FeedCard(
      animation: animation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FeedCardTitle(
              'assets/feed_card/icon_blower.svg', 'Ventilation change', state.synced),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FeedCardDate(state.date),
          ),
          Container(
            height: 90,
            alignment: Alignment.center,
            child: FullscreenLoading(),
          ),
        ],
      ),
    );
  }

  Widget _renderLoaded(BuildContext context, FeedBlocEntryStateLoaded state) {
    FeedVentilationState cardState = state.state;
    return FeedCard(
      animation: animation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FeedCardTitle('assets/feed_card/icon_blower.svg',
              'Ventilation change', state.synced),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FeedCardDate(state.date),
          ),
          Container(
            height: 120,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _renderValues([
                cardState.values.blowerDay,
                cardState.values.blowerNight
              ], [
                cardState.initialValues.blowerDay,
                cardState.initialValues.blowerNight
              ]),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _renderValues(
      List<dynamic> values, List<dynamic> initialValues) {
    int i = 0;
    return values
        .map<Map<String, int>>((v) {
          return {
            'i': i,
            'from': initialValues[i++],
            'to': v,
          };
        })
        .where((v) => v['from'] != v['to'])
        .map<Widget>((v) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('${v['i'] == 0 ? 'Day' : 'Night'}',
                        style: TextStyle(
                            fontSize: 45,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('${v['from']}%',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w300)),
                    Icon(Icons.arrow_forward, size: 18),
                    Text('${v['to']}%',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            color: Colors.green)),
                  ],
                ),
              ],
            ),
          );
        })
        .toList();
  }
}
