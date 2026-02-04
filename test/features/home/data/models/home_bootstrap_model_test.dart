import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_architecture_blueprint/features/home/data/models/home_bootstrap_model.dart';
import '../../../../helpers/json_reader.dart';

void main() {
  const tHomeBootstrapModel = HomeBootstrapModel(
    categories: [],
    brands: [],
    savedItems: [],
    newListings: [],
  );

  group('HomeBootstrapModel', () {
    test('should be a subclass of HomeBootstrap entity', () {
      expect(tHomeBootstrapModel, isA<HomeBootstrapModel>());
    });

    group('fromJson', () {
      test('should return a valid model from JSON', () {
        // arrange
        final jsonMap =
            json.decode(fixture('home/home_bootstrap.json'))
                as Map<String, dynamic>;

        // act
        final result = HomeBootstrapModel.fromJson(jsonMap);

        // assert
        expect(result, isA<HomeBootstrapModel>());
        expect(result.categories, isNotEmpty);
        expect(result.brands, isNotEmpty);
        expect(result.savedItems, isEmpty);
        expect(result.newListings, isEmpty);
      });

      test('should handle null values by returning empty lists', () {
        // arrange
        final jsonMap = {
          'categories': null,
          'brands': null,
          'saved_items': null,
          'new_listings': null,
        };

        // act
        final result = HomeBootstrapModel.fromJson(jsonMap);

        // assert
        expect(result.categories, isEmpty);
        expect(result.brands, isEmpty);
        expect(result.savedItems, isEmpty);
        expect(result.newListings, isEmpty);
      });

      test('should handle missing keys by returning empty lists', () {
        // arrange
        final jsonMap = <String, dynamic>{};

        // act
        final result = HomeBootstrapModel.fromJson(jsonMap);

        // assert
        expect(result.categories, isEmpty);
        expect(result.brands, isEmpty);
        expect(result.savedItems, isEmpty);
        expect(result.newListings, isEmpty);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        // act
        final result = tHomeBootstrapModel.toJson();

        // assert
        expect(result, contains('categories'));
        expect(result, contains('brands'));
        expect(result, contains('saved_items'));
        expect(result, contains('new_listings'));
        expect(result['categories'], isList);
        expect(result['brands'], isList);
        expect(result['saved_items'], isList);
        expect(result['new_listings'], isList);
      });
    });
  });
}
