import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/data/device_helper.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';

abstract class FeedVentilationFormBlocEvent extends Equatable {}

class FeedVentilationFormBlocEventLoadVentilations
    extends FeedVentilationFormBlocEvent {
  FeedVentilationFormBlocEventLoadVentilations();

  @override
  List<Object> get props => [];
}

class FeedVentilationFormBlocEventCreate extends FeedVentilationFormBlocEvent {
  FeedVentilationFormBlocEventCreate();

  @override
  List<Object> get props => [];
}

class FeedVentilationFormBlocBlowerDayChangedEvent
    extends FeedVentilationFormBlocEvent {
  final int blowerDay;

  FeedVentilationFormBlocBlowerDayChangedEvent(this.blowerDay);

  @override
  List<Object> get props => [blowerDay];
}

class FeedVentilationFormBlocBlowerNightChangedEvent
    extends FeedVentilationFormBlocEvent {
  final int blowerNight;

  FeedVentilationFormBlocBlowerNightChangedEvent(this.blowerNight);

  @override
  List<Object> get props => [blowerNight];
}

abstract class FeedVentilationFormBlocState extends Equatable {}

class FeedVentilationFormBlocStateIdle extends FeedVentilationFormBlocState {
  @override
  List<Object> get props => [];
}

class FeedVentilationFormBlocStateVentilationLoaded
    extends FeedVentilationFormBlocState {
  final int blowerDay;
  final int blowerNight;

  FeedVentilationFormBlocStateVentilationLoaded(
      this.blowerDay, this.blowerNight);

  @override
  List<Object> get props => [blowerDay, blowerNight];
}

class FeedVentilationFormBlocStateDone extends FeedVentilationFormBlocState {
  @override
  List<Object> get props => [];
}

class FeedVentilationFormBloc
    extends Bloc<FeedVentilationFormBlocEvent, FeedVentilationFormBlocState> {
  final MainNavigateToFeedVentilationFormEvent _args;

  Device _device;
  Param _blowerDay;
  Param _blowerNight;

  @override
  FeedVentilationFormBlocState get initialState =>
      FeedVentilationFormBlocStateIdle();

  FeedVentilationFormBloc(this._args) {
    add(FeedVentilationFormBlocEventLoadVentilations());
  }

  @override
  Stream<FeedVentilationFormBlocState> mapEventToState(
      FeedVentilationFormBlocEvent event) async* {
    if (event is FeedVentilationFormBlocEventLoadVentilations) {
      final db = RelDB.get();
      _device = await db.devicesDAO.getDevice(_args.box.device);
      _blowerDay = await db.devicesDAO
          .getParam(_device.id, "BOX_${_args.box.deviceBox}_BLOWER_DAY");
      _blowerNight = await db.devicesDAO
          .getParam(_device.id, "BOX_${_args.box.deviceBox}_BLOWER_NIGHT");
      yield FeedVentilationFormBlocStateVentilationLoaded(
          _blowerDay.ivalue, _blowerNight.ivalue);
    } else if (event is FeedVentilationFormBlocBlowerDayChangedEvent) {
      await DeviceHelper.updateIntParam(_device, _blowerDay, (event.blowerDay).toInt());
    } else if (event is FeedVentilationFormBlocBlowerNightChangedEvent) {
      await DeviceHelper.updateIntParam(_device, _blowerNight, (event.blowerNight).toInt());
    } else if (event is FeedVentilationFormBlocEventCreate) {
      final db = RelDB.get();
      await db.feedsDAO.addFeedEntry(FeedEntriesCompanion.insert(
        type: 'FE_VENTILATION',
        feed: _args.box.feed,
        date: DateTime.now(),
        params: JsonEncoder().convert({'test': 'pouet', 'toto': 'tutu'}),
      ));
      yield FeedVentilationFormBlocStateDone();
    }
  }
}