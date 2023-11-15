// ignore_for_file: prefer_const_declarations, avoid_print, non_constant_identifier_names, prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:nutriscan/components/constants.dart';
import 'package:nutriscan/screens/apiResponsePage.dart';

import 'package:nutriscan/screens/your_prefrence.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:lottie/lottie.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class ObjectDetectionResult {
  final String label;
  final double confidence;
  final Rect boundingBox;

  ObjectDetectionResult(this.label, this.confidence, this.boundingBox);
}

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<ObjectDetectionResult> detectionResults = [];
  // List<HistoryItem> history = [];
  bool isLoading = true;
  double imageWidth = 512; // Replace with your image width
  double imageHeight = 512; // Replace with your image height
  late Size imageSize;
  List<String> labels = [];
  late Interpreter interpreter;
  File? selectedImageFile;
  bool showresponse = false;
  var Results;

  @override
  void initState() {
    super.initState();
    imageSize = Size(imageWidth, imageHeight);
    loadModelAndInfer();
  }

  Future<void> loadModelAndInfer() async {
    final modelPath =
        'assets/model/nutriscan_model.tflite'; // Change to your model path

    try {
      interpreter = await Interpreter.fromAsset(modelPath);
      interpreter.allocateTensors();

      labels = await loadLabels();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  Future<List<String>> loadLabels() async {
    final labelsPath = 'assets/model/labels.txt'; // Change to your labels path
    final labelsFile = await rootBundle.loadString(labelsPath);
    return labelsFile.split('\n').where((label) => label.isNotEmpty).toList();
  }

  Future<List<ObjectDetectionResult>> runInference(
    Interpreter interpreter,
    Uint8List imageBytes,
  ) async {
    final List<ObjectDetectionResult> detectionlist = [];

    try {
      final img.Image imgData = img.decodeImage(imageBytes)!;

      // Preprocess the image
      final Uint8List inputBytes = preprocessImage(imgData);

      // Run inference
      final inputs = [inputBytes];

      // Define output tensors
      final o1 =
          List.generate(1, (_) => List.filled(100, 0.0)); // shape [1, 100]
      final outputBoxes = List.generate(
          1,
          (_) => List.generate(
              100, (_) => List.filled(4, 0.0))); // shape [1, 100, 4]
      final outputClasses =
          List.generate(1, (_) => List.filled(100, 0.0)); // shape [1, 100]
      final o4 = List.generate(
          1,
          (_) => List.generate(
              100, (_) => List.filled(2, 0.0))); // shape [1, 100, 2]
      final outputConfidences =
          List.generate(1, (_) => List.filled(100, 0.0)); // shape [1, 100]
      final o6 = List.filled(1, 0.0); // shape [1, 1]
      final o7 = List.generate(
          1,
          (_) => List.generate(
              49104, (_) => List.filled(4, 0.0))); // shape [1, 49104, 4]
      final o8 = List.generate(
          1,
          (_) => List.generate(
              49104, (_) => List.filled(2, 0.0))); // shape [1, 49104, 2]

      final outputs = <int, List<dynamic>>{
        0: o1,
        1: outputBoxes,
        2: outputClasses,
        3: o4,
        4: outputConfidences,
        5: o6,
        6: o7,
        7: o8,
      };

      interpreter.runForMultipleInputs(inputs, outputs);
      // Process the detection results based on the output tensors
      for (int i = 0; i < outputConfidences[0].length; i++) {
        final Confidence = outputConfidences[0][i];
        if (Confidence >= 0.4) {
          final classIndex = outputClasses[0][i].toInt();
          final List<double> boxData = List<double>.from(outputBoxes[0][i]);

          final Rect boundingBox = Rect.fromLTRB(
            boxData[1] * imageSize.width,
            boxData[0] * imageSize.height,
            boxData[3] * imageSize.width,
            boxData[2] * imageSize.height,
          );

          final label = labels[classIndex - 1];
          final detectionResult =
              ObjectDetectionResult(label, Confidence, boundingBox);
          detectionlist.add(detectionResult);
        }
      }
    } catch (e) {
      print('Error running inference: $e');
    }

    return detectionlist;
  }

  Uint8List preprocessImage(img.Image image) {
    final int inputWidth = 512;
    final int inputHeight = 512;

    final img.Image resizedImg = img.copyResize(
      image,
      width: inputWidth,
      height: inputHeight,
    );

    final Uint8List inputBytes = Uint8List(
      inputWidth * inputHeight * 3,
    );

    int byteIndex = 0;

    for (int y = 0; y < inputHeight; y++) {
      for (int x = 0; x < inputWidth; x++) {
        final pixel = resizedImg.getPixel(x, y);
        inputBytes[byteIndex++] = img.getRed(pixel);
        inputBytes[byteIndex++] = img.getGreen(pixel);
        inputBytes[byteIndex++] = img.getBlue(pixel);
      }
    }

    return inputBytes;
  }

  Future<Map<String, dynamic>> cropAndPassToAPI(
      List<ObjectDetectionResult> detection, File originalImageFile) async {
    // Read the original image
    Map<String, dynamic> encodedImageList = {
      'ingredients': null, // Initialize as null
      'nutrition_table': null, // Initialize as null
    };

    final Uint8List imageBytes =
        Uint8List.fromList(originalImageFile.readAsBytesSync());
    final img.Image? originalImage = img.decodeImage(imageBytes);
    print('Image bytes length: ${imageBytes.length}');

    Map<String, dynamic> results = {
      'responseJsonNutri': null,
      'responseJsonIngredients': null,
    };
    if (originalImage != null) {
      // Calculate scaling factors based on the original image dimensions
      final double scaleX = originalImage.width / imageSize.width;
      final double scaleY = originalImage.height / imageSize.height;
      // Adjust the bounding box coordinates to the original image dimensions
      for (int index = 0; index < detection.length; index++) {
        final i = detection[index];
        print(i);
        print(i.label);
        int left = (i.boundingBox.left * scaleX).toInt();
        int top = (i.boundingBox.top * scaleY).toInt();
        int width = (i.boundingBox.width * scaleX).toInt();
        int height = (i.boundingBox.height * scaleY).toInt();

        // Ensure the coordinates are within the image boundaries
        if (left < 0) left = 0;
        if (top < 0) top = 0;
        if (left + width > originalImage.width) {
          width = originalImage.width - left;
        }
        if (top + height > originalImage.height) {
          height = originalImage.height - top;
        }

        // Crop the image based on the adjusted coordinates
        img.Image croppedImage =
            img.copyCrop(originalImage, left, top, width, height);
        var encodedImage = Uint8List.fromList(img.encodeJpg(croppedImage));
        print(encodedImage);
        if (i.label == 'nutrition table') {
          encodedImageList['nutrition_table'] = encodedImage;
          print("nutri");
          print(encodedImage);
        } else {
          encodedImageList['ingredients'] = encodedImage;
          print("ingredients");
          print(encodedImage);
        }
      }
      final selectedChoices =
          Provider.of<ChoiceModel>(context, listen: false).getSelectedChoices();
      final uri_ingredients =
          Uri.parse("http://3.110.183.6/upload/ingredients");
      if (encodedImageList['ingredients'] != null) {
        // Replace with your API URL
        final request_ingredients =
            http.MultipartRequest('POST', uri_ingredients);
        final imagePart = http.MultipartFile.fromBytes(
            'file', encodedImageList['ingredients'],
            filename: 'image.jpg');
        request_ingredients.files.add(imagePart);

        // Add form parameters to the request
        request_ingredients.fields['milk'] =
            (selectedChoices['Without Milk'] ?? 0).toString();
        request_ingredients.fields['nuts'] =
            (selectedChoices['Without Peanuts'] ?? 0).toString();
        request_ingredients.fields['soy'] =
            (selectedChoices['Without Soy'] ?? 0).toString();
        request_ingredients.fields['gluten'] =
            (selectedChoices['Without Gluten'] ?? 0).toString();
        request_ingredients.fields['palm_oil'] =
            (selectedChoices['Palm Oil free'] ?? 0).toString();
        request_ingredients.fields['onion_and_garlic'] =
            (selectedChoices['Without onion garlic'] ?? 0).toString();

        // Send the request
        final response_ingredients = await request_ingredients.send();

        // Handle the response, e.g., check for success and errors
        if (response_ingredients.statusCode == 200) {
          print('Image uploaded successfully');
          final responseJson =
              await response_ingredients.stream.bytesToString();
          results['responseJsonIngredients'] = json.decode(responseJson);
          print(results['responseJsonIngredients']);
          print('Image uploaded successfully');
        } else {
          print('Error uploading image: ${response_ingredients.reasonPhrase}');
        }
      } else {
        results['responseJsonIngredients'] = null;
      }
      if (encodedImageList['nutrition_table'] != null) {
        final uri_nutri = Uri.parse(
            "http://3.110.183.6/upload/nutritiontable"); // Replace with your API URL
        final request_nutri = http.MultipartRequest('POST', uri_nutri);
        final imagePart_nutri = http.MultipartFile.fromBytes(
            'file', encodedImageList['nutrition_table'],
            filename: 'image.jpg');
        request_nutri.files.add(imagePart_nutri);

        // Add form parameters to the request
        request_nutri.fields['salt'] =
            (selectedChoices['Salt in low quantity'] ?? 0).toString();
        request_nutri.fields['sugar'] =
            (selectedChoices['Sugar in low quantity'] ?? 0).toString();
        request_nutri.fields['total_fat'] =
            (selectedChoices['Fat in low quantity'] ?? 0).toString();
        request_nutri.fields['sat_fat'] =
            (selectedChoices['Saturated fat in low quantity'] ?? 0).toString();

        // Send the request
        final response_nutri = await request_nutri.send();

        // Handle the response, e.g., check for success and errors
        if (response_nutri.statusCode == 200) {
          print('Image uploaded successfully');
          final responseJson = await response_nutri.stream.bytesToString();
          results['responseJsonNutri'] = json.decode(responseJson);
          print(results['responseJsonNutri']);
        } else {
          print('Error uploading image: ${response_nutri.reasonPhrase}');
        }
      } else {
        results['responseJsonNutri'] = null;
      }
    }
    return results;
  }

// Function to pick an image from the gallery/ camera
  Future _imageFromDevice(ImageSource source) async {
    setState(() {
      isLoading = true;
    });
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      final File pickedFile = File(pickedImage.path);
      File rotatedImage =
          await FlutterExifRotation.rotateImage(path: pickedImage.path);
      final image = img.decodeImage(await rotatedImage.readAsBytes());

      if (image != null) {
        final resizedImage = img.copyResize(image, width: 512, height: 512);
        final resizedBytes = Uint8List.fromList(img.encodeJpg(resizedImage));
        final results = await runInference(interpreter, resizedBytes);

        setState(() {
          detectionResults = results;
          selectedImageFile = pickedFile;

          isLoading = false;
        });
        Results = await cropAndPassToAPI(detectionResults, selectedImageFile!);
        print('Image saved');
        setState(() {
          showresponse = true;
        });
        // final historyProvider =
        //     Provider.of<HistoryProvider>(context, listen: false);
        // File imageFile = selectedImageFile!;
        // Map<String, dynamic>? ingredientsJsonResponse =
        //     Results['responseJsonIngredients'];
        // Map<String, dynamic>? nutriJsonResponse = Results['responseJsonNutri'];

        // HistoryItem historyItem = HistoryItem(
        //     imageFile: imageFile,
        //     ingredientsJsonResponse: ingredientsJsonResponse,
        //     nutriJsonResponse: nutriJsonResponse);
        // historyProvider.addToHistory(historyItem);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: null,
        body: Center(
            child: Column(children: [
          SizedBox(
            height: 300,
          ),
          SizedBox(
            height: 200,
            width: 200,
            child: Lottie.asset("assets/images/loading3.json"),
          ),
          Text(
            "Your results are on the way !",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          )
        ])),
        floatingActionButton:
            showresponse // Check if we should show the response button
                ? null
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton(
                        onPressed: () => _imageFromDevice(ImageSource.gallery),
                        tooltip: 'Pick Image from Gallery',
                        child: Icon(Icons.photo_library),
                      ),
                      FloatingActionButton(
                        onPressed: () => _imageFromDevice(ImageSource.camera),
                        tooltip: 'Take a Picture',
                        child: Icon(Icons.camera_alt),
                      ),
                    ],
                  ),
      );
    } else {
      if (!showresponse) {
        return Scaffold(
          appBar: null,
          body: Center(
            child: Stack(
              children: <Widget>[
                if (selectedImageFile != null)
                  Positioned.fill(
                      child: Image.file(
                    selectedImageFile!,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.contain,
                  )),
                CustomPaint(
                  size: imageSize,
                  painter: BoundingBoxPainter(detectionResults, imageSize),
                ),
              ],
            ),
          ),
          floatingActionButton:
              showresponse // Check if we should show the response button
                  ? null
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FloatingActionButton(
                          onPressed: () =>
                              _imageFromDevice(ImageSource.gallery),
                          tooltip: 'Pick Image from Gallery',
                          child: Icon(Icons.photo_library),
                        ),
                        FloatingActionButton(
                          onPressed: () => _imageFromDevice(ImageSource.camera),
                          tooltip: 'Take a Picture',
                          child: Icon(Icons.camera_alt),
                        ),
                      ],
                    ),
        );
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => ApiResponsePage(
                    nutriJsonResponse: Results['responseJsonNutri'],
                    ingredientsJsonResponse: Results['responseJsonIngredients'],
                  )));
        });
        // Return an empty container as a placeholder
        return Container();
      }
    }
  }
}

class BoundingBoxPainter extends CustomPainter {
  final List<ObjectDetectionResult> detectionResults;
  final Size imageSize;

  BoundingBoxPainter(this.detectionResults, this.imageSize);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final double scaleX = size.width / imageSize.width;
    final double scaleY = size.height / imageSize.height;

    for (final detection in detectionResults) {
      final rect = Rect.fromLTRB(
        detection.boundingBox.left * scaleX,
        detection.boundingBox.top * scaleY,
        detection.boundingBox.right * scaleX,
        detection.boundingBox.bottom * scaleY,
      );

      // Draw bounding box
      paint.color = Colors.red;
      canvas.drawRect(rect, paint);

      // Draw label
      final textPainter = TextPainter(
        text: TextSpan(
          text:
              "${detection.label} (${(detection.confidence * 100).toStringAsFixed(2)}%)",
          style: TextStyle(fontSize: 16.0, color: Colors.red),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout(minWidth: 0, maxWidth: size.width);
      textPainter.paint(canvas, Offset(rect.left, rect.top - 16.0));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
