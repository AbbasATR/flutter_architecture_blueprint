import 'package:equatable/equatable.dart';
import 'package:flutter_architecture_blueprint/features/item/domain/entities/item.dart';

/// Base class for all item states.
abstract class ItemState extends Equatable {
  const ItemState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any items are loaded.
class ItemInitial extends ItemState {
  const ItemInitial();
}

/// State when items are being loaded.
class ItemLoading extends ItemState {
  const ItemLoading();
}

/// State when items have been successfully loaded.
class ItemLoaded extends ItemState {
  final List<Item> items;

  const ItemLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

/// State when an error occurred while loading items.
class ItemError extends ItemState {
  final String message;

  const ItemError(this.message);

  @override
  List<Object?> get props => [message];
}
