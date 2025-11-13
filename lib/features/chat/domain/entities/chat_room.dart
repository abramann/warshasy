// ============================================
// lib/features/chat/domain/entities/chat_room.dart
// ============================================
import 'package:equatable/equatable.dart';

class ChatRoom extends Equatable {
  final String id;
  final String clientId;
  final String clientName;
  final String? clientAvatarUrl;
  final String professionalId;
  final String professionalName;
  final String? professionalAvatarUrl;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final int unreadCount;
  final DateTime createdAt;

  const ChatRoom({
    required this.id,
    required this.clientId,
    required this.clientName,
    this.clientAvatarUrl,
    required this.professionalId,
    required this.professionalName,
    this.professionalAvatarUrl,
    this.lastMessage,
    this.lastMessageAt,
    this.unreadCount = 0,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    clientId,
    clientName,
    clientAvatarUrl,
    professionalId,
    professionalName,
    professionalAvatarUrl,
    lastMessage,
    lastMessageAt,
    unreadCount,
    createdAt,
  ];
}
