// ============================================
// lib/features/chat/data/models/chat_room_model.dart
// ============================================
import '../../domain/entities/chat_room.dart';

class ChatRoomModel extends ChatRoom {
  const ChatRoomModel({
    required super.id,
    required super.clientId,
    required super.clientName,
    super.clientAvatarUrl,
    required super.professionalId,
    required super.professionalName,
    super.professionalAvatarUrl,
    super.lastMessage,
    super.lastMessageAt,
    super.unreadCount,
    required super.createdAt,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      id: json['room_id'] as String,
      clientId: json['client_id'] as String,
      clientName: json['client_name'] as String,
      clientAvatarUrl: json['client_avatar'] as String?,
      professionalId: json['professional_id'] as String,
      professionalName: json['professional_name'] as String,
      professionalAvatarUrl: json['professional_avatar'] as String?,
      lastMessage: json['last_message'] as String?,
      lastMessageAt:
          json['last_message_at'] != null
              ? DateTime.parse(json['last_message_at'] as String)
              : null,
      unreadCount: json['unread_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'professional_id': professionalId,
      'last_message': lastMessage,
      'last_message_at': lastMessageAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory ChatRoomModel.fromEntity(ChatRoom entity) {
    return ChatRoomModel(
      id: entity.id,
      clientId: entity.clientId,
      clientName: entity.clientName,
      clientAvatarUrl: entity.clientAvatarUrl,
      professionalId: entity.professionalId,
      professionalName: entity.professionalName,
      professionalAvatarUrl: entity.professionalAvatarUrl,
      lastMessage: entity.lastMessage,
      lastMessageAt: entity.lastMessageAt,
      unreadCount: entity.unreadCount,
      createdAt: entity.createdAt,
    );
  }
}
