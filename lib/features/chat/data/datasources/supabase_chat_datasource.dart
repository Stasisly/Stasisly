import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:stasisly/core/error/exceptions.dart';
import 'package:stasisly/features/chat/domain/entities/chat_session_entity.dart';
import 'package:stasisly/features/chat/domain/entities/message_entity.dart';

class SupabaseChatDataSource {
  const SupabaseChatDataSource(this._supabase);

  final supabase.SupabaseClient _supabase;

  Future<ChatSessionEntity> getOrCreateSession({
    required String userId,
    required String specialistId,
  }) async {
    try {
      // Intentar buscar sesión activa
      final response = await _supabase
          .from('chat_sessions')
          .select()
          .eq('user_id', userId)
          .eq('specialist_id', specialistId)
          .eq('status', 'active')
          .maybeSingle();

      if (response != null) {
        return _mapSession(response);
      }

      // Si no existe, crearla
      final insertResponse = await _supabase
          .from('chat_sessions')
          .insert({
            'user_id': userId,
            'specialist_id': specialistId,
          })
          .select()
          .single();

      return _mapSession(insertResponse);
    } on supabase.PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<MessageEntity> sendMessage({
    required String sessionId,
    required String role,
    required String content,
  }) async {
    try {
      final response = await _supabase
          .from('messages')
          .insert({
            'session_id': sessionId,
            'role': role,
            'content': content,
          })
          .select()
          .single();

      // Actualizar la sesión
      await _supabase
          .rpc('increment_message_count', params: {'sess_id': sessionId});

      return _mapMessage(response);
    } on supabase.PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Stream<List<MessageEntity>> watchMessages(String sessionId) {
    return _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('session_id', sessionId)
        .order('created_at', ascending: true)
        .map((data) => data.map((json) => _mapMessage(json)).toList());
  }

  ChatSessionEntity _mapSession(Map<String, dynamic> json) {
    return ChatSessionEntity(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      specialistId: json['specialist_id'] as String,
      startedAt: DateTime.parse(json['started_at'] as String),
      lastMessageAt: DateTime.parse(json['last_message_at'] as String),
      status: json['status'] as String,
      messageCount: json['message_count'] as int,
    );
  }

  MessageEntity _mapMessage(Map<String, dynamic> json) {
    return MessageEntity(
      id: json['id'] as String,
      sessionId: json['session_id'] as String,
      role: json['role'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
    );
  }
}
