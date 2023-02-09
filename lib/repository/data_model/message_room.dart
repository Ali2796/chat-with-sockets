class MessageRoomEntity {
  String? message;
  String? status;
  int? sender;
  String? dateTime;

//<editor-fold desc="Data Methods">

  MessageRoomEntity({
    this.message,
    this.status,
    this.sender,
    this.dateTime,
  });

  factory MessageRoomEntity.fromMap(Map<String, dynamic> map) {
    return MessageRoomEntity(
      message: map['message'] as String,
      status: map['status'] as String,
      sender: map['sender'] as int,
      dateTime: map['dateTime'] as String,
    );
  }

//</editor-fold>
}
