import 'package:equatable/equatable.dart';

enum EntitlementStatus { granted, notGranted, notRequired, unknown }

enum EntitlementRequirement { required, notRequired }

enum CommercialPlan { free, pro, vip, unknown }

class EntitlementContext extends Equatable {
  const EntitlementContext._({
    required this.status,
    required this.requirement,
    this.plan,
  });

  const EntitlementContext.granted({CommercialPlan? plan})
    : this._(
        status: EntitlementStatus.granted,
        requirement: EntitlementRequirement.required,
        plan: plan,
      );

  const EntitlementContext.notGranted({CommercialPlan? plan})
    : this._(
        status: EntitlementStatus.notGranted,
        requirement: EntitlementRequirement.required,
        plan: plan,
      );

  const EntitlementContext.notRequired({CommercialPlan? plan})
    : this._(
        status: EntitlementStatus.notRequired,
        requirement: EntitlementRequirement.notRequired,
        plan: plan,
      );

  const EntitlementContext.unknown({
    EntitlementRequirement requirement = EntitlementRequirement.required,
    CommercialPlan? plan,
  }) : this._(
         status: EntitlementStatus.unknown,
         requirement: requirement,
         plan: plan,
       );

  final EntitlementStatus status;
  final EntitlementRequirement requirement;

  /// Informational commercial vocabulary. It never grants permission by itself.
  final CommercialPlan? plan;

  bool get satisfiesRequirement {
    return requirement == EntitlementRequirement.notRequired ||
        status == EntitlementStatus.granted;
  }

  @override
  List<Object?> get props => [status, requirement, plan];
}
