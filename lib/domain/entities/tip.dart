import 'package:equatable/equatable.dart';

/// Categorías de tips generados por el motor de personalización.
enum TipCategory {
  nutrition,
  recovery,
  technique,
  mindset,
  lifestyle,
}

/// Recomendación contextual mostrada en dashboard y notificaciones.
class Tip extends Equatable {
  const Tip({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    this.ctaLabel,
  });

  final String id;
  final TipCategory category;
  final String title;
  final String description;
  final String? ctaLabel;

  @override
  List<Object?> get props => <Object?>[id, category, title, description, ctaLabel];
}
