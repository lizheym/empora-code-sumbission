# Overview
This program was written in Ruby, and is designed to be a command-line program to validate a US address against a given API.

My goal when solving this problem was to keep the address validator as slim as possible, and relegate the important logic to the Address class. The high-level address validator shouldn't need to be concerned with the concepts of raw and corrected addresses, or the specific codes and fields returned by the API.

I tried to extract any and all constants, and provide them descriptive names. As a note, it is possible that the API key I used will have been exhausted by the time I submit this sample. I was provided a key by email, but that one was exhausted as well by the time I tried it. Please feel free to replace the value of the constant with a fresh API key.

I will admit, I didn't use TDD when developing this program (as you can see if you investigate commit-by-commit). In my opinion, TDD is an excellent practice, though if you write your code with tests in mind you can avoid the back-and-forth process of TDD. Once you develop using TDD enough, it instills good practices, and the rigor of the actual process becomes less important. I tried to write each method to serve exactly one, testable purpose.

## Gem install
In this program, I used the httparty gem to facilitate easier HTTP calls.
To install this gem, please run:
`gem install httparty`

## Valid address case
There are three possible responses from the address validation API (along with responses for cases such as invalid API or exhausted limit): VALID, SUSPECT, and INVALID

The provided README specified only what to do when the address is SUSPECT or INVALID. I used some liberty and still printed the provided address if it was valid, and to mirror the INVALID case, I appended '-> Address Valid' for full information.

## Testing approach

As a related note, I used `pry` to debug this program, and in case the reviewer of this code doesn't have `pry` available, I commented out the import.

`gem install webmock`

Explain the use of mock/stub
Rspec unit tests, edge cases, etc

## How to run
To run this program from the terminal, you can execute the following command
`ruby address_validator.rb sample_file.csv`
Replace `sample_file.csv` with the file path to another CSV file if you wish.