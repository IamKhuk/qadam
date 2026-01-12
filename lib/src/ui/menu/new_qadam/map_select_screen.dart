import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:qadam/src/theme/app_theme.dart';
import 'package:qadam/src/ui/widgets/buttons/primary_button.dart';
import 'package:qadam/src/ui/widgets/containers/leading_back.dart';
import 'package:qadam/src/ui/widgets/texts/text_16h_500w.dart';

import '../../../theme/map_style.dart';

class MapSelectScreen extends StatefulWidget {
  final String place;
  final Function(LatLng position) onSelected;

  const MapSelectScreen({
    super.key,
    required this.place,
    required this.onSelected,
  });

  @override
  State<MapSelectScreen> createState() => _MapSelectScreenState();
}

class _MapSelectScreenState extends State<MapSelectScreen> {
  GoogleMapController? _controller;
  LatLng? _selectedLocation;
  LatLng _initialPosition = const LatLng(41.2995, 69.2401); // Default to Tashkent
  bool _isLoading = true;
  MapType _currentMapType = MapType.normal;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    String place = widget.place.trim();
    if (place.isEmpty) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    // List of address variants to try, from most specific to least specific
    List<String> variants = [];
    
    // 1. Original place with Uzbekistan suffix
    if (!place.toLowerCase().contains('uzbekistan')) {
      variants.add('$place, Uzbekistan');
    }
    
    // 2. Original place as is
    variants.add(place);

    // 3. Shorter version if it's a comma-separated address
    List<String> parts = place.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    if (parts.length > 2) {
      // Try last two parts (e.g., "City, Region")
      String shorter = '${parts[parts.length - 2]}, ${parts.last}';
      if (!shorter.toLowerCase().contains('uzbekistan')) {
        variants.add('$shorter, Uzbekistan');
      }
      variants.add(shorter);
    }
    
    if (parts.isNotEmpty) {
      // Try just the last part (usually the city or region)
      String last = parts.last;
      if (!last.toLowerCase().contains('uzbekistan')) {
        variants.add('$last, Uzbekistan');
      }
      variants.add(last);
    }

    bool found = false;
    for (String variant in variants.toSet()) {
      try {
        List<Location> locations = await locationFromAddress(variant);
        if (locations.isNotEmpty) {
          _initialPosition = LatLng(locations.first.latitude, locations.first.longitude);
          found = true;
          debugPrint('Geocoding success for: $variant');
          break;
        }
      } catch (e) {
        debugPrint('Geocoding attempt failed for "$variant": $e');
      }
    }

    if (!found) {
      debugPrint('No geocoding results for: ${widget.place}. Using default position.');
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _selectedLocation = position;
    });
  }

  void _toggleMapType() {
    setState(() {
      if (_currentMapType == MapType.normal) {
        _currentMapType = MapType.hybrid;
      } else {
        _currentMapType = MapType.normal;
      }
    });
  }

  void _confirmSelection() {
    if (_selectedLocation != null) {
      widget.onSelected(_selectedLocation!);
      Navigator.pop(context, _selectedLocation);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a location on the map')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const LeadingBack(),
        title: const Text16h500w(title: 'Select Location'),
        centerTitle: true,
        elevation: 0,
      ),
      body: _isLoading
          ? Container(
              color: Colors.black.withOpacity(0.05),
              child: Center(
                child: Container(
                  height: 96,
                  width: 96,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 5),
                        blurRadius: 25,
                        spreadRadius: 0,
                        color: Colors.black.withOpacity(0.05),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppTheme.purple),
                    ),
                  ),
                ),
              ),
            )
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _initialPosition,
                    zoom: 16,
                  ),
                  scrollGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  zoomGesturesEnabled: true,
                  compassEnabled: false,
                  myLocationEnabled: false,
                  mapType: _currentMapType,
                  myLocationButtonEnabled: false,
                  onMapCreated: _onMapCreated,
                  onTap: _onMapTap,
                  markers: _selectedLocation != null
                      ? {
                          Marker(
                            markerId: const MarkerId('selected'),
                            position: _selectedLocation!,
                          ),
                        }
                      : {},
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 32,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(top: 22),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: AppTheme.black),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 15,
                            blurRadius: 25,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: AppTheme.purple,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.place,
                              style: const TextStyle(
                                fontFamily: AppTheme.fontFamily,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                                color: AppTheme.black,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const SizedBox(width: 16),
                        FloatingActionButton(
                          onPressed: _toggleMapType,
                          mini: true,
                          backgroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.layers,
                            color: AppTheme.purple,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 32,
                        left: 16,
                        right: 16,
                      ),
                      child: GestureDetector(
                        onTap: () => _confirmSelection(),
                        child: const PrimaryButton(title: "Confirm Location"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  void _onMapCreated(GoogleMapController controllerParam) {
    setState(() {
      _controller = controllerParam;
    });
  }
}
