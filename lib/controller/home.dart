import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kuncie_test/model/music.dart';
import 'package:kuncie_test/networking/http_service.dart';

class HomeController extends GetxController {
  // for search query
  var query = 'budi doremi';

  // indicator loading when perform http request for populate songs
  var isMusicLoading = false.obs;

  // list of songs
  var songs = <MusicItem>[].obs;

  // selected songs -> used when perform search as temporary song
  var selectedSong = MusicItem().obs;

  // indicator error when perform http request for populate songs
  var isMusicError = false.obs;

  // music player state
  var musicState = PlayerState.STOPPED.obs;

  // position of selected song
  var position = Duration().obs;

  // length in second of selected song
  var musicLength = Duration().obs;

  // flag to perform autoPlay next song
  var autoPlay = false.obs;

  final searchFocus = FocusNode();
  final player = AudioPlayer();
  Timer? _debounce;

  StreamSubscription? _durationSubscription, _positionSubscription, _stateSubscription;

  // function that contain listener of music player
  _init() async {
    // music state change listener
    _stateSubscription = player.onPlayerStateChanged.listen((event) {
      musicState(event);
    });

    // song length listener
    _durationSubscription = player.onDurationChanged.listen((event) {
      musicLength(event);
    });

    // song position listener
    _positionSubscription = player.onAudioPositionChanged.listen((event) async {
      position(event);

      if (position.value.inSeconds == musicLength.value.inSeconds) {
        if (autoPlay.value) {
          playNext();
        } else {
          await player.stop();

          _resetSongs();
        }
      }
    });
  }

  _resetSongs() {
    for (var value in songs.where((element) => element.selected ?? false)) {
      final index = songs.indexOf(value);
      value.selected = false;
      songs[index] = value;
    }
  }

  // function to handle drag event in slider to change position (seconds) of selected songs
  seekToSec(int sec) => player.seek(Duration(seconds: sec));

  // function to handle onclick on list of songs -> play the selected song after click event
  onClick(MusicItem item) async {
    final state = await player.play(item.previewUrl ?? '');

    if (state != 1) return;

    _resetSongs();

    final index = songs.indexOf(item);
    item.selected = !(item.selected ?? false);
    songs[index] = item;

    selectedSong(item);
  }

  // function to handle pause and resume of selected song
  playback(bool isResume) async {
    if (isResume) player.resume();
    else player.pause();
  }

  // function to perform http request that populate songs
  getSongs() async {
    isMusicLoading(true);
    final data = await HttpService().getSongs(query);
    isMusicLoading(false);

    isMusicError(data == null);

    if (data == null) return;

    songs.assignAll(data.results ?? []);
  }

  // function to handle onsearch in input text
  onSearchChanged(String value) async {
    if (value == query) return;

    query = value;

    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () => getSongs());
  }

  // play next song
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

  // play previous song
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

  // stop music
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