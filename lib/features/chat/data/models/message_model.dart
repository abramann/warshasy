// ============================================
// lib/features/chat/data/models/message_model.dart
// ============================================
import '../../domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.roomId,
    required super.senderId,
    required super.content,
    super.isRead,
    required super.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      roomId: json['room_id'] as String,
      senderId: json['sender_id'] as String,
      content: json['content'] as String,
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'room_id': roomId,
      'sender_id': senderId,
      'content': content,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory MessageModel.fromEntity(Message entity) {
    return MessageModel(
      id: entity.id,
      roomId: entity.roomId,
      senderId: entity.senderId,
      content: entity.content,
      isRead: entity.isRead,
      createdAt: entity.createdAt,
    );
  }

  MessageModel copyWith({
    String? id,
    String? roomId,
    String? senderId,
    String? content,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return MessageModel(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
