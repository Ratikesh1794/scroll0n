class Reel {
  final String id;
  final String name;
  final String description;
  final String thumbnail;
  final String videoUrl;
  final String releaseDate;
  final String duration;

  Reel({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnail,
    required this.videoUrl,
    required this.releaseDate,
    required this.duration,
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
    };
  }
}
