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
        json?['dateAttendance'] != null
            ? DateTime.fromMillisecondsSinceEpoch(json!['dateAttendance']).toLocal()
            : null,
      );
}

// {id: 158, 
// dateAttendance: 2024-10-25T21:09:54.000+00:00, 
// message: null, 
// ip: 42.117.79.205, 
// user: null, 
// offline: false}
