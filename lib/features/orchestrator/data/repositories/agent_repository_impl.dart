import 'package:dartz/dartz.dart';

import 'package:stasisly/core/error/failures.dart';
import 'package:stasisly/features/orchestrator/domain/entities/agent_entity.dart';
import 'package:stasisly/features/orchestrator/domain/repositories/agent_repository.dart';

/// Mock implementation of [AgentRepository] for Sprint 2.
class AgentRepositoryImpl implements AgentRepository {
  AgentRepositoryImpl();

  final List<AgentEntity> _mockAgents = [
    // ── Orchestrator ──
    const AgentEntity(
      id: 'stasis_core',
      name: 'Stasis',
      role: AgentRole.orchestrator,
      branch: AgentBranch.orchestrator,
      specialty: 'Orquestador Principal',
      description: 'Tu IA central que coordina a todos los especialistas.',
    ),
    // ── Health ──
    const AgentEntity(
      id: 'health_chief',
      name: 'Dr. Vega',
      role: AgentRole.branchChief,
      branch: AgentBranch.health,
      specialty: 'Jefe de Salud',
      description: 'Supervisa tu historial clínico y coordina médicos.',
    ),
    const AgentEntity(
      id: 'health_cardio',
      name: 'Dr. Carlos Méndez',
      role: AgentRole.specialist,
      branch: AgentBranch.health,
      specialty: 'Cardiología',
      description: 'Especialista en salud cardiovascular.',
    ),
    const AgentEntity(
      id: 'health_neuro',
      name: 'Dra. Elena Solís',
      role: AgentRole.specialist,
      branch: AgentBranch.health,
      specialty: 'Neurología',
      description: 'Salud cerebral y sistema nervioso.',
    ),
    // ── Nutrition ──
    const AgentEntity(
      id: 'nutri_chief',
      name: 'Valeria',
      role: AgentRole.branchChief,
      branch: AgentBranch.nutrition,
      specialty: 'Jefa de Nutrición',
      description: 'Planifica tu dieta integral y macros.',
    ),
    const AgentEntity(
      id: 'nutri_sports',
      name: 'Nutri. Marcos',
      role: AgentRole.specialist,
      branch: AgentBranch.nutrition,
      specialty: 'Nutrición Deportiva',
      description: 'Rendimiento y ganancia muscular.',
    ),
    // ── Physical ──
    const AgentEntity(
      id: 'phys_chief',
      name: 'Coach Sarah',
      role: AgentRole.branchChief,
      branch: AgentBranch.physical,
      specialty: 'Jefa de Físico',
      description: 'Diseña tu rutina de entrenamiento integral.',
    ),
    const AgentEntity(
      id: 'phys_strength',
      name: 'Coach Diego',
      role: AgentRole.specialist,
      branch: AgentBranch.physical,
      specialty: 'Fuerza e Hipertrofia',
      description: 'Entrenamientos de pesas y powerlifting.',
    ),
    // ── Mental ──
    const AgentEntity(
      id: 'mental_chief',
      name: 'Dra. Miranda',
      role: AgentRole.branchChief,
      branch: AgentBranch.mental,
      specialty: 'Jefa de Mental',
      description: 'Coordina psicólogos y bienestar mental.',
    ),
    // Equipo Independiente de Wellness
    const AgentEntity(
      id: 'mental_wellness_chief',
      name: 'Lic. Sofía',
      role: AgentRole.subChief,
      branch: AgentBranch.mental,
      specialty: 'Jefa de Wellness',
      description: 'Supervisa las áreas de meditación, mindfulness y bienestar emocional integral.',
    ),
    const AgentEntity(
      id: 'mental_meditation',
      name: 'Guía Loto',
      role: AgentRole.specialist,
      branch: AgentBranch.mental,
      specialty: 'Especialista en Meditación',
      description: 'Técnicas de respiración y reducción de estrés activo.',
    ),
    // Equipo Independiente de Descanso
    const AgentEntity(
      id: 'mental_rest_chief',
      name: 'Dr. Somno',
      role: AgentRole.subChief,
      branch: AgentBranch.mental,
      specialty: 'Jefe de Descanso',
      description: 'Coordina la optimización clínica de ritmos circadianos y rutinas de sueño.',
    ),
    const AgentEntity(
      id: 'mental_sleep_coach',
      name: 'Coach Morfeo',
      role: AgentRole.specialist,
      branch: AgentBranch.mental,
      specialty: 'Coach de Sueño',
      description: 'Higiene del sueño y recuperación nocturna profunda.',
    ),
  ];

  @override
  Future<Either<Failure, List<AgentEntity>>> getAgents() async {
    return Right(_mockAgents);
  }

  @override
  Future<Either<Failure, List<AgentEntity>>> getAgentsByBranch(AgentBranch branch) async {
    final filtered = _mockAgents.where((a) => a.branch == branch).toList();
    return Right(filtered);
  }

  @override
  Future<Either<Failure, AgentEntity>> getAgentById(String id) async {
    try {
      final agent = _mockAgents.firstWhere((a) => a.id == id);
      return Right(agent);
    } catch (e) {
      return const Left(UnknownFailure(message: 'Agente no encontrado'));
    }
  }
}
