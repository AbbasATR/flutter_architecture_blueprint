import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'package:flutter_architecture_blueprint/features/address/presentation/screens/location_picker_screen.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';

/// Widget that displays a mini map preview of the selected location
class LocationPreviewCard extends StatelessWidget {
  final double latitude;
  final double longitude;
  final MapController mapController;

  const LocationPreviewCard({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.mapController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.units.h(200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.cs.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Mini map
          OSMFlutter(
            controller: mapController,
            osmOption: OSMOption(
              zoomOption: const ZoomOption(
                initZoom: 16,
                minZoomLevel: 16,
                maxZoomLevel: 16,
                stepZoom: 1.0,
              ),
              enableRotationByGesture: false,
              staticPoints: [
                StaticPositionGeoPoint(
                  'selected_location',
                  const MarkerIcon(
                    icon: Icon(
                      IconsaxPlusBold.location,
                      color: Colors.red,
                      size: 55,
                    ),
                  ),
                  [GeoPoint(latitude: latitude, longitude: longitude)],
                ),
              ],
            ),
            mapIsLoading: Center(
              child: CircularProgressIndicator(color: context.cs.primary),
            ),
          ),

          // Semi-transparent overlay to prevent interaction
          Positioned.fill(child: Container(color: Colors.transparent)),

          // Edit location button
          Positioned(
            top: 12,
            right: 12,
            child: _EditLocationButton(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LocationPickerScreen(),
                  ),
                );
              },
            ),
          ),

          // Location coordinates display
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: _CoordinatesDisplay(
              latitude: latitude,
              longitude: longitude,
            ),
          ),
        ],
      ),
    );
  }
}

/// Edit location button widget
class _EditLocationButton extends StatelessWidget {
  final VoidCallback onTap;

  const _EditLocationButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.cs.secondary,
      borderRadius: BorderRadius.circular(8),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.units.w(12),
            vertical: context.units.h(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(IconsaxPlusLinear.edit, size: 16, color: context.cs.primary),
              SizedBox(width: context.units.w(4)),
              Text(
                'Edit',
                style: context.tt.labelMedium.copyWith(
                  color: context.cs.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Coordinates display widget
class _CoordinatesDisplay extends StatelessWidget {
  final double latitude;
  final double longitude;

  const _CoordinatesDisplay({required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.units.w(12),
        vertical: context.units.h(8),
      ),
      decoration: BoxDecoration(
        color: context.cs.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Lat: ${latitude.toStringAsFixed(6)}, Long: ${longitude.toStringAsFixed(6)}',
        style: context.tt.labelMedium.copyWith(color: context.cs.onSurface),
        textAlign: TextAlign.center,
      ),
    );
  }
}
