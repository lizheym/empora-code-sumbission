require 'csv'
require_relative 'address'
require 'pry'

class AddressValidator
    def self.processFile(fileName)
        CSV.foreach(fileName, headers: true, col_sep: ", ") do |row|
            address = Address.new(row["Street Address"], row["City"], row["Postal Code"])
            puts address.formattedAddressCorrectionResult
        end
    end
end

inputFileName = ARGV[0]
AddressValidator.processFile(inputFileName)