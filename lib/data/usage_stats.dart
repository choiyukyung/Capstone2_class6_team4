class UsageInfos{
  String? userId;
  String? firstTimeStamp;
  String? lastTimeStamp;
  String? lastTimeUsed;
  String? packageName;
  String? totalTimeInForeground;

  UsageInfos({
    required this.userId,
    required this.firstTimeStamp,
    required this.lastTimeStamp,
    required this.lastTimeUsed,
    required this. packageName,
    required this.totalTimeInForeground
  });

  factory UsageInfos.fromJson(Map<String, dynamic> json) {
    return UsageInfos(
      userId: json['userId'],
      firstTimeStamp: json['firstTimeStamp'],
      lastTimeStamp: json['lastTimeStamp'],
      lastTimeUsed: json['lastTimeUsed'],
      packageName: json['packageName'],
      totalTimeInForeground: json['totalTimeInForeground'],
    );
  }
  Map<String, dynamic> toJson() => {
    'userId': userId,
    'firstTimeStamp': firstTimeStamp,
    'lastTimeStamp': lastTimeStamp,
    'lastTimeUsed': lastTimeUsed,
    'packageName': packageName,
    'totalTimeInForeground': totalTimeInForeground,
  };
}