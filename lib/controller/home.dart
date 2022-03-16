import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kuncie_test/model/music.dart';
import 'package:kuncie_test/networking/http_service.dart';

class HomeController extends GetxController {
  var query = 'budi doremi';
  var isMusicLoading = false.obs;
  var songs = <MusicItem>[].obs;
  var selectedSong = MusicItem().obs;
  var isMusicError = false.obs;

  var musicState = PlayerState.STOPPED.obs;
  var position = Duration().obs;
  var musicLength = Duration().obs;
  var autoPlay = false.obs;

  final searchFocus = FocusNode();
  Timer? _debounce;

  final player = AudioPlayer();

  StreamSubscription? _durationSubscription, _positionSubscription, _stateSubscription;

  Future _init() async {
    _stateSubscription = player.onPlayerStateChanged.listen((event) {
      musicState(event);
    });

    _durationSubscription = player.onDurationChanged.listen((event) {
      print('HomeController durationChange ${event.inSeconds}');
      musicLength(event);
    });

    _positionSubscription = player.onAudioPositionChanged.listen((event) async {
      print('HomeController positionChange ${event.inSeconds}');
      position(event);

      if (position.value.inSeconds == musicLength.value.inSeconds) {
        print('SONG IS STOPED');

        if (autoPlay.value) {
          print('AUTO PLAY');

          playNext();
        } else {
          await player.stop();

          _resetSongs();
        }
      }
    });
  }

  seekToSec(int sec) => player.seek(Duration(seconds: sec));

  _resetSongs() {
    for (var value in songs.where((element) => element.selected ?? false)) {
      final index = songs.indexOf(value);
      value.selected = false;
      songs[index] = value;
    }
  }

  onClick(MusicItem item) async {
    final state = await player.play(item.previewUrl ?? '');

    if (state != 1) return;

    _resetSongs();

    final index = songs.indexOf(item);
    item.selected = !(item.selected ?? false);
    songs[index] = item;

    selectedSong(item);
  }

  playback(bool isResume) async {
    if (isResume) player.resume();
    else player.pause();
  }

  getSongs() async {
    isMusicLoading(true);
    final data = await HttpService().getSongs(query);
    isMusicLoading(false);

    isMusicError(data == null);

    if (data == null) return;

    songs.assignAll(data.results ?? []);
  }

  onSearchChanged(String value) async {
    if (value == query) return;

    query = value;

    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () => getSongs());
  }

  playNext() async {
    if (!songs.any((element) => element.selected ?? false)) {
      onClick(songs.first);
      return;
    }

    final selectedIndex = songs.indexWhere((element) => element.selected ?? false);

    if (selectedIndex + 1 > songs.length - 1) return;

    print('PLAYING NEXT SONG');

    var selectedMusic = songs[selectedIndex];
    var nextMusic = songs[selectedIndex + 1];

    final state = await player.play(nextMusic.previewUrl ?? '');

    if (state != 1) return;

    selectedMusic.selected = false;
    nextMusic.selected = true;

    songs[selectedIndex] = selectedMusic;
    songs[selectedIndex + 1] = nextMusic;

    selectedSong(nextMusic);
  }

  playPrevious() async {
    final selectedIndex = songs.indexWhere((element) => element.selected ?? false);

    if (selectedIndex == 0) {
      Get.snackbar('Oops!', 'Tidak ada lagu sebelumnya!');
      return;
    }

    print('PLAYING PREVIOUS SONG');

    var selectedMusic = songs[selectedIndex];
    var previousMusic = songs[selectedIndex - 1];

    final state = await player.play(previousMusic.previewUrl ?? '');

    if (state != 1) return;

    selectedMusic.selected = false;
    previousMusic.selected = true;

    songs[selectedIndex] = selectedMusic;
    songs[selectedIndex - 1] = previousMusic;

    selectedSong(previousMusic);
  }

  stop() async {
    await player.stop();

    _resetSongs();
  }

  @override
  void onClose() {
    searchFocus.dispose();
    _debounce?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _stateSubscription?.cancel();

    super.onClose();
  }

  @override
  void onReady() {
    _init();

    getSongs();

    super.onReady();
  }
}