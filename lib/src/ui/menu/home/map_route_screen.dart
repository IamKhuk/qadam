import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../theme/app_theme.dart';
import '../../widgets/buttons/primary_button.dart';

class MapRouteScreen extends StatefulWidget {
  final LatLng start;
  final LatLng end;
  final String startText;
  final String endText;

  const MapRouteScreen({
    super.key,
    required this.start,
    required this.end,
    required this.startText,
    required this.endText,
  });

  @override
  State<MapRouteScreen> createState() => _MapRouteScreenState();
}

class _MapRouteScreenState extends State<MapRouteScreen> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  MapType _currentMapType = MapType.normal;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _setMarkers();
    _fetchRoute();
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

  void _setMarkers() {
    _markers.add(
      Marker(
        markerId: const MarkerId('start'),
        position: widget.start,
        infoWindow: const InfoWindow(title: 'Start'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );
    _markers.add(
      Marker(
        markerId: const MarkerId('end'),
        position: widget.end,
        infoWindow: const InfoWindow(title: 'End'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
  }

  Future<void> _fetchRoute() async {
    const apiKey = 'AIzaSyAtf7hud1ntObeLKiYCNrM967iMDtWkMag';
    final url = 'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=${widget.start.latitude},${widget.start.longitude}'
        '&destination=${widget.end.latitude},${widget.end.longitude}'
        '&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final points = data['routes'][0]['overview_polyline']['points'];
        final decodedPoints = _decodePolyline(points);
        setState(() {
          _polyLines.add(
            Polyline(
              polylineId: const PolylineId('route'),
              points: decodedPoints,
              color: AppTheme.purple,
              width: 5,
            ),
          );
          isLoading = false;
        });
      } else {
        debugPrint('Directions API error: ${data['status']}');
        setState(() {
          isLoading = false;
        });
      }
    } else {
      debugPrint('Failed to fetch route: ${response.statusCode}');
      setState(() {
        isLoading = false;
      });
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  LatLng _calculateCenter() {
    final lat = (widget.start.latitude + widget.end.latitude) / 2;
    final lng = (widget.start.longitude + widget.end.longitude) / 2;
    return LatLng(lat, lng);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _calculateCenter(),
              zoom: 8,
            ),
            markers: _markers,
            polylines: _polyLines,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            compassEnabled: false,
            myLocationEnabled: false,
            mapType: _currentMapType,
            myLocationButtonEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 64),
              SizedBox(
                height: 132,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 32,
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(left: 16),
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
                                  widget.startText,
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
                        const SizedBox(height: 12),
                        Container(
                          width: MediaQuery.of(context).size.width - 32,
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(left: 16),
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
                                  widget.endText,
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
                      ],
                    ),
                    SizedBox(
                      height: 132,
                      child: Row(
                        children: [
                          const Spacer(),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: AppTheme.purple,
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                height: 16,
                                'assets/icons/swap_vertical.svg',
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          const Spacer(),
                          const Spacer(),
                        ],
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
            Column(
              children: [
                Center(
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
              ],
            ),
        ],
      ),
    );
  }
}
