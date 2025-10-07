# Password Reset Debugging Guide

## Issue
After resetting password via OTP flow, neither the old password nor the new password works for login.

## Debugging Steps Added

### 1. Password Reset Flow Logging

Added comprehensive logging at multiple levels:

#### A. Set New Password Screen
- Logs the email, OTP, and password being submitted
- Shows both original and trimmed password values
- Added `.trim()` to all inputs to remove whitespace

**Location:** `set_new_password_screen.dart` - `_submit()` method

#### B. Auth Controller
- Logs all parameters being sent to the API
- Shows password length
- Displays the complete request JSON

**Location:** `auth_controller.dart` - `setNewPass()` method

#### C. Request Model
- Logs the JSON structure being created
- Confirms all fields are present

**Location:** `otp_request_model.dart` - `toJson()` method

#### D. Repository Layer
- Logs the exact API endpoint being called
- Shows the complete request data

**Location:** `auth_repo_impl.dart` - `otpVerify()` method

### 2. Login Flow Logging

Added logging to login to verify what credentials are being used:
- Email
- Password
- Password length

**Location:** `auth_controller.dart` - `login()` method

## How to Debug

### Step 1: Test Password Reset
1. Go through the password reset flow
2. Watch the console output for all the debug logs
3. Verify the following:
   - Email is correct (no extra spaces)
   - OTP is 6 digits
   - New password matches what you typed
   - Password length is correct
   - API endpoint is `/user/verify-reset-otp`
   - Request JSON contains: `email`, `otp`, and `newPassword`

### Step 2: Test Login
1. After resetting password, go to login screen
2. Enter the NEW password you just set
3. Watch console for login debug logs
4. Verify:
   - Email matches exactly (same casing, no spaces)
   - Password matches exactly what you entered during reset
   - Password length is the same

### Step 3: Compare Values
Compare the password logged during reset with the password logged during login.
They should match EXACTLY.

## Potential Issues to Check

### Issue 1: Whitespace
**Problem:** Extra spaces before/after email or password
**Solution:** Added `.trim()` to all inputs

### Issue 2: API Endpoint
**Problem:** Wrong endpoint being called
**Check:** Console should show `/user/verify-reset-otp`

### Issue 3: Request Body
**Problem:** API expects different field names
**Check:** Console should show JSON with `email`, `otp`, `newPassword`

### Issue 4: Password Not Being Sent
**Problem:** `newPassword` might be null or empty
**Check:** Console should show the password value and non-zero length

### Issue 5: API Response
**Problem:** API returns success but doesn't actually save the password
**Check:** Look at the API response in logs
**Action:** Verify with backend that password was actually updated in database

## API Documentation vs Implementation

### Documentation Says:
```
POST /user/verify-reset-otp
Body: { "email": "..." }
Response: { "success": true, "message": "Password reset successfully" }
```

### Our Implementation Sends:
```
POST /user/verify-reset-otp
Body: {
  "email": "...",
  "otp": "...",
  "newPassword": "..."
}
```

**Note:** The documentation appears incomplete. Backend confirmed it's not their problem, which suggests the API actually DOES accept `otp` and `newPassword` parameters even though they're not documented.

## Next Steps

1. **Run the app** and go through password reset flow
2. **Check console logs** for all the debug output
3. **Save the logs** showing:
   - What was sent during password reset
   - What was sent during login attempt
4. **Compare values** to identify any discrepancies
5. **If values match but login still fails:**
   - Contact backend developer with the logs
   - Ask them to verify if the password was actually updated in the database
   - Check if there's any password hashing/encoding issue

## Test Credentials Format

### During Password Reset:
```
Email: test@example.com
OTP: 123456
New Password: MyNewPass123!
```

### During Login:
```
Email: test@example.com
Password: MyNewPass123!
```

**Must match exactly** - same casing, same characters, no extra spaces.

## Backend Verification Steps

Ask backend developer to check:
1. Is the `/user/verify-reset-otp` endpoint receiving all three parameters?
2. Is the password being hashed/encrypted before storage?
3. Is the same hashing algorithm used during password reset and login?
4. Does the database show the updated password hash after reset?
5. Are there any middleware or validators modifying the password value?

## Common Solutions

### Solution 1: Clear Browser/App Cache
Sometimes cached data can interfere. Try:
- Flutter hot restart
- Clear app data
- Uninstall and reinstall

### Solution 2: Verify API Endpoint
Ensure the API endpoint is correct:
- Current: `/user/verify-reset-otp`
- Check if it should be different for setting password vs verifying OTP

### Solution 3: Two-Step Process
Consider if the API requires two separate calls:
1. Verify OTP: `POST /user/verify-reset-otp` with `{email, otp}`
2. Set Password: `POST /user/change-password` or similar

### Solution 4: Check Password Validation
Ensure the password meets all requirements:
- Minimum 8 characters (currently enforced)
- May need: uppercase, lowercase, number, special character
- Check if backend has additional requirements not shown in UI
