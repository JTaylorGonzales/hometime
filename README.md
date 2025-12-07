# README

# Setting up

- make sure the ruby version on `.tool-versions` is installed

- run `bundle install` to install the project

- update the host, username, password at `config/database.yml` based on your database configs
  ```
  default: &default
    adapter: postgresql
    encoding: unicode
    # For details on connection pooling, see Rails configuration guide
    # https://guides.rubyonrails.org/configuring.html#database-pooling
    max_connections: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
    host: localhost 
    username: postgres
    password: postgres
  ```
- then run `rails db:setup` to create the databases and run the migrations
- finally, you can run the server with: `rails server`

# Testing the endpoint
- the create reservation endpoint is at `/reservations`
- you can test it via these example payloads
- payload example 1:

  ```
    {
      "start_date": "2021-03-12",
      "end_date": "2021-03-16",
      "nights": 4,
      "guests": 4,
      "adults": 2,
      "children": 2,
      "infants": 0,
      "status": "accepted",
      "guest": {
        "id": 1,
        "first_name": "Wayne",
        "last_name": "Woodbridge",
        "phone": "639123456789",
        "email": "wayne_woodbridge@bnb.com"
      },
      "currency": "AUD",
      "payout_price": "3800.00",
      "security_price": "500",
      "total_price": "4500.00"
    }
  ```
- payload example 2:

  ```
    {
      "reservation": {
        "start_date": "2021-03-12",
        "end_date": "2021-03-16",
        "expected_payout_amount": "3800.00",
        "guest_details": {
        "localized_description": "4 guests",
        "number_of_adults": 2,
        "number_of_children": 2,
        "number_of_infants": 0
        },
        "guest_email": "wayne_woodbridge@bnb.com",
        "guest_first_name": "Wayne",
        "guest_id": 1,
        "guest_last_name": "Woodbridge",
        "guest_phone_numbers": [
        "639123456789",
        "639123456789"
        ],
        "listing_security_price_accurate": "500.00",
        "host_currency": "AUD",
        "nights": 4,
        "number_of_guests": 4,
        "status_type": "accepted",
        "total_paid_amount_accurate": "4500.00"
      }
    }
  ```
# Defining New Adapters ( new type of payload )
- you can run `rake adapters:generate`
  - it will ask for the adapter name ex: AirbnbPayload
  - and also the path for the .json file for the payload itself
  - it will generate 2 files the Adapter and a spec for it
  - you still need to update the Adapter file for the proper mapping of the values
  - after that, you add it to the list of ADAPTERS in AdapterResolver
  - lastly, update the `shared_examples.rb` for the new payload and update the generated spec if needed

- `important`: make sure the file.json only contains the part of the payload where we will extract the data. 
  - for example, the `payload example 2` should only contains the hash inside the "reservations" key since it contains the main structure that we want to save