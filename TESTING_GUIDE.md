# Quick Testing Guide - Resume Upload

## 🎯 Test Scenarios

### Test 1: Validation Error - Missing First Name
1. Open the elevator resume screen
2. Clear the first name field (if populated)
3. Fill all other required fields (surname, country, city, email, education)
4. Click "Submit Resume"
5. ✅ Expected: Red snackbar shows "First name is required"
6. 📋 Check console: "Validation Error: First name is required"

### Test 2: Validation Error - No Education
1. Remove all education entries (click delete on any that exist)
2. Fill all other required fields
3. Click "Submit Resume"
4. ✅ Expected: Red snackbar shows "At least one education entry is required"
5. 📋 Check console: Validation error logged

### Test 3: Successful Upload
1. Fill all required fields:
   - First Name: "John"
   - Surname: "Doe"
   - Country: "United States"
   - City: "New York"
   - Email: (auto-filled)
   - Education: At least one entry
2. (Optional) Upload video, banner, photo
3. Click "Submit Resume"
4. ✅ Expected: Button changes to loading spinner with "Uploading Resume..."
5. ✅ Check console logs:
   ```
   ========== RESUME UPLOAD STARTED =========
   Validation passed, proceeding with resume save
   Starting resume upload...
   User ID: ..., Email: ...
   API URL: http://10.10.5.59:8001/api/v1/create-resume/create-resume
   Sending multipart request to API...
   Response received. Status code: 200
   SUCCESS: Resume created successfully!
   ========== RESUME UPLOAD COMPLETED =========
   ```
6. ✅ Green snackbar shows "Resume created successfully!"
7. ✅ Screen navigates back after 1 second

### Test 4: Video Status Indicator
1. Without video: Orange "ℹ️" icon + "Elevator pitch video upload is optional..."
2. After uploading video: Green "✓" icon + "Elevator pitch video uploaded..."
3. Video is optional - can submit without it

### Test 5: Network Error / Timeout
1. Turn off internet connection
2. Fill all required fields
3. Click "Submit Resume"
4. ✅ Wait 30 seconds
5. ✅ Expected: Orange snackbar shows "Upload took too long. Please check your connection and try again."
6. 📋 Check console: "TIMEOUT ERROR: Resume upload request timed out"

### Test 6: API Error Response
1. (If API returns error) Fill form and submit
2. ✅ Expected: Red snackbar shows API error message from server
3. 📋 Check console: "ERROR Response: [error message]"

### Test 7: Prevent Duplicate Submissions
1. Fill form with all required fields
2. Click "Submit Resume"
3. Immediately click again while uploading
4. ✅ Expected: Button stays disabled, no duplicate request sent
5. 📋 Check console: "Upload already in progress"

---

## 🔍 Debug Console Output Examples

### Successful Upload:
```
========== RESUME UPLOAD STARTED =========
Validation passed, proceeding with resume save
Starting resume upload...
User ID: 693644a7b87c01f2ea4c7deb, Email: soykotrahn121212@gmail.com
About me text length: 245
Preparing resume data...
API URL: http://10.10.5.59:8001/api/v1/create-resume/create-resume
Resume data added to request
  - Resume: [type, firstName, lastName, email, country, city, immediatelyAvailable, about, certifications, languages, skills, sLink]
  - Experiences count: 0
  - Education count: 1
  - Awards count: 0
Adding photo file: /data/user/0/com.pooelcentral.karlfive/cache/photo.jpg
Adding banner file: /data/user/0/com.pooelcentral.karlfive/cache/banner.jpg
Files added. Sending request...
Sending multipart request to API...
Response received. Status code: 201
Response body: {"success":true,"message":"Resume created successfully!"}
SUCCESS: Resume created successfully!
========== RESUME UPLOAD COMPLETED =========
```

### Validation Error:
```
========== RESUME UPLOAD STARTED =========
Validation Error: First name is required
```

### Timeout Error:
```
TIMEOUT ERROR: Resume upload request timed out
```

### API Error:
```
Response received. Status code: 400
Response body: {"success":false,"message":"Education institution is required"}
ERROR Response: Education institution is required
```

---

## 🛠️ Known Features

✅ **Auto-populated Fields:**
- Email (from user profile)
- First Name, Surname, Phone (from profile if available)

✅ **Dynamic Features:**
- Searchable dropdowns for Countries, Cities, Languages
- Banner image instant preview
- Video player with full controls
- About me word counter

✅ **Data Validation:**
- All required fields checked
- Empty education entries not sent
- Empty social media links not sent

✅ **File Uploads:**
- Photo upload (optional)
- Banner upload (optional)
- Video upload (optional, separate process)

✅ **Error Handling:**
- Validation errors with clear messages
- Network timeouts (30-second limit)
- API error messages from server
- Exception logging with full details

---

## 📊 Button States

| State | Icon | Text | Action |
|-------|------|------|--------|
| Ready | None | "Submit Resume" | Clickable |
| Uploading | Spinner | "Uploading Resume..." | Disabled (grey) |
| Complete | (None) | "Submit Resume" | Back to clickable |

---

## 🚨 Troubleshooting

| Issue | Solution |
|-------|----------|
| Validation error not showing | Check console for error message, ensure required fields filled |
| Button not enabling after upload | Wait 2-3 seconds, refresh if needed |
| API not responding | Check network connection, verify API URL |
| File uploads failing | Ensure files exist at path, check permissions |
| Resume not created despite success message | Check API server logs for actual creation |

---

## 📝 API Endpoint

**URL:** `http://10.10.5.59:8001/api/v1/create-resume/create-resume`
**Method:** POST
**Content-Type:** multipart/form-data

### Fields Sent:
- `userId` - User ID
- `resume` - JSON object with personal info
- `experiences` - JSON array of work experiences
- `educationList` - JSON array of education
- `awardsAndHonors` - JSON array of awards
- `photo` - Image file (optional)
- `banner` - Image file (optional)

### Success Response:
```json
{
  "success": true,
  "message": "Resume created successfully!"
}
```

### Error Response:
```json
{
  "success": false,
  "message": "Error description"
}
```

---

## 💡 Tips for Testing

1. **Always check the debug console** - All details are logged there
2. **Test with all optional fields** - Photo, banner, video, social links
3. **Test with minimal data** - Just required fields to verify it works
4. **Test error cases** - Missing fields, network down, etc.
5. **Watch the loading indicator** - Provides visual feedback of progress
6. **Note the timestamps** - Console logs show exactly when things happen

---

Generated: 2025-12-20
Last Updated: Complete refactor with dynamic button, validation, and error handling
