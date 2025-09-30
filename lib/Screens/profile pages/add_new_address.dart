import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_e_commerce_app/Configs/sharedPreferances.dart';
import 'package:flutter_e_commerce_app/Screens/cartPayments%20Page/checkout_page.dart';
import 'package:flutter_e_commerce_app/bloc/shipping%20address/shipping_address_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hive/hive.dart';

class AddNewAddressScreen extends StatefulWidget {
  @override
  _AddNewAddressScreenState createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  final _nameAddressController = TextEditingController(text: "Home");
  final _addressDetailsController = TextEditingController(text: "Select Location on Map");
  bool _isDefaultAddress = false;
  bool _isLoadingLocation = false;
  
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  LatLng? _currentPosition;
  Set<Marker> _markers = {};
  var box=Hive.box('address');

  static const CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(42.240593, -83.269311),
    zoom: 15.0,
  );

  @override
  void initState() {
    super.initState();
    
    _initializeMap();
  }

  @override
  void dispose() {
    _nameAddressController.dispose();
    _addressDetailsController.dispose();
    super.dispose();
  }

  Future<void> _initializeMap() async {
    _currentPosition = LatLng(42.240593, -83.269311);
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('selected_location'),
          position: _currentPosition!,
          infoWindow: InfoWindow(title: 'Selected Address'),
        ),
      );
    });
  }


  Future<void> _goToCurrentLocation() async {
    if (_isLoadingLocation) return;
    
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showLocationServiceDialog();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      if (permission == LocationPermission.deniedForever) {
        _showPermissionDialog();
        return;
      }
      
      if (permission == LocationPermission.denied) {
        _showSnackBar('Location permission is required');
        return;
      }

      Position position = await Geolocator.getCurrentPosition();

      _currentPosition = LatLng(position.latitude, position.longitude);
      
      setState(() {
        _markers.clear();
        _markers.add(
          Marker(
            markerId: MarkerId('current_location'),
            position: _currentPosition!,
            infoWindow: InfoWindow(title: 'Current Location'),
          ),
        );
      });

      final GoogleMapController controller = await _controller.future;
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _currentPosition!,
            zoom: 16.0,
          ),
        ),
      );

      await _getAddressFromCoordinates(_currentPosition!);
      
    } catch (e) {
      _showSnackBar('Failed to get current location: ${e.toString()}');
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  Future<void> _getAddressFromCoordinates(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        String address = '';
        
        if (place.street != null && place.street!.isNotEmpty) {
          address += place.street!;
        }
        if (place.subLocality != null && place.subLocality!.isNotEmpty) {
          address += address.isEmpty ? place.subLocality! : ', ${place.subLocality}';
        }
        if (place.locality != null && place.locality!.isNotEmpty) {
          address += address.isEmpty ? place.locality! : ', ${place.locality}';
        }
        if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
          address += address.isEmpty ? place.administrativeArea! : ', ${place.administrativeArea}';
        }
        if (place.postalCode != null && place.postalCode!.isNotEmpty) {
          address += address.isEmpty ? place.postalCode! : ' ${place.postalCode}';
        }
        
        setState(() {
          _addressDetailsController.text = address;
        });
      }
    } catch (e) {
      print('Error getting address: $e');
    }
  }

  void _onMapTapped(LatLng position) {
    setState(() {
      _currentPosition = position;
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId('selected_location'),
          position: position,
          infoWindow: InfoWindow(title: 'Selected Location'),
        ),
      );
    });
    
    _getAddressFromCoordinates(position);
  }

  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Services Disabled'),
          content: Text('Please enable location services to use this feature.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Geolocator.openLocationSettings();
              },
              child: Text('Settings'),
            ),
          ],
        );
      },
    );
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Permission Required'),
          content: Text('Please grant location permission in app settings.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Geolocator.openAppSettings();
              },
              child: Text('Settings'),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _addAddress() async {
    if (_nameAddressController.text.trim().isEmpty) {
      _showSnackBar('Please enter an address name');
      return;
    }
    
    if (_addressDetailsController.text.trim().isEmpty) {
      _showSnackBar('Please enter address details');
      return;
    }
    
    if (_currentPosition == null) {
      _showSnackBar('Please select a location on the map');
      return;
    }
    
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
    context.read<ShippingAddressBloc>().add(ChangeHomeAddress(Address: _addressDetailsController.text.trim()));
    await SharedpreferancesHelper.setAddress(_addressDetailsController.text.trim());
    
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Add New Address',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.my_location, color: Colors.black),
            onPressed: _goToCurrentLocation,
          ),
        ],
      ),
      body: Column(
        children: [
          // Map Section
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _kInitialPosition,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  markers: _markers,
                  onTap: _onMapTapped,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                ),
              ),
            ),
          ),
          
          // Address Details Section
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Address Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Name Address
                  Text(
                    'Name Address',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: TextField(
                      controller: _nameAddressController,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'Enter address name',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Address Details
                  Text(
                    'Address Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: TextField(
                      controller: _addressDetailsController,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'Enter full address',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        suffixIcon: Icon(Icons.location_on_outlined, color: Colors.grey),
                      ),
                      maxLines: 2,
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  Spacer(),
                  
                  // Add Button
                  Container(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _addAddress,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(27),
                        ),
                      ),
                      child: Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}