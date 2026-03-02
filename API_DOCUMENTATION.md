# API Documentation

## Base URL
```
https://e-learning-api-production-a6d4.up.railway.app/api
```

## Authentication
All authenticated endpoints require the `Authorization` header with a Bearer token:
```
Authorization: Bearer {token}
```

The token is automatically included in all requests via the Dio interceptor in `ApiService`.

---

## Authentication Endpoints

### Login User
Register or login an existing user.

**Endpoint:** `POST /auth/login`

**Request Headers:**
```
Content-Type: application/json
```

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response (200 OK):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "role": "student",
  "user": {
    "id": "user-123",
    "name": "John Doe",
    "email": "user@example.com",
    "avatar": "https://example.com/avatar.jpg"
  }
}
```

**Response (401 Unauthorized):**
```json
{
  "message": "Invalid email or password"
}
```

**Example Usage:**
```dart
final response = await apiService.login(
  'user@example.com',
  'password123'
);
final token = response.data['token'];
```

---

### Register User
Create a new user account.

**Endpoint:** `POST /auth/register`

**Request Headers:**
```
Content-Type: application/json
```

**Request Body:**
```json
{
  "name": "John Doe",
  "email": "user@example.com",
  "password": "password123"
}
```

**Response (201 Created):**
```json
{
  "message": "Registration successful",
  "user": {
    "id": "user-123",
    "name": "John Doe",
    "email": "user@example.com"
  }
}
```

**Response (400 Bad Request):**
```json
{
  "message": "Email already exists"
}
```

**Example Usage:**
```dart
await apiService.register(
  'John Doe',
  'user@example.com',
  'password123'
);
```

---

## Course Endpoints

### Get All Courses
Retrieve list of all available courses.

**Endpoint:** `GET /courses`

**Query Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `page` | integer | Page number (default: 1) |
| `limit` | integer | Items per page (default: 10) |
| `category` | string | Filter by category |
| `level` | string | Filter by level (Beginner, Intermediate, Advanced) |
| `search` | string | Search by title or description |
| `sort` | string | Sort by (rating, price, newest) |

**Response (200 OK):**
```json
{
  "courses": [
    {
      "id": "course-001",
      "slug": "flutter-basics",
      "title": "Flutter Basics",
      "category": "Mobile Development",
      "description": "Learn Flutter from scratch",
      "duration": "8 weeks",
      "rating": 4.5,
      "image": "https://example.com/course.jpg",
      "price": 49.99,
      "level": "Beginner",
      "instructor": {
        "id": "instructor-123",
        "name": "John Smith",
        "avatar": "https://example.com/instructor.jpg"
      }
    }
  ],
  "total": 150,
  "page": 1,
  "limit": 10
}
```

---

### Get Course Details
Get detailed information about a specific course.

**Endpoint:** `GET /courses/{courseId}`

**Path Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `courseId` | string | Course ID |

**Response (200 OK):**
```json
{
  "id": "course-001",
  "slug": "flutter-basics",
  "title": "Flutter Basics",
  "category": "Mobile Development",
  "description": "Complete Flutter tutorial",
  "duration": "8 weeks",
  "rating": 4.5,
  "image": "https://example.com/course.jpg",
  "price": 49.99,
  "discountPrice": 39.99,
  "level": "Beginner",
  "overview": {
    "about": ["Learn Flutter basics", "Build mobile apps"],
    "learn": ["Widgets", "State management", "Navigation"],
    "requirements": ["Basic programming knowledge"],
    "forWho": ["Beginners", "Mobile developers"]
  },
  "curriculum": [
    {
      "section": "1",
      "title": "Introduction",
      "lessons": [
        {
          "id": "lesson-001",
          "slug": "what-is-flutter",
          "title": "What is Flutter?",
          "content": "Lesson content...",
          "videoUrl": "https://example.com/video.mp4",
          "videoDuration": 3600,
          "isFreePreview": true
        }
      ]
    }
  ],
  "instructor": {
    "id": "instructor-123",
    "name": "John Smith",
    "avatar": "https://example.com/instructor.jpg",
    "bio": "Expert Flutter developer",
    "title": "Senior Developer"
  },
  "reviews": {
    "averageRating": 4.5,
    "totalReviews": 150,
    "reviews": [
      {
        "id": "review-001",
        "rating": 5,
        "comment": "Great course!",
        "author": "Jane Doe"
      }
    ]
  }
}
```

---

### Enroll in Course
Enroll the current user in a course.

**Endpoint:** `POST /courses/{courseId}/enroll`

**Headers:**
```
Authorization: Bearer {token}
```

**Response (201 Created):**
```json
{
  "message": "Successfully enrolled",
  "enrollment": {
    "id": "enroll-001",
    "userId": "user-123",
    "courseId": "course-001",
    "enrolledDate": "2024-02-18T10:30:00Z",
    "progress": 0
  }
}
```

---

## User Endpoints

### Get User Profile
Get current logged-in user's profile.

**Endpoint:** `GET /user/profile`

**Headers:**
```
Authorization: Bearer {token}
```

**Response (200 OK):**
```json
{
  "id": "user-123",
  "name": "John Doe",
  "email": "user@example.com",
  "avatar": "https://example.com/avatar.jpg",
  "role": "student",
  "bio": "Aspiring developer",
  "enrolledCourses": 5,
  "completedCourses": 2,
  "joinedDate": "2024-01-01T00:00:00Z"
}
```

---

### Update User Profile
Update current user's profile information.

**Endpoint:** `PUT /user/profile`

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Request Body:**
```json
{
  "name": "John Doe",
  "bio": "Aspiring developer",
  "avatar": "base64_encoded_image_or_url"
}
```

**Response (200 OK):**
```json
{
  "message": "Profile updated successfully",
  "user": {
    "id": "user-123",
    "name": "John Doe",
    "email": "user@example.com",
    "avatar": "https://example.com/avatar.jpg"
  }
}
```

---

### Get My Courses
Get all courses enrolled by the current user.

**Endpoint:** `GET /user/courses`

**Headers:**
```
Authorization: Bearer {token}
```

**Query Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `page` | integer | Page number (default: 1) |
| `limit` | integer | Items per page (default: 10) |
| `status` | string | Filter by status (ongoing, completed) |

**Response (200 OK):**
```json
{
  "courses": [
    {
      "id": "course-001",
      "title": "Flutter Basics",
      "image": "https://example.com/course.jpg",
      "progress": 45.5,
      "enrolledDate": "2024-02-01T00:00:00Z",
      "lastAccessed": "2024-02-18T10:30:00Z"
    }
  ],
  "total": 5,
  "page": 1,
  "limit": 10
}
```

---

## Error Handling

All error responses follow this format:

**Response (4xx/5xx):**
```json
{
  "message": "Error description",
  "code": "ERROR_CODE",
  "details": {}
}
```

### Common Error Codes

| Status | Code | Message |
|--------|------|---------|
| 400 | INVALID_INPUT | Invalid request parameters |
| 401 | UNAUTHORIZED | Missing or invalid token |
| 403 | FORBIDDEN | Insufficient permissions |
| 404 | NOT_FOUND | Resource not found |
| 409 | CONFLICT | Resource already exists |
| 500 | SERVER_ERROR | Internal server error |

---

## Rate Limiting

- Rate limit: 100 requests per minute per IP
- Rate limit headers: `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset`

---

## Testing the API

### Using Postman

1. Import the API collection
2. Set base URL: `https://e-learning-api-production-a6d4.up.railway.app/api`
3. For authenticated requests, add token to Authorization tab (Bearer token)
4. Test endpoints following the documentation above

### Using curl

```bash
# Login
curl -X POST https://e-learning-api-production-a6d4.up.railway.app/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password123"}'

# Get courses (with token)
curl -X GET https://e-learning-api-production-a6d4.up.railway.app/api/courses \
  -H "Authorization: Bearer {token}"
```

---

## Response Best Practices

1. Always check the HTTP status code
2. Handle errors gracefully with user-friendly messages
3. Cache responses when appropriate
4. Implement pagination for large datasets
5. Validate request data before sending

