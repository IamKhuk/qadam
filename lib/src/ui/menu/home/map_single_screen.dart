import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../theme/app_theme.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/containers/leading_back.dart';
import '../../widgets/texts/text_16h_500w.dart';

class MapSingleScreen extends StatefulWidget {
  final LatLng location;
  final String place;

  const MapSingleScreen({
    super.key,
    required this.location,
    required this.place,
  });

  @override
  State<MapSingleScreen> createState() => _MapSingleScreenState();
}

class _MapSingleScreenState extends State<MapSingleScreen> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  bool isLoading = true;
  MapType _currentMapType = MapType.normal;

  @override
  void initState() {
    super.initState();
    _setMarker();
  }

  void _setMarker() {
    _markers.add(
      Marker(
        markerId: const MarkerId('location'),
        position: widget.location,
        infoWindow: const InfoWindow(title: 'Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const LeadingBack(),
        title: Text16h500w(title: translate('home.location')),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.location,
              zoom: 16,
            ),
            markers: _markers,
            scrollGesturesEnabled: true,
            zoomControlsEnabled: false,
            zoomGesturesEnabled: true,
            compassEnabled: false,
            myLocationEnabled: false,
            mapType: _currentMapType,
            myLocationButtonEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              setState(() {
                isLoading = false;
              });
            },
          ),
          Column(
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
                  onTap: () => Navigator.pop(context),
                  child: const PrimaryButton(title: "OK"),
                ),
              ),
            ],
          ),
          if (isLoading)
            Container(
              color: Colors.transparent,
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
            ),
        ],
      ),
    );
  }
}
