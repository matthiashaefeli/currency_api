# Currency API

Currency API provides a simple API, returns the value of a currency in json format 1$ = returned currency.

Stores the searched currency in the DB.

# Requirements

This code has been run and tested by Ruby 2.7.0, Rails 6.0.3.2

# How to set up locally

```
$ git clone
$ cd currency_api
$ bundle install
$ rails db:create
$ rails db:migrate
```

# Running the server

```
$ rails s
```

# Run test suit

```
$ cd currency_api
$ rspec
```

# Deploy to heroku

```
$ heroku login
$ heroku create api_name
$ git config --list | grep heroku    # verify remote
$ git push heroku master
$ heroku ps:scale web=1   # ensure one dyno is running
$ heroku ps # check dynos
$ heroku run rake db:migrate
```

Rails secret key config

```
$ cat config/master.key
$ heroku config:set RAILS_MASTER_KEY=key
```


# Create a User
## Ruby:

```
require 'net/http'
require 'json'

uri = URI('http://mat-currency-api.herokuapp.com/users')

response = Net::HTTP.start(uri.host, uri.port) do |http|
   req = Net::HTTP::Post.new(uri)
   req['Content-Type'] = 'application/json'
   req.body = { "user": {
                  "email": "test@test.com",
                  "password": "1234"
                }
              }.to_json
   http.request(req)
end
```

## Postman:

POST: http://mat-currency-api.herokuapp.com/users

Headers: KEY: Content-Type VALUE: application/json

Body: raw
```
{
  "user": {
    "email": "test@test.com",
    "password": "1234"
  }
}
```

# Get Token
## Ruby:

```
require 'net/http'
require 'json'

uri = URI('http://mat-currency-api.herokuapp.com/users/login')

response = Net::HTTP.start(uri.host, uri.port) do |http|
   req = Net::HTTP::Post.new(uri)
   req['Content-Type'] = 'application/json'
   req.body = { "user": {
                  "email": "test@test.com",
                  "password": "1234"
                }
              }.to_json
   http.request(req)
end

token = JSON.parse(response.body)['auth_token']
```

## Postman:

POST: http://mat-currency-api.herokuapp.com/users/login

Headers: KEY: Content-Type VALUE: application/json

Body: raw
```
{
  "user": {
    "email": "test@test.com",
    "password": "1234"
  }
}
```

# Create Currency
## Ruby:

```
require 'net/http'
require 'json'

uri = URI('http://mat-currency-api.herokuapp.com/currencies/?currency=CHF')

response = Net::HTTP.start(uri.host, uri.port) do |http|
   req = Net::HTTP::Post.new(uri)
   req['Content-Type'] = 'application/json'
   req['Authorization'] = token
   http.request(req)
end
```
## Postman:

POST: http://mat-currency-api.herokuapp.com/currencies/

Headers: KEY: Authorization VALUE: token

PARAMS: KEY: currency VALUE: CHF


# Show all stored Currencies
## Ruby:

```
require 'net/http'
require 'json'

uri = URI('http://mat-currency-api.herokuapp.com/currencies')

response = Net::HTTP.start(uri.host, uri.port) do |http|
   req = Net::HTTP::Get.new(uri)
   req['Content-Type'] = 'application/json'
   req['Authorization'] = token
   http.request(req)
end
```
## Postman:

GET: http://mat-currency-api.herokuapp.com/currencies

Headers: KEY: Authorization VALUE: token

# Show all stored Currencie with filter and sort

```
require 'net/http'
require 'json'

uri = URI('http://mat-currency-api.herokuapp.com/currencies')

response = Net::HTTP.start(uri.host, uri.port) do |http|
   req = Net::HTTP::Get.new(uri)
   req['Content-Type'] = 'application/json'
   req['Authorization'] = token
   params = { filter: 'EUR', sort: 'value' }.to_json
   http.request(req, params)
end
```

## Postman:

GET: http://mat-currency-api.herokuapp.com/currencies

Headers: KEY: Authorization VALUE: token

Parmas: KEY: filter VALUE: 'EUR', KEY: sort VALUE: 'currency'

# Show Currency
## Ruby:

```
require 'net/http'
require 'json'

uri = URI('http://mat-currency-api.herokuapp.com/currencies/1)

response = Net::HTTP.start(uri.host, uri.port) do |http|
   req = Net::HTTP::Get.new(uri)
   req['Content-Type'] = 'application/json'
   req['Authorization'] = token
   http.request(req)
end
```

## Postman:

GET: http://mat-currency-api.herokuapp.com/currencies/1

Headers: KEY: Authorization VALUE: token

# Delete Currency
## Ruby:
```
require 'net/http'
require 'json'

uri = URI('http://mat-currency-api.herokuapp.com/currencies/1')

response = Net::HTTP.start(uri.host, uri.port) do |http|
   req = Net::HTTP::Delete.new(uri)
   req['Content-Type'] = 'application/json'
   req['Authorization'] = token
   http.request(req)
end
```

## Postman:

DELETE: http://mat-currency-api.herokuapp.com/currencies/1

Headers: KEY: Authorization VALUE: token

# Show all stored Currency names
## Ruby:

```
require 'net/http'
require 'json'

uri = URI('http://mat-currency-api.herokuapp.com/currencies/currency_names')

response = Net::HTTP.start(uri.host, uri.port) do |http|
   req = Net::HTTP::Get.new(uri)
   req['Content-Type'] = 'application/json'
   req['Authorization'] = token
   http.request(req)
end
```
## Postman:

GET: http://mat-currency-api.herokuapp.com/currencies/currency_names

Headers: KEY: Authorization VALUE: token