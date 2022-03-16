class Music {
  Music({
      this.resultCount, 
      this.results,});

  Music.fromJson(dynamic json) {
    resultCount = json['resultCount'];
    if (json['results'] != null) {
      results = [];
      json['results'].forEach((v) {
        results?.add(MusicItem.fromJson(v));
      });
    }
  }
  int? resultCount;
  List<MusicItem>? results;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['resultCount'] = resultCount;
    if (results != null) {
      map['results'] = results?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class MusicItem {
  MusicItem({
      this.wrapperType, 
      this.kind, 
      this.artistId, 
      this.collectionId, 
      this.trackId, 
      this.artistName, 
      this.collectionName, 
      this.trackName, 
      this.collectionCensoredName, 
      this.trackCensoredName, 
      this.collectionArtistId, 
      this.collectionArtistName, 
      this.artistViewUrl, 
      this.collectionViewUrl, 
      this.trackViewUrl, 
      this.previewUrl, 
      this.artworkUrl30, 
      this.artworkUrl60, 
      this.artworkUrl100, 
      this.collectionPrice, 
      this.trackPrice, 
      this.releaseDate, 
      this.collectionExplicitness, 
      this.trackExplicitness, 
      this.discCount, 
      this.discNumber, 
      this.trackCount, 
      this.trackNumber, 
      this.trackTimeMillis, 
      this.country, 
      this.currency, 
      this.primaryGenreName, 
      this.isStreamable});

  MusicItem.fromJson(dynamic json) {
    wrapperType = json['wrapperType'];
    kind = json['kind'];
    artistId = json['artistId'];
    collectionId = json['collectionId'];
    trackId = json['trackId'];
    artistName = json['artistName'];
    collectionName = json['collectionName'];
    trackName = json['trackName'];
    collectionCensoredName = json['collectionCensoredName'];
    trackCensoredName = json['trackCensoredName'];
    collectionArtistId = json['collectionArtistId'];
    collectionArtistName = json['collectionArtistName'];
    artistViewUrl = json['artistViewUrl'];
    collectionViewUrl = json['collectionViewUrl'];
    trackViewUrl = json['trackViewUrl'];
    previewUrl = json['previewUrl'];
    artworkUrl30 = json['artworkUrl30'];
    artworkUrl60 = json['artworkUrl60'];
    artworkUrl100 = json['artworkUrl100'];
    collectionPrice = json['collectionPrice'];
    trackPrice = json['trackPrice'];
    releaseDate = json['releaseDate'];
    collectionExplicitness = json['collectionExplicitness'];
    trackExplicitness = json['trackExplicitness'];
    discCount = json['discCount'];
    discNumber = json['discNumber'];
    trackCount = json['trackCount'];
    trackNumber = json['trackNumber'];
    trackTimeMillis = json['trackTimeMillis'];
    country = json['country'];
    currency = json['currency'];
    primaryGenreName = json['primaryGenreName'];
    isStreamable = json['isStreamable'];
  }
  String? wrapperType;
  String? kind;
  int? artistId;
  int? collectionId;
  int? trackId;
  String? artistName;
  String? collectionName;
  String? trackName;
  String? collectionCensoredName;
  String? trackCensoredName;
  int? collectionArtistId;
  String? collectionArtistName;
  String? artistViewUrl;
  String? collectionViewUrl;
  String? trackViewUrl;
  String? previewUrl;
  String? artworkUrl30;
  String? artworkUrl60;
  String? artworkUrl100;
  double? collectionPrice;
  double? trackPrice;
  String? releaseDate;
  String? collectionExplicitness;
  String? trackExplicitness;
  int? discCount;
  int? discNumber;
  int? trackCount;
  int? trackNumber;
  int? trackTimeMillis;
  String? country;
  String? currency;
  String? primaryGenreName;
  bool? isStreamable;
  bool? selected;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['wrapperType'] = wrapperType;
    map['kind'] = kind;
    map['artistId'] = artistId;
    map['collectionId'] = collectionId;
    map['trackId'] = trackId;
    map['artistName'] = artistName;
    map['collectionName'] = collectionName;
    map['trackName'] = trackName;
    map['collectionCensoredName'] = collectionCensoredName;
    map['trackCensoredName'] = trackCensoredName;
    map['collectionArtistId'] = collectionArtistId;
    map['collectionArtistName'] = collectionArtistName;
    map['artistViewUrl'] = artistViewUrl;
    map['collectionViewUrl'] = collectionViewUrl;
    map['trackViewUrl'] = trackViewUrl;
    map['previewUrl'] = previewUrl;
    map['artworkUrl30'] = artworkUrl30;
    map['artworkUrl60'] = artworkUrl60;
    map['artworkUrl100'] = artworkUrl100;
    map['collectionPrice'] = collectionPrice;
    map['trackPrice'] = trackPrice;
    map['releaseDate'] = releaseDate;
    map['collectionExplicitness'] = collectionExplicitness;
    map['trackExplicitness'] = trackExplicitness;
    map['discCount'] = discCount;
    map['discNumber'] = discNumber;
    map['trackCount'] = trackCount;
    map['trackNumber'] = trackNumber;
    map['trackTimeMillis'] = trackTimeMillis;
    map['country'] = country;
    map['currency'] = currency;
    map['primaryGenreName'] = primaryGenreName;
    map['isStreamable'] = isStreamable;
    return map;
  }

}