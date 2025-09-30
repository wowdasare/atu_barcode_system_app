# API Testing and Debugging Guide

## 🔧 Fixed API Issues

### Key Problems Resolved:
1. **Session Start**: Fixed parameter mismatch (`course_id` → `course`)
2. **Attendance Recording**: Fixed parameter mismatch (`barcode_data` → `barcode_id`)
3. **Session IDs**: Changed from `int` to `String` to support UUIDs
4. **End Session**: Added robust error handling and offline fallback
5. **JSON Parsing**: Enhanced to handle various API response formats

## 🧪 Testing Your API Integration

### Method 1: Console Logs (Automatic)
The app now logs all API requests and responses automatically:

```dart
// You'll see logs like this in the console:
🎯 Starting session with data: {course: 1, session_name: Test Session, location: Room 101}
📡 URL: https://web-production-d4903.up.railway.app/api/sessions/start/
✅ Start session response status: 201
📝 Start session response data: {...}
```

### Method 2: API Test Helper (Manual)
Add this code to test all endpoints at once:

```dart
import 'package:your_app/utils/api_test_helper.dart';

// In your app somewhere (like a debug button):
await ApiTestHelper().testAllEndpoints(
  testUsername: 'your_test_lecturer_username',
  testPassword: 'your_test_password',
);

// Or test basic connectivity:
await ApiTestHelper().testConnectivity();
```

## 🔍 Debugging Steps

### 1. Check Network Connectivity
```dart
await ApiTestHelper().testConnectivity();
```

### 2. Verify API Endpoints
```dart
await ApiTestHelper().debugEndpointUrls();
```

### 3. Test Complete Flow
```dart
await ApiTestHelper().testAllEndpoints();
```

## 📋 API Endpoint Mapping

| Flutter App | Django API |
|-------------|------------|
| `ApiService.login()` | `POST /api/auth/login/` |
| `ApiService.getCourses()` | `GET /api/courses/` |
| `ApiService.startSession()` | `POST /api/sessions/start/` |
| `ApiService.recordAttendance()` | `POST /api/attendance/record/` |
| `ApiService.getSessionAttendance()` | `GET /api/attendance/session/{id}/` |
| `ApiService.endSession()` | `POST /api/sessions/{id}/end/` |

## 🎯 Expected API Request Formats

### Start Session
```json
POST /api/sessions/start/
{
  "course": 1,
  "session_name": "Monday Morning Lecture",
  "location": "Room 101"
}
```

### Record Attendance  
```json
POST /api/attendance/record/
{
  "session_id": "uuid-string",
  "barcode_id": "scanned_barcode_value"
}
```

### End Session
```json
POST /api/sessions/{session_id}/end/
(No body required)
```

## 🛠️ Common Issues & Solutions

### Issue: "Sessions not showing on dashboard"
- **Check**: Course API response format
- **Solution**: App now handles various response formats (array, object with 'courses', 'data', 'results' keys)

### Issue: "End session doesn't work" 
- **Check**: Session ID format (should be string/UUID)
- **Solution**: App now gracefully handles API failures and ends session locally

### Issue: "Attendance not recording"
- **Check**: Parameter names (`barcode_id` not `barcode_data`)
- **Solution**: Fixed parameter mapping in API calls

## 📱 App Features

### Offline Fallback
- App creates mock sessions when API is unavailable
- Attendance records are stored locally
- Sessions can always be ended (locally if API fails)

### Responsive Design
- UI adapts to different screen sizes (Google Pixel 4 XL optimized)
- Touch targets scale appropriately
- Text sizes adapt to screen density

### Debug Information
- All API calls are logged with request/response data
- Error messages provide specific failure reasons
- Network status is indicated in the UI

## 🚀 Next Steps

1. **Deploy your Django API** to Railway/Heroku with CORS enabled
2. **Update** `lib/constants/api_constants.dart` with your actual API URL
3. **Test login** with real lecturer credentials  
4. **Start a session** and check console logs for API communication
5. **Try scanning** QR codes to record attendance

The app is now properly configured to work with your Django API endpoints!