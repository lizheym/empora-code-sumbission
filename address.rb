require 'httparty'
# require 'pry'

ADDRESS_VALIDATION_API_ADDRESS = "https://api.address-validator.net/api/verify?"
ADDRESS_VALIDATION_API_KEY = "av-6e9d1cb48b5e8deab810e7b1d927a676"
USA_COUNTRY_CODE = "US"

class Address
    def initialize(raw_street_address, raw_city, raw_postal_code)
        @raw_street_address = raw_street_address
        @raw_city = raw_city
        @raw_postal_code = raw_postal_code

        self.validateAddress
    end

    def validateAddress
        http_request_string = "#{ADDRESS_VALIDATION_API_ADDRESS}"\
                            "StreetAddress=#{@raw_street_address}&"\
                            "City=#{@raw_city}&"\
                            "PostalCode=#{@raw_postal_code}&"\
                            "CountryCode=#{USA_COUNTRY_CODE}&"\
                            "Geocoding=true&"\
                            "APIKey=#{ADDRESS_VALIDATION_API_KEY}"

        response = HTTParty.get(http_request_string)
        response_body = JSON.parse(response.body)

        @validation_status = response_body["status"]
        @formatted_address = response_body["formattedaddress"]
        @address_line_one = response_body["addressline1"]
        @address_line_last = response_body["addresslinelast"]
        @street = response_body["street"]
        @street_number = response_body["streetnumber"]
        @postal_code = response_body["postalcode"]
        @city = response_body["city"]
        @state = response_body["state"]
        @country = response_body["country"]
        @county = response_body["county"]
    end

    def formattedAddressCorrectionResult
        case @validation_status
        when "VALID"
            "#{self.rawAddress} -> Valid Address"
        when "SUSPECT"
            "#{self.rawAddress} -> #{self.correctedAddress}"
        when "INVALID"
            "#{self.rawAddress} -> Invalid Address"
        end
    end

    def rawAddress
        "#{@raw_street_address}, #{@raw_city}, #{@raw_postal_code}"
    end

    def correctedAddress
        "#{@address_line_one}, #{@city}, #{@postal_code}"
    end
 end