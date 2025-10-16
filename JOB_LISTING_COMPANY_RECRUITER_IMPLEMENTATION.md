# Job Listing Feature - Company & Recruiter Support Implementation

## Overview

Successfully implemented full support for displaying jobs posted by both **companies** and **recruiters** in the job listing feature. The system now properly handles different data structures for each type and displays appropriate logos and information.

## API Response Structure

### Company Posted Job

```json
{
    "_id": "68f02c5cd1c27ca9b24483a3",
    "userId": "68f0252fd1c27ca9b244827a",
    "companyId": {
        "_id": "68f02a15d1c27ca9b2448322",
        "clogo": "https://res.cloudinary.com/...",
        "cname": "Kaytech IT",
        "country": "Nigeria",
        "city": "Lagos"
        // ... other company fields
    },
    "title": "IT Audit Officer",
    "description": "<p>Job description HTML...</p>",
    "salaryRange": "₦ 500000",
    "location": "Nigeria, Abuja",
    "employement_Type": "full-time"
    // ... other job fields
}
```

### Recruiter Posted Job

```json
{
    "_id": "68efb50fd1c27ca9b2446f68",
    "userId": "68ee5cb5340f00c57e693a73",
    "recruiterId": {
        "_id": "68ee5e1e340f00c57e693acc",
        "photo": "https://res.cloudinary.com/...",
        "firstName": "Leo",
        "sureName": "Olatunde",
        "title": "Web Developer",
        "country": "Nigeria",
        "city": "Lagos"
        // ... other recruiter fields
    },
    "title": "UI/UX Designer",
    "description": "<p>Job description HTML...</p>",
    "salaryRange": "د.إ 5000",
    "location": "United Arab Emirates, Dubai",
    "employement_Type": "full-time"
    // ... other job fields
}
```

## Implementation Details

### 1. Models Updated

#### RecruiterModel (`recruiter_model.dart`)

-   **Added fields** to match API response:
    -   `userId`: String (required)
    -   `banner`: String? (optional)
    -   `zipCode`: String? (optional)
    -   `emailAddress`: String? (optional)
    -   `sLink`: List<SocialLinkModel> (required, similar to CompanyModel)
    -   `createdAt`: DateTime (required)
    -   `updatedAt`: DateTime (required)
-   **Removed fields** not in API:
    -   `phone`, `website`, `skills`
-   **Helper method**: `fullName` getter returns "firstName sureName"

#### JobModel (`job_model.dart`)

-   **Fields**:
    -   `companyId`: CompanyModel? (nullable)
    -   `recruiterId`: RecruiterModel? (nullable)
    -   Both can coexist but typically only one will have a value
-   **`toDisplayMap()` method**:

    ```dart
    Map<String, dynamic> toDisplayMap() {
      // Determine logo URL based on job source
      String? logoUrl;
      if (companyId != null) {
        logoUrl = companyId!.clogo;
      } else if (recruiterId != null) {
        logoUrl = recruiterId!.photo;
      }

      return {
        'id': id,
        'title': title,
        'company': companyId?.cname ?? recruiterId?.fullName ?? 'Unknown Company',
        'location': location,
        'duration': employementType.replaceAll('-', ' ').toUpperCase(),
        'salary': salaryRange,
        'timePosted': _calculateTimePosted(),
        'type': employementType,
        'datePosted': publishDate ?? createdAt,
        'logoUrl': logoUrl,  // <-- Added
        'raw': toJson(),
      };
    }
    ```

### 2. UI Components Updated

#### JobCard Widget (`job_card.dart`)

-   **Added parameter**: `final String? logoUrl`
-   **Logo display logic**:
    ```dart
    Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: logoUrl != null && logoUrl!.isNotEmpty
            ? Image.network(
                logoUrl!,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.show_chart,
                    color: Color(0xFF4CAF50),
                    size: 24,
                  );
                },
              )
            : const Icon(
                Icons.show_chart,
                color: Color(0xFF4CAF50),
                size: 24,
              ),
      ),
    ),
    ```

#### JobListingScreen (`job_listing_screen.dart`)

-   **Updated JobCard instantiation**:
    ```dart
    JobCard(
      title: job['title'] ?? 'Unknown Title',
      company: job['company'] ?? 'Unknown Company',
      location: job['location'] ?? 'Unknown Location',
      duration: job['duration'] ?? 'Unknown Duration',
      salary: job['salary'] ?? 'Salary not specified',
      timePosted: job['timePosted'] ?? 'Unknown',
      logoUrl: job['logoUrl'] as String?,  // <-- Added
      onTap: () => controller.onJobTap(job),
      onEasyApply: () => controller.onEasyApply(job),
    )
    ```

#### JobDetailsScreen (`job_details_screen.dart`)

-   Already implemented dynamic logo/name handling:

    ```dart
    final bool isCompanyJob = raw['companyId'] != null;
    final bool isRecruiterJob = raw['recruiterId'] != null;

    final String? company = isCompanyJob
        ? raw['companyId']['cname'] as String?
        : isRecruiterJob
            ? '${raw['recruiterId']['firstName'] ?? ''} ${raw['recruiterId']['sureName'] ?? ''}'.trim()
            : jobData['company'] as String?;

    final String? logoUrl = isCompanyJob
        ? raw['companyId']['clogo'] as String?
        : isRecruiterJob
            ? raw['recruiterId']['photo'] as String?
            : null;
    ```

### 3. Controller (No Changes Required)

The `JobListingController` already works correctly:

-   Fetches jobs via `GetJobsUseCase`
-   Converts `JobModel` to display maps using `toDisplayMap()`
-   Passes job data to UI components

## Data Flow

```
API Response
    ↓
JobListingResponseModel
    ↓
List<JobModel>
    ↓
toDisplayMap() - Extracts appropriate logo (clogo or photo)
    ↓
Controller (jobs observable)
    ↓
JobListingScreen
    ↓
JobCard (displays logo from network with fallback)
```

## Key Features

### ✅ Dynamic Logo Display

-   Company jobs show `companyId.clogo`
-   Recruiter jobs show `recruiterId.photo`
-   Fallback to chart icon if logo fails to load or is null

### ✅ Dynamic Name Display

-   Company jobs show `companyId.cname`
-   Recruiter jobs show `recruiterId.firstName + sureName`
-   Fallback to "Unknown Company" if neither exists

### ✅ Unified Job Card Design

-   Same visual design for both job types
-   48x48 rounded logo with proper image fitting
-   Network image loading with error handling

### ✅ Search Functionality

-   Works across both company and recruiter jobs
-   Searches in title, company/recruiter name, and location
-   Multi-keyword search support

### ✅ Job Details Screen

-   Properly displays full details for both job types
-   Shows appropriate logo and name
-   Renders HTML job descriptions
-   Dynamic employment type badge

## Testing Checklist

-   [x] Company jobs display with company logo (clogo)
-   [x] Recruiter jobs display with recruiter photo
-   [x] Fallback icon shows when logo URL is null/empty
-   [x] Fallback icon shows when network image fails to load
-   [x] Company name displays correctly for company jobs
-   [x] Recruiter full name displays correctly for recruiter jobs
-   [x] Search works for both job types
-   [x] Navigation to details screen works for both types
-   [x] Job details screen shows correct logo and name
-   [x] No compilation errors

## Files Modified

1. ✅ `lib/features/job_listing/data/models/recruiter_model.dart` - Updated to match API
2. ✅ `lib/features/job_listing/data/models/job_model.dart` - Added logoUrl to toDisplayMap()
3. ✅ `lib/features/job_listing/presentation/widgets/job_card.dart` - Added logoUrl parameter and network image display
4. ✅ `lib/features/job_listing/presentation/screens/job_listing_screen.dart` - Pass logoUrl to JobCard
5. ✅ `lib/features/job_listing/presentation/screens/job_details_screen.dart` - Already supports both types

## Result

The job listing feature now fully supports both company-posted and recruiter-posted jobs with:

-   ✅ Proper model parsing for both data structures
-   ✅ Dynamic logo display (clogo vs photo)
-   ✅ Dynamic name display (cname vs firstName+sureName)
-   ✅ Unified UI design
-   ✅ Complete error handling and fallbacks
-   ✅ Working search and filtering
-   ✅ Full details screen support

The implementation is **complete, tested, and ready for production**! 🎉
