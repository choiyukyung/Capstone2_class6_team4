class AppInfo {
  int? screentimeId;
  DateTime? startDate;
  DateTime? endDate;
  String? id;
  String? appEntry;
  String? appIcon;
  String? appTime;
  double? appCarbon;

  AppInfo({
    required this.screentimeId,
    required this.startDate,
    required this.endDate,
    required this.id,
    required this.appEntry,
    required this.appIcon,
    required this.appTime,
    required this.appCarbon,
  });

  factory AppInfo.fromJson(Map<String, dynamic> json) {
    return AppInfo(
      screentimeId: json['screentimeId'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      id: json['id'],
      appEntry: json['appEntry'],
      appIcon: json['appIcon'],
      appTime: json['appTime'],
      appCarbon: json['appCarbon'],
    );
  }
}