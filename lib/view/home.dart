import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuncie_test/controller/home.dart';
import 'package:kuncie_test/model/music.dart';
import 'package:kuncie_test/view/base_view.dart';
import '../utils/theme/theme_color.dart';
import '../utils/theme/theme_text_style.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final _homeCt = Get.put(HomeController());

  Widget get _appbar {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: Color(0xfffafafa), boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 4),
            blurRadius: 10,
            spreadRadius: 0)
      ]),
      height: 56,
      alignment: Alignment.center,
      child: SizedBox(
        height: 38,
        child: TextField(
          focusNode: _homeCt.searchFocus,
          textInputAction: TextInputAction.search,
          onEditingComplete: () => FocusScope.of(Get.context!).requestFocus(FocusNode()),
          keyboardType: TextInputType.text,
          onChanged: _homeCt.onSearchChanged,
          style: ThemeTextStyle.interRegular.copyWith(fontSize: 14),
          decoration: InputDecoration(
            isDense: true,
            hintText: 'budi doremi',
            hintStyle: ThemeTextStyle.interRegular
                .copyWith(color: ThemeColor.gray4, fontSize: 14),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black45),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black45),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _songItem(MusicItem item) {
    final isPlaying = (item.selected ?? false) && _homeCt.musicState.value == PlayerState.PLAYING;
    final isPaused = (item.selected ?? false) && _homeCt.musicState.value == PlayerState.PAUSED;

    return InkWell(
      onTap: () => _homeCt.onClick(item),
      child: Container(
        decoration: BoxDecoration(
            color:
                isPlaying ? Colors.black26 : Colors.transparent),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(
          children: [
            Image.network(
              item.artworkUrl60 ?? '',
              width: 60,
              height: 60,
              fit: BoxFit.fill,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.trackName ?? '',
                    style: ThemeTextStyle.interSemiBold,
                  ),
                  Text(
                    item.artistName ?? '',
                    style: ThemeTextStyle.interRegular.copyWith(fontSize: 14),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    item.collectionName ?? '',
                    style: ThemeTextStyle.interRegular.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
            if (isPlaying || isPaused) ...[
              SizedBox(
                width: 10,
              ),
              Text(
                isPlaying ? 'Playing' : 'Paused',
                style: ThemeTextStyle.interSemiBold
                    .copyWith(color: Colors.black45),
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget get _songs {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemBuilder: (_, index) => _songItem(_homeCt.songs[index]),
      separatorBuilder: (_, __) => Divider(
        height: 1,
        color: Colors.black45,
      ),
      itemCount: _homeCt.songs.length,
    );
  }

  List<Widget> get _musicPlayer {
    if (_homeCt.musicState.value == PlayerState.PAUSED || _homeCt.musicState.value == PlayerState.PLAYING) {
      return [
        Container(
          width: Get.width,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: Offset(0, -4),
                blurRadius: 10,
                spreadRadius: 0)
          ]),
          child: Column(
            children: [
              Text('${_homeCt.selectedSong.value.artistName} - ${_homeCt.selectedSong.value.trackName}', style: ThemeTextStyle.interRegular.copyWith(fontSize: 15),),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Switch(value: _homeCt.autoPlay.value, onChanged: (value) => _homeCt.autoPlay(value)),
                        Text('Auto Play', style: ThemeTextStyle.interRegular.copyWith(fontSize: 12),),
                      ],
                    ),
                    SizedBox(width: 20,),
                    GestureDetector(
                      onTap: () => _homeCt.playPrevious(),
                      child: Icon(
                        Icons.skip_previous,
                        size: 36,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        _homeCt.playback(_homeCt.musicState.value == PlayerState.PAUSED);
                      },
                      child: Icon(
                        _homeCt.musicState.value == PlayerState.PLAYING ? Icons.pause : Icons.play_arrow,
                        size: 36,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () => _homeCt.stop(),
                      child: Icon(
                        Icons.stop,
                        size: 36,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () => _homeCt.playNext(),
                      child: Icon(
                        Icons.skip_next,
                        size: 36,
                      ),
                    ),
                  ],
                ),
              ),
              _slider
            ],
          ),
        )
      ];
    }

    return [Container()];
  }

  Widget get _slider {
    return Container(
      width: 300.0,
      child: Slider.adaptive(
          activeColor: Colors.blue[800],
          inactiveColor: Colors.grey[350],
          value: _homeCt.position.value.inSeconds.toDouble(),
          max: _homeCt.musicLength.value.inSeconds.toDouble(),
          onChanged: (value) {
            _homeCt.seekToSec(value.toInt());
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      resizeBottomInset: false,
      child: Column(
        children: [
          _appbar,
          Expanded(
            child: Obx(
              () => Column(
                children: [
                  if (!_homeCt.isMusicLoading.value &&
                      !_homeCt.isMusicError.value) ...[
                    Expanded(
                      child: _homeCt.songs.isEmpty ?
                      Text('Hasil tidak ditemukan!', style: ThemeTextStyle.interRegular.copyWith(color: Colors.black38, fontSize: 14),) :
                      _songs,
                    ),
                    ..._musicPlayer
                  ],
                  if (_homeCt.isMusicLoading.value) ...[
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(),
                    ).marginOnly(top: Get.height * 0.4)
                  ],
                  if (_homeCt.isMusicError.value) ...[
                    Text(
                      'Network error, click here to reload!',
                      style: ThemeTextStyle.interRegular
                          .copyWith(fontSize: 14, color: Colors.black38),
                    ).marginOnly(top: Get.height * 0.4)
                  ]
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
