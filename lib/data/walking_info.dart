class WalkingInfo {
  String name;
  String time;
  String distance;
  List<String>? details;

  WalkingInfo({
    required this.name,
    required this.time,
    required this.distance,
    required this.details,
  });

  factory WalkingInfo.fromJson(Map<String, dynamic> json) {
    return WalkingInfo(
      name: json['name'],
      time: json['time'],
      distance: json['distance'],
      details: json['details'],
    );
  }
  Map<String, dynamic> toJson() => {
    'name': name,
    'time': time,
    'distance': distance,
    'details': details,
  };
}