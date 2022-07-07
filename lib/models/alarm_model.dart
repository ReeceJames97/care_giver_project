class AlarmModel {
  int? alId;
  String? alarmTitle;
  DateTime? alarmTime;
  int? gradientColorIndex;
  String? flag;

  AlarmModel(
      {this.alId,
        this.alarmTitle,
        this.alarmTime,
        this.gradientColorIndex,
        this.flag
        });

  factory AlarmModel.fromMap(Map<String, dynamic> json) => AlarmModel(
    alId: json["alid"],
    alarmTitle: json["alarm_title"],
    alarmTime: DateTime.parse(json["alarm_time"]),
    gradientColorIndex: json["gradientColorIndex"],
    flag: json["flag"],
  );
  Map<String, dynamic> toMap() => {
    "alid": alId,
    "alarm_title": alarmTitle,
    "alarm_time": alarmTime?.toIso8601String(),
    "gradientColorIndex": gradientColorIndex,
    "flag": flag,
  };
}