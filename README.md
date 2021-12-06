# Labforward Data Monitoring

This work is for Labforward Rails-API code challenge :rocket:

![Rspec](https://www.labforward.io/wp-content/uploads/2019/12/Labforward_Logo_1line_Pos_RGB-1.png)

## Build And Run

After cloning the project make sure that:

### Ruby version(2.6.1)
```bash
$curl -sSL https://get.rvm.io | bash -s stable
$rvm install ruby-2.6.1
$rvm use ruby-2.6.1 --default
```

### Rails version(6.1.4)
```bash
$gem install rails
```

### PostgreSql version(9.5.25)

### node version(>8.16.0)

### yarn version(>1.22.0)

#### Follow the logs

```bash
$ tail -f log/development.log
# or for specs:
$ tail -f log/test.log
```

## Prepare database

```bash
# Log in to PostgreSQL, in my case the username is postgres
# but might be different in your case
sudo -u postgres psql

# Once signed in create three databases
create database data_monitor_development;
create database data_monitor_production;
create database data_monitor_test;

# Creating a new user, this will be used for Rails to gain access to each database
create user admin with encrypted password 'admin';

# Grant priviledges for the newly created user to manage these databases
grant all privileges on database data_monitor_development to admin;
grant all privileges on database data_monitor_production to admin;
grant all privileges on database data_monitor_test to admin;
ALTER USER admin CREATEDB;
ALTER DATABASE data_monitor_test owner to admin;

#Run DB Migration in the project
$ rake db:migrate
```
### Install gem dependencies
```bash
$bundle install
```

### Run The project
```bash
$rails s
```

### Run specs
```bash
$ bin/rails db:migrate RAILS_ENV=test
$ bundle exec rspec
```

# Cleanup Database

```bash
$ rake db:drop

```

# API Documentation

### Signup Researcher
##### (POST /signup)

```bash
$ curl -X POST \
    http://localhost:3000/signup \
    -H 'accept: application/json' \
    -H 'cache-control: no-cache' \
    -H 'content-type: application/json' \
    -d '{
        "data": {
            "attributes": {
                "email": "researcher_example@labforward.de",
                "password": "researcher"
            }
        }
    }'
```
    response 201:{
        "email": "resaearcher_example@labforward.de",
        "password": "researcher"
    }


### Authenticate User
##### (POST /authentications)

```bash
$ curl -X POST \
    http://localhost:3000/authentications \
    -H 'cache-control: no-cache' \
    -H 'content-type: application/json' \
    -d '{
        "authentication": {
            "email": "researcher_example@labforward.de",
            "password": "researcher"
        }
    }'
```
    response 201: {
        "researcher_id": 2,
        "researcher_email": "researcher_example@labforward.de",
        "token": "eyJhbGciOiJIUzI1NiJ9.eyJyZXNlYXJjaGVyX2lkIjoyfQ.WwUUgjZXbsjIm7iYJN5KJ9RuIZQiB9B8QHWKbQWe_FU"
    }

### Monitor Data
##### (POST /api/v1/experiments)
```bash
$ curl -X POST \
    http://localhost:3000/api/v1/experiments/ \
    -H 'authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJyZXNlYXJjaGVyX2lkIjoyfQ.WwUUgjZXbsjIm7iYJN5KJ9RuIZQiB9B8QHWKbQWe_FU' \
    -H 'cache-control: no-cache' \
    -H 'content-type: application/json' \
    -d '{
        "data": [1, 1.1, 0.9, 1.2, 2, 6, 7,8.5, 2.3, 2.4, 1.1, 0.8, 1.2, 1, 10 ,15, 10],
        "threshold": 3
    }'
```
    response 201: {
        "id":6,
        "researcher_id":2,
        "threshold":3.0,
        "data":[1.0,1.1,0.9,1.2,2.0,6.0,7.0,8.5,2.3,2.4,1.1,0.8,1.2,1.0,10.0,10.0,10.0],
        "signal":[0,0,0,0,0,1,1,1,0,0,0,0,0,0,1,1,1]
    }


### Get Researcher Experiments
##### (GET /api/v1/experiments)

```bash
$ curl -X GET \
    http://localhost:3000/api/v1/experiments/ \
    -H 'authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJyZXNlYXJjaGVyX2lkIjoyfQ.WwUUgjZXbsjIm7iYJN5KJ9RuIZQiB9B8QHWKbQWe_FU' \
    -H 'cache-control: no-cache' \
    -H 'content-type: application/json' \
```
    response 200: {
        "results": [
            {
                "id":6,
                "researcher_id":2,
                "threshold":3.0,
                "data":[1.0,1.1,0.9,1.2,2.0,6.0,7.0,8.5,2.3,2.4,1.1,0.8,1.2,1.0,10.0,10.0,10.0],
                "signal":[0,0,0,0,0,1,1,1,0,0,0,0,0,0,1,1,1]
            }
        ]
    }

