class SearchChargers {
  final String placeName;
  final String roadAddressName;
  final String x;
  final String y;
  final String addressName;

  SearchChargers({required this.placeName, required this.roadAddressName, required this.x, required this.y, required this.addressName});

  factory SearchChargers.fromJson(Map<String, dynamic> json) {
    return SearchChargers(
      placeName: json['place_name'] ?? '',
      roadAddressName: json['road_address_name'] ?? '',
      x: json['x'] ?? '',
      y: json['y'] ?? '',
      addressName: json['address_name'] ?? '',
    );
  }
}
