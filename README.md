# ATU Barcode Attendance System

A complete Flutter mobile application for barcode-based attendance tracking system designed for lecturers to efficiently manage student attendance using mobile devices.

## 🚀 Features

### Core Functionality
- **User Authentication**: Secure login system with token-based authentication
- **Course Management**: View and manage assigned courses
- **Attendance Sessions**: Start, manage, and end attendance sessions
- **Barcode Scanning**: Camera-based barcode/QR code scanning using MobileScanner
- **Real-time Tracking**: Live attendance list with real-time updates
- **Session Management**: Complete session lifecycle management
- **Offline Capability**: Local storage for offline functionality

### Screens
1. **Splash Screen**: Animated startup screen with app branding
2. **Login Screen**: Secure authentication with Material Design
3. **Dashboard**: Course overview and session management
4. **Session Creation**: Configure new attendance sessions
5. **Barcode Scanner**: Camera-based scanning interface
6. **Live Session View**: Real-time attendance monitoring
7. **Session Completion**: Summary and statistics

## 📱 Technical Specifications

### Dependencies
- **mobile_scanner**: ^4.0.1 - Camera-based barcode scanning
- **dio**: ^5.4.0 - HTTP client for API requests
- **flutter_secure_storage**: ^9.0.0 - Secure token storage
- **provider**: ^6.1.1 - State management
- **permission_handler**: ^11.2.0 - Camera permissions
- **shared_preferences**: ^2.2.2 - Local data storage

### Architecture
- **State Management**: Provider pattern for reactive UI updates
- **API Integration**: RESTful API with Django backend
- **Authentication**: Token-based security with secure storage
- **Navigation**: Material Design navigation patterns
- **Error Handling**: Comprehensive error management and user feedback

## 🔧 Setup & Installation

### Prerequisites
- Flutter SDK 3.0+
- Dart 3.0+
- Android SDK (for Android development)
- Xcode (for iOS development)

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd atu_barcode_system
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API endpoints**
   - Update `lib/constants/api_constants.dart` with your backend URL
   - Default: `https://web-production-d4903.up.railway.app`

4. **Run the application**
   ```bash
   flutter run
   ```

## 📝 API Integration

### Backend Requirements
The app expects a Django REST API with the following endpoints:

- `POST /api/auth/login/` - User authentication
- `GET /api/courses/` - Fetch lecturer's courses
- `POST /api/sessions/start/` - Start attendance session
- `POST /api/attendance/record/` - Record student attendance
- `GET /api/attendance/session/{id}/` - Get session attendance
- `POST /api/sessions/{id}/end/` - End attendance session

### Authentication Headers
All API requests include:
```
Authorization: Token {your_auth_token}
Content-Type: application/json
```

## 🔐 Security Features

- **Secure Storage**: Authentication tokens stored using FlutterSecureStorage
- **Permission Management**: Proper camera permission handling
- **Input Validation**: Comprehensive form validation
- **Error Handling**: Secure error messages without data exposure

## 📸 Barcode Scanning

### Supported Formats
- Code 128
- QR Code
- EAN-13
- EAN-8
- Code 39
- Code 93
- Data Matrix
- PDF417

### Scanner Features
- **Real-time Detection**: Instant barcode recognition
- **Duplicate Prevention**: Prevents multiple scans of same barcode
- **Camera Controls**: Flash toggle and camera switching
- **Visual Feedback**: Scanning overlay and success indicators
- **Auto-focus**: Automatic camera focus adjustment

## 🎨 Design System

### Material Design 3
- **Color Scheme**: Custom ATU branding colors
- **Typography**: Roboto font family
- **Components**: Material Design 3 components
- **Accessibility**: WCAG compliant contrast ratios
- **Responsive**: Adaptive layouts for different screen sizes

### Theme Colors
- **Primary**: #1976D2 (Blue)
- **Secondary**: #03DAC6 (Teal)
- **Success**: #4CAF50 (Green)
- **Warning**: #FF9800 (Orange)
- **Error**: #B00020 (Red)

## 📱 Permissions

### Android
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.FLASHLIGHT" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

### iOS
Camera permission is handled automatically by the permission_handler package.

## 🧪 Testing

### Mock Data
The app includes mock data service for development and testing:
- Sample courses and students
- Simulated API responses
- Offline functionality testing

### Running Tests
```bash
flutter test
```

## 📂 Project Structure

```
lib/
├── constants/          # App constants and configurations
├── models/            # Data models
├── providers/         # State management providers
├── screens/           # UI screens
├── services/          # API and business logic services
├── utils/            # Utility functions
└── widgets/          # Reusable UI components
```

## 🚀 Deployment

### Android APK
```bash
flutter build apk --release
```

### iOS App Store
```bash
flutter build ios --release
```

## 🔄 Development Mode

The app currently uses mock data for development. To enable real API integration:

1. Update API endpoints in `api_constants.dart`
2. Uncomment API calls in providers
3. Remove mock data usage

## 📋 Features Checklist

- ✅ User authentication with secure token storage
- ✅ Course dashboard with Material Design
- ✅ Attendance session management
- ✅ Camera-based barcode scanning
- ✅ Real-time attendance tracking
- ✅ Session completion with statistics
- ✅ Offline capability with local storage
- ✅ Comprehensive error handling
- ✅ Material Design 3 theming
- ✅ Responsive design
- ✅ Permission handling
- ✅ Mock data for development

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

This project is developed for ATU (Accra Technical University) as an HND final year project.

## 👥 Support

For technical support or questions:
- Create an issue in the repository
- Contact the development team

## 🔮 Future Enhancements

- Student mobile app for self-check-in
- Analytics and reporting dashboard
- Export functionality (CSV, PDF)
- Multi-language support
- Push notifications
- Facial recognition integration
- Attendance statistics and insights

---

**Built with ❤️ using Flutter for ATU Barcode Attendance System**
