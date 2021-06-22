# NANOBLOG
Nanoblog is a blog application written with Ruby on Rails, inspired by Michael Hartl's Ruby on Rails Tutorial and Twitter. 

Live version: [Nanoblog](https://stormy-crag-26703.herokuapp.com/)

### Features:
- setting up account with email autentication
- editing account and adding avatar and background images
- resetting password with email link
- logging in with session and with cookies
- publishing posts
- following other users 

### Technologies used:
* Ruby 2.7.2
* Rails 6.1.3
* Haml
* Bootstrap 5
* SQLite for development and tests
* PostgreSQL for production
* RSpec

### Integrations
* Cloudinary for Active Storage
* Gmail for Action Mailer

### Setup

To run locally, you have to have Ruby in version 2.7.2  installed on your machine.
Next you have to execute 
```
.bin/setup
```
which will install bundler, create and seed database. 
Then you have to run 
```
bundle exec rails server
```
and the app will be available at __localhost:3000__ in your browser.