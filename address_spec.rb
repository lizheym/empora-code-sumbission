require_relative 'address'
require 'webmock/rspec'

RSpec.describe Address do

    RSpec.configure do |config|
        config.before(:each) do
          verification_response = {
            "status" => 'SUSPECT',
            "addressline1" => "123 E Main St",
            "city" => "Columbus",
            "postalcode" => "43210"
          }
          stub_request(:get, /#{Address::ADDRESS_VALIDATION_API_ADDRESS}/).
          to_return(status: 200, body: verification_response.to_json)
        end
    end

    describe "#rawAddress" do
        let(:raw_street_address) { "123 E Main St" }
        let(:raw_city) { "Columbus" }
        let(:raw_postal_code) { "43210" }
        let(:address) { Address.new(raw_street_address, raw_city, raw_postal_code) }

        it "correctly sets the raw attributes", :aggregate_failures do
            expect(address.raw_street_address).to eq(raw_street_address)
            expect(address.raw_city).to eq(raw_city)
            expect(address.raw_postal_code).to eq(raw_postal_code)
        end
    end
end