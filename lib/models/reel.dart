class Episode {
  final String id;
  final String name;
  final String thumbnail;
  final String videoUrl;
  final String duration;
  final int episodeNumber;

  Episode({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.videoUrl,
    required this.duration,
    required this.episodeNumber,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      duration: json['duration'] ?? '',
      episodeNumber: json['episodeNumber'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'thumbnail': thumbnail,
      'videoUrl': videoUrl,
      'duration': duration,
      'episodeNumber': episodeNumber,
    };
  }
}

class Reel {
  final String id;
  final String name;
  final String description;
  final String thumbnail;
  final String videoUrl;
  final String releaseDate;
  final String duration;
  final List<Episode> episodes;

  Reel({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnail,
    required this.videoUrl,
    required this.releaseDate,
    required this.duration,
    required this.episodes,
  });

  factory Reel.fromJson(Map<String, dynamic> json) {
    return Reel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      releaseDate: json['releaseDate'] ?? '',
      duration: json['duration'] ?? '',
      episodes: (json['episodes'] as List<dynamic>?)
              ?.map((e) => Episode.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'thumbnail': thumbnail,
      'videoUrl': videoUrl,
      'releaseDate': releaseDate,
      'duration': duration,
      'episodes': episodes.map((e) => e.toJson()).toList(),
    };
  }
}
