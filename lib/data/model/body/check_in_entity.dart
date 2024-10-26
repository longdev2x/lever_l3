class CheckInEntity {
  final int? id;
  final String? ip;
  final String? message;
  final bool? offline;
  final DateTime? dateAttendance;

  const CheckInEntity(
      this.id, this.ip, this.message, this.offline, this.dateAttendance);

  factory CheckInEntity.fromJson(Map<String, dynamic>? json) => CheckInEntity(
        json?['id'],
        json?['ip'],
        json?['message'],
        json?['offline'],
        json?['dateAttendance'] != null ? DateTime.fromMillisecondsSinceEpoch(json!['dateAttendance']) : null,
      );
}
