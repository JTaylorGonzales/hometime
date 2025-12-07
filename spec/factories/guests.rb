FactoryBot.define do
  factory :guest do
    first_name { "John" }
    last_name  { "Doe" }
    email { "john.doe@example.com" }
    phone_numbers { [ "1234567890" ] }
  end
end
