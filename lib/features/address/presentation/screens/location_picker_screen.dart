import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_architecture_blueprint/features/address/presentation/screens/add_address_screen.dart';
import 'package:flutter_architecture_blueprint/shared/localization/x_l10n.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_colors.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_size.dart';
import 'package:flutter_architecture_blueprint/shared/theme/extensions/x_text.dart';
import 'package:flutter_architecture_blueprint/shared/widgets/buttons/floating_action_button.dart'
    as custom;
import 'package:flutter_architecture_blueprint/shared/widgets/buttons/submit_button.dart';

/// Screen for picking location on map using flutter_osm_plugin
class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late MapController _mapController;
  GeoPoint? _selectedLocation;
  bool _isLoading = true;

  // Default location (Dubai, UAE) - fallback if current location fails
  static final GeoPoint _defaultLocation = GeoPoint(
    latitude: 25.2048,
    longitude: 55.2708,
  );

  @override
  void initState() {
    super.initState();
    _mapController = MapController(initPosition: _defaultLocation);
    _initializeCurrentLocation();
  }

  Future<void> _initializeCurrentLocation() async {
    try {
      // Get current location
      final currentLocation = await _mapController.myLocation();

      if (mounted) {
        setState(() {
          _selectedLocation = currentLocation;
          _isLoading = false;
        });

        // Move camera to current location
        await _mapController.moveTo(currentLocation);
      }
    } catch (e) {
      // Fallback to default location if getting current location fails
      if (mounted) {
        setState(() {
          _selectedLocation = _defaultLocation;
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.couldNotGetCurrentLocation)),
        );
      }
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);

    try {
      // Get current location
      final currentLocation = await _mapController.myLocation();

      setState(() {
        _selectedLocation = currentLocation;
      });

      // Move camera to current location
      await _mapController.moveTo(currentLocation);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.l10n.failedToGetCurrentLocation(e.toString()),
            ),
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _confirmLocation() async {
    // Get the center position of the map
    final centerPosition = await _mapController.centerMap;

    // Navigate to add address screen with center location
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AddAddressScreen(
            latitude: centerPosition.latitude,
            longitude: centerPosition.longitude,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.pickLocation, style: context.tt.titleMedium),
        backgroundColor: context.cs.surface,
        elevation: 0,
        leading: custom.FloatingActionButton(
          icon: IconsaxPlusLinear.undo,
          onTap: () => Navigator.pop(context),
        ),
      ),

      body: Stack(
        children: [
          // OSM Map
          OSMFlutter(
            controller: _mapController,
            osmOption: OSMOption(
              userTrackingOption: const UserTrackingOption(
                enableTracking: true,
                unFollowUser: false,
              ),
              zoomOption: const ZoomOption(
                initZoom: 15,
                minZoomLevel: 3,
                maxZoomLevel: 19,
                stepZoom: 1.0,
              ),
              userLocationMarker: UserLocationMaker(
                personMarker: const MarkerIcon(
                  icon: Icon(
                    Icons.location_history_rounded,
                    color: Colors.red,
                    size: 48,
                  ),
                ),
                directionArrowMarker: const MarkerIcon(
                  icon: Icon(Icons.double_arrow, size: 48),
                ),
              ),
              roadConfiguration: const RoadOption(
                roadColor: Colors.yellowAccent,
              ),
            ),
            onMapIsReady: (isReady) {
              // Map is ready - no need to add markers
            },
            onMapMoved: (region) async {
              // Update selected location as map moves
              final centerPosition = await _mapController.centerMap;
              setState(() {
                _selectedLocation = centerPosition;
              });
            },
          ),

          // Fixed center pin
          Center(
            child: Icon(
              IconsaxPlusBold.location,
              color: context.cs.error,
              size: 48,
            ),
          ),

          // Current location button
          Positioned(
            right: 16,
            bottom: 180,
            child: FloatingActionButton(
              heroTag: 'current_location',
              onPressed: _isLoading ? null : _getCurrentLocation,
              backgroundColor: context.cs.surface,
              child: _isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: context.cs.primary,
                      ),
                    )
                  : Icon(Icons.my_location, color: context.cs.primary),
            ),
          ),

          // Bottom card with confirm button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: context.cs.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              padding: EdgeInsets.all(context.units.w(20)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_selectedLocation != null) ...[
                    Text(l10n.selectedLocation, style: context.tt.titleSmall),
                    SizedBox(height: context.units.h(8)),
                    Text(
                      '${l10n.latitude}: ${_selectedLocation!.latitude.toStringAsFixed(6)}, '
                      '${l10n.longitude}: ${_selectedLocation!.longitude.toStringAsFixed(6)}',
                      style: context.tt.labelMedium.copyWith(
                        color: context.cs.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    SizedBox(height: context.units.h(16)),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: SubmitButton(
                      text: l10n.confirmLocation,
                      onPressed: _confirmLocation,
                    ),
                  ),
                  SizedBox(height: context.units.h(8)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
