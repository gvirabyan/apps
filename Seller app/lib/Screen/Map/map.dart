import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Screen/Map/Widget/myMaker.dart';
import '../../Helper/Color.dart';
import '../../Widget/appBar.dart';
import '../Profile/Profile.dart';

class MapScreen extends StatefulWidget {
  final double? latitude, longitude;
  final bool? from;

  const MapScreen({super.key, this.latitude, this.longitude, this.from});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool fromRegistration = false;
  LatLng? latlong;
  late CameraPosition _cameraPosition;
  GoogleMapController? _controller;
  TextEditingController locationController = TextEditingController();
  Set<Marker> _markers = {};

  Future getCurrentLocation() async {
    List<Placemark> placemark = await placemarkFromCoordinates(
      widget.latitude!,
      widget.longitude!,
    );

    if (mounted) {
      setState(
        () {
          latlong = LatLng(widget.latitude!, widget.longitude!);

          _cameraPosition = CameraPosition(target: latlong!, zoom: 16.0);
          if (_controller != null) {
            _controller!
                .animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
          }

          var address;
          address = placemark[0].name;
          address = address + ',' + placemark[0].subLocality;
          address = address + ',' + placemark[0].locality;
          address = address + ',' + placemark[0].administrativeArea;
          address = address + ',' + placemark[0].country;
          address = address + ',' + placemark[0].postalCode;

          locationController.text = address;
          _markers.add(
            Marker(
              markerId: const MarkerId('Marker'),
              position: LatLng(widget.latitude!, widget.longitude!),
            ),
          );
        },
      );
    }
  }

  @override
  void initState() {
    fromRegistration = widget.from ?? false;
    super.initState();

    _cameraPosition = const CameraPosition(target: LatLng(0, 0), zoom: 10.0);
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        "Choose Location".translate(context: context),
        context,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                children: [
                  (latlong != null)
                      ? GoogleMap(
                          initialCameraPosition: _cameraPosition,
                          onMapCreated: (GoogleMapController controller) {
                            _controller = (controller);
                            _controller!.animateCamera(
                              CameraUpdate.newCameraPosition(
                                _cameraPosition,
                              ),
                            );
                          },
                          minMaxZoomPreference:
                              const MinMaxZoomPreference(0, 16),
                          markers: _markers,
                          onTap: (latLng) {
                            if (mounted) {
                              setState(() {
                                latlong = latLng;
                                // Update the marker's position
                                _markers.clear();
                                myMarker(_markers, latlong!, setState,
                                    locationController);
                              });
                            }
                          },
                        )
                      : Container(),
                ],
              ),
            ),
            TextField(
              cursorColor: black,
              controller: locationController,
              readOnly: true,
              style: const TextStyle(
                color: fontColor,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                icon: Container(
                  margin: const EdgeInsetsDirectional.only(
                    start: 20,
                    top: 0,
                  ),
                  width: 10,
                  height: 10,
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.green,
                  ),
                ),
                hintText: 'pick up'.translate(context: context),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsetsDirectional.only(start: 15.0, top: 12.0),
              ),
            ),
            ElevatedButton(
              child: Text(
                "Update Location".translate(context: context),
              ),
              onPressed: () {
                if (widget.from!) {
                  profileProvider!.latitutute = latlong!.latitude.toString();
                  profileProvider!.longitude = latlong!.longitude.toString();
                } else {}
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
