// ============================================
// lib/features/chat/domain/entities/message.dart
// ============================================
import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String id;
  final String roomId;
  final String senderId;
  final String content;
  final bool isRead;
  final DateTime createdAt;

  const Message({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.content,
    this.isRead = false,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, roomId, senderId, content, isRead, createdAt];
}
