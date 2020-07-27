# Currency API

Currency API provides a simple API, converting one currency to another in json format.

# How to set up locally

```
$ git clone
$ cd
$ bundle install
$ rails db:create
$ rails db:migrate
```

# Running the server

```
$ rails s
```

Run test suit

```
$ cd
$ rspec
```

# Deploy to heroku

```
```

# Create a User
Code examples in Ruby

```
require 'net/http'
require 'json'

uri = URI('http://localhost:3000/users')

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

# Get Token
Code examples in Ruby

```
require 'net/http'
require 'json'

uri = URI('http://localhost:3000/users/login')

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

# route not sure yet
Code examples in Ruby

```
require 'net/http'
require 'json'

uri = URI('http://localhost:3000/users')

response = Net::HTTP.start(uri.host, uri.port) do |http|
   req = Net::HTTP::Get.new(uri)
   req['Content-Type'] = 'application/json'
   req['Authorization'] = token
   <!-- req.body = { "user": {
                  "email": "test@test.com",
                  "password": "1234"
                }
              }.to_json -->
   http.request(req)
end
```

