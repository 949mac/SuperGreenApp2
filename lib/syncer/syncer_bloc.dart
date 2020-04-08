import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moor/moor.dart';
import 'package:super_green_app/data/backend/feeds/feeds_api.dart';
import 'package:super_green_app/data/kv/app_db.dart';
import 'package:super_green_app/data/rel/rel_db.dart';

abstract class SyncerBlocEvent extends Equatable {}

class SyncerBlocEventInit extends SyncerBlocEvent {
  @override
  List<Object> get props => [];
}

abstract class SyncerBlocState extends Equatable {}

class SyncerBlocStateInit extends SyncerBlocState {
  @override
  List<Object> get props => [];
}

class SyncerBloc extends Bloc<SyncerBlocEvent, SyncerBlocState> {
  Timer _timerOut;
  bool _workingOut;

  Timer _timerIn;
  bool _workingIn;

  SyncerBloc() {
    add(SyncerBlocEventInit());
  }

  @override
  SyncerBlocState get initialState => SyncerBlocStateInit();

  @override
  Stream<SyncerBlocState> mapEventToState(SyncerBlocEvent event) async* {
    if (event is SyncerBlocEventInit) {
      _timerOut = Timer.periodic(Duration(seconds: 5), (_) async {
        if (_workingOut == true) return;
        _workingOut = true;
        if (!await _validJWT()) {
          _workingOut = false;
          return;
        }
        try {
          await _syncOut();
        } catch (e) {
          print(e);
        }
        _workingOut = false;
      });

      _timerIn = Timer.periodic(Duration(seconds: 5), (_) async {
        if (_workingIn == true) return;
        _workingIn = true;
        if (!await _validJWT()) {
          _workingIn = false;
          return;
        }
        try {
          await _syncIn();
        } catch (e) {
          print(e);
        }
        _workingIn = false;
      });
    }
  }

  Future _syncIn() async {
    await _syncInFeeds();
    await _syncInFeedEntries();
    await _syncInFeedMedias();
    await _syncInDevices();
    await _syncInBoxes();
    await _syncInPlants();
  }

  Future _syncInFeeds() async {
    List<FeedsCompanion> feeds = await FeedsAPI().unsyncedFeeds();
    for (int i = 0; i < feeds.length; ++i) {
      FeedsCompanion feedsCompanion = feeds[i];
      Feed exists = await RelDB.get()
          .feedsDAO
          .getFeedForServerID(feedsCompanion.serverID.value);
      if (exists != null) {
        await RelDB.get()
            .feedsDAO
            .updateFeed(feedsCompanion.copyWith(id: Value(exists.id)));
      } else {
        await RelDB.get().feedsDAO.addFeed(feedsCompanion);
      }
      await FeedsAPI().setSynced("feed", feedsCompanion.serverID.value);
    }
  }

  Future _syncInFeedEntries() async {
    List<FeedEntriesCompanion> feedEntries =
        await FeedsAPI().unsyncedFeedEntries();
    for (int i = 0; i < feedEntries.length; ++i) {
      FeedEntriesCompanion feedEntriesCompanion = feedEntries[i];
      FeedEntry exists = await RelDB.get()
          .feedsDAO
          .getFeedEntryForServerID(feedEntriesCompanion.serverID.value);
      if (exists != null) {
        await RelDB.get().feedsDAO.updateFeedEntry(
            feedEntriesCompanion.copyWith(id: Value(exists.id)));
      } else {
        await RelDB.get().feedsDAO.addFeedEntry(feedEntriesCompanion);
      }
      await FeedsAPI()
          .setSynced("feedEntry", feedEntriesCompanion.serverID.value);
    }
  }

  Future _syncInFeedMedias() async {
    List<FeedMediasCompanion> feedMedias =
        await FeedsAPI().unsyncedFeedMedias();
    for (int i = 0; i < feedMedias.length; ++i) {
      FeedMediasCompanion feedMediasCompanion = feedMedias[i];
      FeedMedia exists = await RelDB.get()
          .feedsDAO
          .getFeedMediaForServerID(feedMediasCompanion.serverID.value);
      if (exists != null) {
        await RelDB.get().feedsDAO.updateFeedMedia(
            feedMediasCompanion.copyWith(id: Value(exists.id)));
      } else {
        await RelDB.get().feedsDAO.addFeedMedia(feedMediasCompanion);
      }
      await FeedsAPI()
          .setSynced("feedMedia", feedMediasCompanion.serverID.value);
    }
  }

  Future _syncInDevices() async {
    List<DevicesCompanion> devices = await FeedsAPI().unsyncedDevices();
    for (int i = 0; i < devices.length; ++i) {
      DevicesCompanion devicesCompanion = devices[i];
      Device exists = await RelDB.get()
          .devicesDAO
          .getDeviceForServerID(devicesCompanion.serverID.value);
      if (exists != null) {
        await RelDB.get()
            .devicesDAO
            .updateDevice(devicesCompanion.copyWith(id: Value(exists.id)));
      } else {
        await RelDB.get().devicesDAO.addDevice(devicesCompanion);
      }
      await FeedsAPI().setSynced("device", devicesCompanion.serverID.value);
    }
  }

  Future _syncInBoxes() async {
    List<BoxesCompanion> boxes = await FeedsAPI().unsyncedBoxes();
    for (int i = 0; i < boxes.length; ++i) {
      BoxesCompanion boxesCompanion = boxes[i];
      Box exists = await RelDB.get()
          .plantsDAO
          .getBoxForServerID(boxesCompanion.serverID.value);
      if (exists != null) {
        await RelDB.get()
            .plantsDAO
            .updateBox(boxesCompanion.copyWith(id: Value(exists.id)));
      } else {
        await RelDB.get().plantsDAO.addBox(boxesCompanion);
      }
      await FeedsAPI().setSynced("box", boxesCompanion.serverID.value);
    }
  }

  Future _syncInPlants() async {
    List<PlantsCompanion> plants = await FeedsAPI().unsyncedPlants();
    for (int i = 0; i < plants.length; ++i) {
      PlantsCompanion plantsCompanion = plants[i];
      Plant exists = await RelDB.get()
          .plantsDAO
          .getPlantForServerID(plantsCompanion.serverID.value);
      if (exists != null) {
        await RelDB.get()
            .plantsDAO
            .updatePlant(plantsCompanion.copyWith(id: Value(exists.id)));
      } else {
        await RelDB.get().plantsDAO.addPlant(plantsCompanion);
      }
      await FeedsAPI().setSynced("plant", plantsCompanion.serverID.value);
    }
  }

  Future _syncOut() async {
    await _syncOutFeeds();
    await _syncOutFeedEntries();
    await _syncOutFeedMedias();
    await _syncOutDevices();
    await _syncOutBoxes();
    await _syncOutPlants();
  }

  Future<bool> _validJWT() async {
    if (AppDB().getAppData().jwt == null) return false;
    return true;
  }

  Future _syncOutFeeds() async {
    List<Feed> feeds = await RelDB.get().feedsDAO.getUnsyncedFeeds();
    for (int i = 0; i < feeds.length; ++i) {
      Feed feed = feeds[i];
      await FeedsAPI().syncFeed(feed);
    }
  }

  Future _syncOutFeedEntries() async {
    List<FeedEntry> feedEntries =
        await RelDB.get().feedsDAO.getUnsyncedFeedEntries();
    for (int i = 0; i < feedEntries.length; ++i) {
      FeedEntry feedEntry = feedEntries[i];
      await FeedsAPI().syncFeedEntry(feedEntry);
    }
  }

  Future _syncOutFeedMedias() async {
    List<FeedMedia> feedMedias =
        await RelDB.get().feedsDAO.getUnsyncedFeedMedias();
    for (int i = 0; i < feedMedias.length; ++i) {
      FeedMedia feedMedia = feedMedias[i];
      await FeedsAPI().syncFeedMedia(feedMedia);
    }
  }

  Future _syncOutDevices() async {
    List<Device> devices = await RelDB.get().devicesDAO.getUnsyncedDevices();
    for (int i = 0; i < devices.length; ++i) {
      Device device = devices[i];
      await FeedsAPI().syncDevice(device);
    }
  }

  Future _syncOutBoxes() async {
    List<Box> boxes = await RelDB.get().plantsDAO.getUnsyncedBoxes();
    for (int i = 0; i < boxes.length; ++i) {
      Box box = boxes[i];
      await FeedsAPI().syncBox(box);
    }
  }

  Future _syncOutPlants() async {
    List<Plant> plants = await RelDB.get().plantsDAO.getUnsyncedPlants();
    for (int i = 0; i < plants.length; ++i) {
      Plant plant = plants[i];
      await FeedsAPI().syncPlant(plant);
    }
  }

  @override
  Future<void> close() async {
    if (_timerOut != null) {
      _timerOut.cancel();
    }
    if (_timerIn != null) {
      _timerIn.cancel();
    }
    return super.close();
  }
}
