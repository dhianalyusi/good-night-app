# Good Night App 🌙

Good Night App is a Ruby on Rails application that lets users track their sleep, clock in and out, and connect with friends by following or unfollowing them.

---

## Features ✨
- User sleep tracking (clock in / clock out).
- View personal sleep history.
- Follow / unfollow other users.
- Weekly leaderboard of friends’ sleep duration.

---

## Tech Stack 🛠
- **Language & Framework**
  - Ruby on Rails 8 (see `Gemfile`)

- **Database**
  - PostgreSQL (`pg`)

- **Testing**
  - RSpec (`rspec-rails`)
  - Rswag specs for API documentation generation

- **CI / Automation**
  - GitHub Actions (`.github/workflows/ci.yml`)

---

## Getting Started 🚀

### 1. Clone Repository
```bash
git clone https://github.com/dhianalyusi/good-night-app.git
cd good-night-app
```

### 2. Install Dependencies
```bash
bundle install
```

### 3. Copy the example file:
```bash
cp .env.example .env
```
Edit .env with your local credentials

### 4. Setup Database
```bash
rails db:create
rails db:migrate
```

### 5. Run Server
```bash
rails server
```
Visit: http://localhost:3000

---

## API Documentation 📡

View the documentation locally
1. Start the app in development:
```bash
rails server
```
2. Open the Swagger UI in your browser:
```
http://localhost:3000/api-docs
```

---

## Test 🧪

Run full test suite
```bash
bundle exec rspec
```

Run a single spec file
```bash
bundle exec rspec spec/requests/api/v1/users_spec.rb
```

Run a single example (use the line number from failure output)
```bash
bundle exec rspec spec/requests/api/v1/users_spec.rb:23
```

Note: Ensure the test DB is prepared before running tests:
```bash
RAILS_ENV=test bundle exec rails db:create db:schema:load
```
