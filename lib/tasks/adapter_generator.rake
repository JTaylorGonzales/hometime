# lib/tasks/generate_adapter.rake
namespace :adapters do
  desc "Generate a new payload adapter from JSON"
  task generate: :environment do
    require "json"
    require "tty-prompt"

    prompt = TTY::Prompt.new

    puts "=" * 60
    puts "Payload Adapter Generator"
    puts "=" * 60
    puts ""

    adapter_name = prompt.ask("Enter the adapter class name (e.g., AirbnbPayload):") do |q|
      q.required(true, "Adapter name cannot be empty")
      q.validate(/\A[A-Za-z0-9_]+\z/, "Adapter name can only contain letters, numbers, and underscores")
    end

    json_file = prompt.ask("Enter the path to the JSON payload file:") do |q|
      q.required(true, "File path cannot be empty")
      q.validate ->(input) { File.exist?(File.expand_path(input)) }, "File not found"
    end

    json_file = File.expand_path(json_file)

    puts ""
    puts "Generating adapter..."
    puts ""

    begin
      payload = JSON.parse(File.read(json_file), symbolize_names: true)
    rescue JSON::ParserError => e
      puts "Error: Invalid JSON file - #{e.message}"
      exit 1
    end

    generator = Reservations::PayloadAdapters::AdapterGenerator.new(adapter_name, payload)
    adapter_path, spec_path = generator.generate

    puts "✓ Adapter generated successfully!"
    puts "✓ Adapter spec generated successfully!"
    puts ""
    puts "  File: #{adapter_path}"
    puts "  Spec: #{spec_path}"
    puts ""
    puts "Next steps:"
    puts "  1. Review the generated adapter"
    puts "  2. Map the fields in normalize_payload to the correct params"
    puts "  3. Add any custom logic or validations"
    puts "  4. after implementing, add it to the AdapterResolver ADPTERS list"
    puts "  5. update the shared_payloads.rb used in specs to include the new payload"
    puts ""
  end
end
