require_relative 'address_processor'

inputFileName = ARGV[0]
AddressProcessor.processFile(inputFileName)