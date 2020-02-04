import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/pages/feed_entries/feed_light/card/bloc/feed_light_card_bloc.dart';

class FeedLightCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedLightCardBloc, FeedLightCardBlocState>(
        bloc: Provider.of<FeedLightCardBloc>(context),
        builder: (context, state) => Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: SvgPicture.asset('assets/feed_card/icon_light.svg'),
                      title: const Text('Feed Light', style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
              ));
  }
}
