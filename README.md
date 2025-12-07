# Project Setup & Usage

## Prerequisites

* Ensure the Ruby version specified in `.tool-versions` is installed.
* Install project dependencies:

  ```bash
  bundle install
  ```

## Database Configuration

1. Update your database credentials in `config/database.yml`:

   ```yaml
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
2. Setup the database and run migrations:

   ```bash
   rails db:setup
   ```

## Running the Server

```bash
rails server
```

---

# Testing the Reservation Endpoint

* Endpoint: `POST /reservations`
* You can test it with the following example payloads:

### Payload Example 1

```json
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

### Payload Example 2

```json
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
    "guest_phone_numbers": ["639123456789", "639123456789"],
    "listing_security_price_accurate": "500.00",
    "host_currency": "AUD",
    "nights": 4,
    "number_of_guests": 4,
    "status_type": "accepted",
    "total_paid_amount_accurate": "4500.00"
  }
}
```

---

# Defining New Adapters (New Payload Types)

1. Generate a new adapter with:

   ```bash
   rake adapters:generate
   ```
2. You will be prompted for:

   * **Adapter name** (e.g., `AirbnbPayload`)
   * **Path to the `.json` file** containing the payload
3. This generates:

   * Adapter file
   * Spec file for testing

### Next Steps After Generation

* Update the Adapter file with proper mapping of payload values.
* Add the new adapter to the `ADAPTERS` list in `AdapterResolver`.
* Update `shared_examples.rb` for the new payload, and adjust the generated spec if necessary.

### Important

* Ensure the `.json` file **only contains the relevant part of the payload**.
  For example, in **Payload Example 2**, include only the hash inside the `"reservation"` key since it contains the main structure to that we need.
