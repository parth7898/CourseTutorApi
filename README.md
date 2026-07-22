# Course Tutor API

A Ruby on Rails API application to manage courses and tutors.

## Features

- Create a course with multiple tutors
- Retrieve all courses with their tutors
- Transaction rollback if any tutor creation fails
- JSON responses using ActiveModel Serializers
- Request and Service test coverage using RSpec

## Tech Stack

- Ruby 3.x
- Ruby on Rails 7.x
- PostgreSQL
- RSpec
- FactoryBot
- Faker
- ActiveModel Serializers

---

## Setup

Clone the repository

```bash
git clone https://github.com/parth7898/CourseTutorApi.git
```

Move into the project

```bash
cd CourseTutorApi
```

Install dependencies

```bash
bundle install
```

Create database

```bash
rails db:create
```

Run migrations

```bash
rails db:migrate
```

Start the server

```bash
rails server
```

---

## API Endpoints

### Create Course

**POST**

```
/api/v1/courses
```

Request Body

```json
{
  "course": {
    "name": "Ruby on Rails",
    "description": "Backend Framework",
    "tutors": [
      {
        "name": "Rahul",
        "email": "rahul@test.com"
      },
      {
        "name": "Amit",
        "email": "amit@test.com"
      }
    ]
  }
}
```

---

### Get Courses

**GET**

```
/api/v1/courses
```

---

## Run Tests

Run all tests

```bash
bundle exec rspec
```

Run request specs

```bash
bundle exec rspec spec/requests
```

Run service specs

```bash
bundle exec rspec spec/services
```

---

## Project Structure

```
app/
├── controllers
├── models
├── serializers
├── services

spec/
├── requests
├── services
├── factories
```

---

## Testing

The project includes tests for:

- Course creation
- Tutor creation
- Validation errors
- Duplicate tutor emails
- Transaction rollback
- Empty tutor list
- Fetching all courses

---

## Author

Parth Choudhary