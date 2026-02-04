import 'package:equatable/equatable.dart';

/// Base class for all item events.
abstract class ItemEvent extends Equatable {
  const ItemEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load items for a supplier.
class LoadItems extends ItemEvent {
  final int supplierId;

  const LoadItems(this.supplierId);

  @override
  List<Object?> get props => [supplierId];
}

/// Event to refresh items.
class RefreshItems extends ItemEvent {
  final int supplierId;

  const RefreshItems(this.supplierId);

  @override
  List<Object?> get props => [supplierId];
}
