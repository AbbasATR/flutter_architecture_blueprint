import 'package:equatable/equatable.dart';

class HomeCategory extends Equatable {
  const HomeCategory({
    required this.id,
    required this.label,
    required this.iconAsset,
    this.backgroundColor,
  });

  final String id;
  final String label;
  final String iconAsset;
  final int? backgroundColor;

  @override
  List<Object?> get props => [id, label, iconAsset, backgroundColor];
}
