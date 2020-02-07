import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:super_green_app/pages/feeds/feed/feed_bloc.dart';
import 'package:super_green_app/pages/feeds/feed/feed_page.dart';
import 'package:super_green_app/pages/feeds/sgl_feed/sgl_feed_bloc.dart';
import 'package:super_green_app/widgets/appbar.dart';

class SGLFeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SGLAppBar('Towelie'),
      body: BlocBuilder<SGLFeedBloc, SGLFeedBlocState>(
        bloc: Provider.of<SGLFeedBloc>(context),
        builder: (BuildContext context, SGLFeedBlocState state) {
          return _renderFeed(context, state);
        },
      ),
    );
  }

  Widget _renderFeed(BuildContext context, SGLFeedBlocState state) {
    return BlocProvider(
      create: (context) => FeedBloc(1),
      child: FeedPage(),
    );
  }
}