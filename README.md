# Flutter Document Scanner App

This is a Flutter application that allows users to scan documents using their mobile devices' camera, view the captured images, and generate a PDF document from the scanned images. The app supports both Android and iOS platforms.

## Features

- **Document Scanning**: Users can scan documents using the camera, and the images are displayed in the app.
- **Generate PDF**: Users can generate a PDF from the scanned images.
- **Cross-platform Support**: The app works on both Android and iOS devices.
- **User-Friendly Interface**: Easy-to-use interface for adding pictures and generating PDFs.

## Requirements

- Flutter 3.22.0 or later
- Dart SDK version `>=3.4.0 <4.0.0`
- iOS 13.0 or later (iOS platform configuration)

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/your-username/flutter-document-scanner.git
cd flutter-document-scanner
```

### 2. Install dependencies
Make sure you have Flutter installed on your machine. If not, follow the instructions on the Flutter website.

Run the following command to install the required dependencies:

```bash
flutter pub get
```

### 3. Configure iOS app for minimum version
In the ios/Podfile file, ensure the platform version is set to at least 13.0:

```ruby
platform :ios, '13.0'
```
### 4. Set up app icons
To set custom app icons, follow the instructions in the App Icon section above. You can use the flutter_launcher_icons package to generate the app icons for both Android and iOS platforms.

### 5. Permissions
Make sure the app has the required permissions for accessing the camera and photo library. In the ios/Runner/Info.plist, include the following entries:

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to your photo library to add scanned images.</string>
<key>NSCameraUsageDescription</key>
<string>We need access to your camera to scan documents.</string>
<key>NSMicrophoneUsageDescription</key>
<string>We need access to your microphone to record audio (if needed for videos).</string>
```

### 6. Build the app
To build the app for Android:

```bash
flutter build apk
``` 

To build the app for iOS:
```bash
flutter build ios
```

7. Run the app
Run the app on an emulator or a real device:
```bash
flutter run
```

Usage
Add Pictures: Tap on the "Add Pictures" button to scan documents using your device's camera.
Generate PDF: After adding pictures, tap on the "Generate PDF" button to generate a PDF of the scanned images.
View Scanned Images: The scanned images will be displayed on the screen after they are added.
Project Structure

```bash
flutter-document-scanner/
├── android/                    # Android project files
├── assets/                     # App assets (e.g., icons, images)
├── ios/                        # iOS project files
├── lib/                        # Flutter Dart code
│   ├── main.dart               # Entry point of the app
│   ├── screens/                # Screens of the app (e.g., HomeScreen)
│   └── services/               # Services (e.g., DocumentScannerService, PdfGeneratorService)
├── pubspec.yaml                # Project dependencies and configuration
└── README.md                   # This file
```

## Services

### 1. DocumentScannerService
This service is responsible for handling the document scanning functionality. It interfaces with the CunningDocumentScanner package to scan documents and return the image paths.

### 2. PdfGeneratorService
This service handles the PDF generation process. It uses the pdf package to generate a PDF document from the scanned images.

## Contributing
Feel free to fork this project and submit pull requests. Any improvements or fixes are welcome.

## License
This project is licensed under the MIT License - see the LICENSE file for details.