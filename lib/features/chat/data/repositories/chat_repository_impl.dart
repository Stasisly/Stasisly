import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';

import 'package:stasisly/core/error/exceptions.dart';
import 'package:stasisly/core/error/failures.dart';
import 'package:stasisly/features/chat/data/datasources/supabase_chat_datasource.dart';
import 'package:stasisly/features/chat/domain/entities/chat_session_entity.dart';
import 'package:stasisly/features/chat/domain/entities/message_entity.dart';
import 'package:stasisly/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl(this._dataSource);

  final SupabaseChatDataSource _dataSource;
  
  // -- FALLBACK MOCK STATE --
  // Como aún no tenemos login real ni RLS configurado en la DB temporal,
  // usaremos un fallback en memoria si Supabase falla o si usamos credenciales falsas.
  final Map<String, ChatSessionEntity> _mockSessions = {};
  final Map<String, List<MessageEntity>> _mockMessages = {};
  final Map<String, StreamController<List<MessageEntity>>> _mockStreams = {};

  @override
  Future<Either<Failure, ChatSessionEntity>> getOrCreateSession({
    required String userId,
    required String specialistId,
  }) async {
    try {
      final session = await _dataSource.getOrCreateSession(
        userId: userId,
        specialistId: specialistId,
      );
      return Right(session);
    } catch (e) {
      // FALLBACK
      final mockId = 'mock_session_$specialistId';
      if (!_mockSessions.containsKey(mockId)) {
        _mockSessions[mockId] = ChatSessionEntity(
          id: mockId,
          userId: userId,
          specialistId: specialistId,
          startedAt: DateTime.now(),
          lastMessageAt: DateTime.now(),
          status: 'active',
          messageCount: 0,
        );
        _mockMessages[mockId] = [];
        _mockStreams[mockId] = StreamController<List<MessageEntity>>.broadcast();
        // Emite el estado inicial vacío
        Future.microtask(() => _mockStreams[mockId]!.add([]));
      }
      return Right(_mockSessions[mockId]!);
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> sendMessage({
    required String sessionId,
    required String role,
    required String content,
  }) async {
    try {
      final message = await _dataSource.sendMessage(
        sessionId: sessionId,
        role: role,
        content: content,
      );
      return Right(message);
    } catch (e) {
      // FALLBACK
      if (!_mockMessages.containsKey(sessionId)) {
        _mockMessages[sessionId] = [];
      }
      
      final msg = MessageEntity(
        id: const Uuid().v4(),
        sessionId: sessionId,
        role: role,
        content: content,
        createdAt: DateTime.now(),
      );
      
      _mockMessages[sessionId]!.add(msg);
      _mockStreams[sessionId]?.add(List.from(_mockMessages[sessionId]!));
      
      // Simulamos la respuesta de la IA (Orquestador o Especialista)
      if (role == 'user') {
        Future.delayed(const Duration(seconds: 2), () {
          final aiMsg = MessageEntity(
            id: const Uuid().v4(),
            sessionId: sessionId,
            role: 'assistant',
            content: 'Soy tu especialista virtual. Esta es una respuesta de prueba asíncrona simulando el LLM. (MockFallback)',
            createdAt: DateTime.now(),
          );
          _mockMessages[sessionId]!.add(aiMsg);
          _mockStreams[sessionId]?.add(List.from(_mockMessages[sessionId]!));
        });
      }

      return Right(msg);
    }
  }

  @override
  Stream<List<MessageEntity>> watchMessages(String sessionId) {
    try {
      // Intentamos conectarnos a Supabase. Si falla, el catch de Dart Stream no es sincrono,
      // pero asumimos que el datasource puede configurarse condicionalmente.
      // Por simplicidad, retornaremos el stream del mock si es una sesión mock.
      if (sessionId.startsWith('mock_')) {
        return _mockStreams[sessionId]?.stream ?? Stream.value([]);
      }
      return _dataSource.watchMessages(sessionId);
    } catch (e) {
      return const Stream.empty();
    }
  }
}
