require_relative 'address_validator'
require 'httparty'

RSpec.describe AddressValidator do
    describe ".processFile" do
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

        before do
            allow(HTTParty).to receive(:get).and_return(verification_response)
        end

        context "when the input file contains a valid address" do
            let(:validation_status) { "VALID" }
            let(:address_file_name) { "test_files/sample_file_valid.csv" }

            expect "the correct message is printed to the console" do
                expect do
                    AddressValidator.processFile(address_file_name)
                end.to output("789 Euclaire Ave, Columbus, 43209 -> Valid Address").to_stdout
            end
        end

        context "when the input file contains a suspect address" do
        end

        context "when the input file contains an invalid address" do
        end

        context "when the input file contains multiple addresses" do
        end
    end
end