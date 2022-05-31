require_relative 'address_processor'
require 'httparty'

RSpec.describe AddressProcessor do
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

            it "prints correct message is to the console" do
                expect do
                    AddressProcessor.processFile(address_file_name)
                end.to output("789 Euclaire Ave, Columbus, 43209 -> Valid Address\n").to_stdout
            end
        end

        context "when the input file contains a suspect address" do
            let(:validation_status) { "SUSPECT" }
            let(:address_file_name) { "test_files/sample_file_suspect.csv" }

            it "prints correct message is to the console" do
                expect do
                    AddressProcessor.processFile(address_file_name)
                end.to output("123 e Maine Street, Columbus, 43215 -> 123 E Main St, Columbus, 43210\n").to_stdout
            end
        end
        
        context "when the input file contains an invalid address" do
            let(:validation_status) { "INVALID" }
            let(:address_file_name) { "test_files/sample_file_invalid.csv" }
    
            it "prints correct message is to the console" do
                expect do
                    AddressProcessor.processFile(address_file_name)
                end.to output("1 Empora St, Title, 11111 -> Invalid Address\n").to_stdout
            end
        end

        context "when the input file contains multiple addresses" do
            let(:address_file_name) { "test_files/sample_file.csv" }
    
            it "includes all addresses in the console output", :aggregate_failures do
                expectation = expect do
                    AddressProcessor.processFile(address_file_name)
                end
                expectation.to output(/789 Euclaire Ave, Columbus, 43209/).to_stdout
                expectation.to output(/123 e Maine Street, Columbus, 43215/).to_stdout
                expectation.to output(/1 Empora St, Title, 11111/).to_stdout
            end
        end
    end
end