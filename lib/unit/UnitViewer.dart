import 'package:crem_flutter/auth/AuthService.dart';
import 'package:crem_flutter/project/ProjectService.dart';
import 'package:crem_flutter/util/APIUrls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:panorama_viewer/panorama_viewer.dart';
import 'package:permission_handler/permission_handler.dart';

import '../user/User.dart';
import '../util/ApiResponse.dart';
import 'model/Unit.dart';

class UnitViewer extends StatefulWidget {
  final Unit unit;

  UnitViewer({required this.unit});

  @override
  _UnitViewerState createState() => _UnitViewerState();
}

class _UnitViewerState extends State<UnitViewer> {
  final _picker = ImagePicker();
  late bool _shouldShowUpdateButton = false;

  @override
  void initState() {
    super.initState();

    shouldShowUpdateButton();
  }

  shouldShowUpdateButton() async {
    Role? role = await AuthService.getRole();
    if (role == Role.ADMIN || role == Role.MANAGER) {
      setState(() {
        _shouldShowUpdateButton = true;
      });
    } else {
      setState(() {
        _shouldShowUpdateButton = false;
      });
    }
  }

  Future<void> _requestCameraPermission() async {
    PermissionStatus status = await Permission.camera.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Camera permission is required")),
      );
      return;
    }
  }

  Future<void> _capturePanorama() async {
    await _requestCameraPermission();

    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        // Update the UI or store the image path if needed
        setState(() {
          //_imageUrl = image.path;
        });

        // Create a MultipartFile from the captured image
        final file =
            await MultipartFile.fromFile(image.path, filename: 'panorama.jpg');

        // Send the image to the server using the updateUnitImage method
        final ApiResponse response =
            await ProjectService().updateUnitImage(file, widget.unit.id!);

        // Handle the server response
        if (response.successful) {
          // Successfully uploaded image, update UI or handle response
          print("Image uploaded successfully!");
        } else {
          // Handle error from server response
          print("Failed to upload image: ${response.message}");
        }
      }
    } on PlatformException catch (e) {
      print("Error capturing image: $e");
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Unit Viewer"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: widget.unit.image != null ?
              PanoramaViewer(
                child: Image.network(
                  APIUrls.unitImages + widget.unit.image!,
                  fit: BoxFit.cover,
                ),
              ) : Center(child: Text('No Image Found'),),
            ),
            if (_shouldShowUpdateButton)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _capturePanorama,
                  child: Text('Capture'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
