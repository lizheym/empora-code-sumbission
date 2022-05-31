require 'csv'
require_relative 'address'

class AddressProcessor
    def self.processFile(fileName)
        CSV.foreach(fileName, headers: true, col_sep: ", ") do |row|
            address = Address.new(row["Street Address"], row["City"], row["Postal Code"])
            puts address.formattedAddressCorrectionResult
        end
    end
end
