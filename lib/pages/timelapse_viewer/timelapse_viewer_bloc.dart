import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class TimelapseViewerBlocEvent extends Equatable {}

class TimelapseViewerBlocEventInit extends TimelapseViewerBlocEvent {
  @override
  List<Object> get props => [];
}

abstract class TimelapseViewerBlocState extends Equatable {}

class TimelapseViewerBlocStateInit extends TimelapseViewerBlocState {
  @override
  List<Object> get props => [];
}

class TimelapseViewerBlocStateLoading extends TimelapseViewerBlocState {
  @override
  List<Object> get props => [];
}

class TimelapseViewerBlocStateLoaded extends TimelapseViewerBlocState {
  final Box box;
  final List<Timelapse> timelapses;
  final List<Uint8List> images;

  TimelapseViewerBlocStateLoaded(this.box, this.timelapses, this.images);

  @override
  List<Object> get props => [box, timelapses, images];
}

class TimelapseViewerBloc
    extends Bloc<TimelapseViewerBlocEvent, TimelapseViewerBlocState> {
  final MainNavigateToTimelapseViewer _args;

  TimelapseViewerBloc(this._args) {
    add(TimelapseViewerBlocEventInit());
  }

  @override
  TimelapseViewerBlocState get initialState => TimelapseViewerBlocStateInit();

  @override
  Stream<TimelapseViewerBlocState> mapEventToState(
      TimelapseViewerBlocEvent event) async* {
    if (event is TimelapseViewerBlocEventInit) {
      yield TimelapseViewerBlocStateLoading();
      List<Timelapse> timelapses =
          await RelDB.get().boxesDAO.getTimelapses(_args.box.id);
      List<Uint8List> pictures = [];
      for (int i = 0; i < timelapses.length; ++i) {
        Response res = await post(
            'https://content.dropboxapi.com/2/files/download',
            headers: {
              'Authorization': 'Bearer ${timelapses[i].dropboxToken}',
              'Dropbox-API-Arg':
                  '{"path": "/${timelapses[i].uploadName}/latest.jpg"}',
            });
        pictures.add(res.bodyBytes);
      }
      yield TimelapseViewerBlocStateLoaded(_args.box, timelapses, pictures);
    }
  }
}