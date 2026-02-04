import 'package:equatable/equatable.dart';

class HomeBrand extends Equatable {
  const HomeBrand({
    required this.id,
    required this.name,
    required this.tagline,
    required this.imageAsset,
    this.backgroundColor,
  });

  final String id;
  final String name;
  final String tagline;
  final String imageAsset;
  final int? backgroundColor;

  @override
  List<Object?> get props => [id, name, tagline, imageAsset, backgroundColor];
}
