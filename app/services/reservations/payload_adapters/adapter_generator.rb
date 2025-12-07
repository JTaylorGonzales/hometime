# lib/reservations/payload_adapters/adapter_generator.rb
module Reservations
  module PayloadAdapters
    class AdapterGenerator
      def initialize(adapter_name, payload_data)
        @adapter_name = adapter_name
        @payload_data = payload_data
      end

      def generate
        adapter_path = generate_adapter
        spec_path = generate_spec

        [ adapter_path, spec_path ]
      end

      private

      attr_reader :adapter_name, :payload_data

      def generate_adapter
        file_path = adapter_file_path

        # Create directory if it doesn't exist
        FileUtils.mkdir_p(File.dirname(file_path))

        # Write the adapter file
        File.write(file_path, adapter_content)

        file_path
      end

      def generate_spec
        file_path = spec_file_path

        # Create directory if it doesn't exist
        FileUtils.mkdir_p(File.dirname(file_path))

        # Write the spec file
        File.write(file_path, spec_content)

        file_path
      end

      def adapter_file_path
        snake_name = adapter_name.underscore
        Rails.root.join("app/adapters/reservations/payload_adapters/#{snake_name}.rb")
      end

      def spec_file_path
        snake_name = adapter_name.underscore
        Rails.root.join("spec/adapters/reservations/payload_adapters/#{snake_name}_spec.rb")
      end

      def adapter_content
        <<~RUBY
          module Reservations
            module PayloadAdapters
              class #{adapter_name} < BaseAdapter
                PAYLOAD_SCHEMA = {
          #{schema_fields}
                }.freeze
          #{'      '}
                private
          #{'      '}
                def normalize_payload
                  {
          #{normalized_fields}
                  }
                end
              end
            end
          end
        RUBY
      end

      def spec_content
        fixture_name = adapter_name.underscore.gsub("_payload", "")

        <<~RUBY
          require "rails_helper"

          RSpec.describe Reservations::PayloadAdapters::#{adapter_name} do
            include_context "payloads"
          #{'  '}
            it_behaves_like "a payload adapter"
          #{'  '}
            subject(:adapter) { described_class.new(#{fixture_name}_payload.deep_symbolize_keys) }
          #{'  '}
            describe ".matches_schema?" do
              it "matches the #{adapter_name.gsub('Payload', '')} schema" do
                expect(adapter.matches_schema?).to eq(true)
              end
          #{'    '}
              it "does not match other schemas" do
                other = described_class.new(airbnb_payload.deep_symbolize_keys)
                expect(other.matches_schema?).to eq(false)
              end
            end
          #{'  '}
            describe "#normalize" do
              it "returns a normalized Hash with required keys" do
                data = adapter.normalize
                expect(data).to include(:start_date, :guest_email, :currency)
              end
            end
          end
        RUBY
      end

      def schema_fields
        fields = []

        extract_fields(payload_data).each do |key, type|
          fields << "        #{key}: #{type}"
        end

        fields.join(",\n")
      end

      def normalized_fields
        # Get the standard field names from mapping
        standard_fields = generate_standard_fields

        fields = standard_fields.map do |field_name|
          "          #{field_name}: \"\""
        end

        fields.join(",\n")
      end

      def generate_standard_fields
        [
          :start_date,
          :end_date,
          :nights,
          :guests,
          :adults,
          :children,
          :infants,
          :status,
          :guest_external_id,
          :guest_first_name,
          :guest_last_name,
          :guest_phone,
          :guest_email,
          :currency,
          :payout_price_in_cents,
          :security_price_in_cents,
          :total_price_in_cents
        ]
      end

      def extract_fields(data)
        fields = {}

        data.each do |key, value|
          case value
          when Hash
            fields[key] = "Hash"
          when Array
            fields[key] = "Array"
          when Integer
            fields[key] = "Integer"
          when Float
            fields[key] = "Float"
          when TrueClass, FalseClass
            fields[key] = "Boolean"
          else
            fields[key] = "String"
          end
        end

        fields
      end
    end
  end
end
