require_relative 'address'
require 'httparty'

RSpec.describe Address do
    let(:verification_response) { instance_double(HTTParty::Response, body: verification_response_body.to_json) }
    let(:verification_response_body) do
        {
            "status" => validation_status,
            "addressline1" => corrected_address_line_one,
            "city" => corrected_city,
            "postalcode" => corrected_postal_code
        }
    end
    let(:validation_status) { "SUSPECT" }
    let(:corrected_address_line_one) { "123 E Main St" }
    let(:corrected_city) { "Columbus" }
    let(:corrected_postal_code) { "43210" }

    let(:address) { Address.new(raw_street_address, raw_city, raw_postal_code) }
    let(:raw_street_address) { "123 E Maine Street" }
    let(:raw_city) { "Columbuss" }
    let(:raw_postal_code) { "43211" }

    before do
        allow(HTTParty).to receive(:get).and_return(verification_response)
    end

    describe "#new" do
        let(:expected_request_string) do
            "#{Address::ADDRESS_VALIDATION_API_ADDRESS}"\
                "StreetAddress=123 E Maine Street&"\
                "City=Columbuss&"\
                "PostalCode=43211&"\
                "CountryCode=US&"\
                "Geocoding=true&"\
                "APIKey=#{Address::ADDRESS_VALIDATION_API_KEY}"
        end

        before do
            address
        end

        it "uses HTTParty to hit the API" do
            expect(HTTParty)
                .to have_received(:get)
                .with(expected_request_string)
        end

        it "correctly sets the raw attributes", :aggregate_failures do
            expect(address.raw_street_address).to eq(raw_street_address)
            expect(address.raw_city).to eq(raw_city)
            expect(address.raw_postal_code).to eq(raw_postal_code)
        end

        it "correctly sets the corrected attributes", :aggregate_failures do
            expect(address.address_line_one).to eq(corrected_address_line_one)
            expect(address.city).to eq(corrected_city)
            expect(address.postal_code).to eq(corrected_postal_code)
        end

        it "correctly sets the status" do
            expect(address.validation_status).to eq(validation_status)
        end
    end

    describe "#rawAddress" do
        it "correctly concatenates and formats the output" do
            expect(address.rawAddress).to eq("123 E Maine Street, Columbuss, 43211")
        end

        context "when is a field missing in the raw address" do
            let(:raw_city) { nil }

            it "ignores the missing value" do
                expect(address.rawAddress).to eq("123 E Maine Street, , 43211")
            end
        end
    end
    
    describe "#correctedAddress " do
        it "correctly concatenates and formats the output" do
            expect(address.correctedAddress).to eq("123 E Main St, Columbus, 43210")
        end

        context "when is a field missing in the corrected address" do
            let(:corrected_city) { nil }

            it "ignores the missing value" do
                expect(address.correctedAddress).to eq("123 E Main St, , 43210")
            end
        end
    end

    describe "#formattedAddressCorrectionResult" do
        context "when the validation status is VALID" do
            let(:validation_status) { "VALID" }

            it "provides original input address, stating that it was valid" do
                expect(address.formattedAddressCorrectionResult).to eq("123 E Maine Street, Columbuss, 43211 -> Valid Address")
            end
        end

        context "when the validation status is SUSPECT" do
            let(:validation_status) { "SUSPECT" }

            it "provides original input address, with an arrow pointing to the corrected address" do
                expect(address.formattedAddressCorrectionResult).to eq("123 E Maine Street, Columbuss, 43211 -> 123 E Main St, Columbus, 43210")
            end
        end

        context "when the validation status is INVALID" do
            let(:validation_status) { "INVALID" }

            it "provides original input address, stating that it was invalid" do
                expect(address.formattedAddressCorrectionResult).to eq("123 E Maine Street, Columbuss, 43211 -> Invalid Address")
            end
        end
    end
end