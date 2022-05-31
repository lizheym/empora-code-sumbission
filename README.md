# Overview
This program was written in Ruby, and is designed to be a command-line program to validate a US address against a given API.

My goal when solving this problem was to keep the address validator as slim as possible, and relegate the important logic to the Address class. The high-level address validator shouldn't need to be concerned with the concepts of raw and corrected addresses, or the specific codes and fields returned by the API.

I tried to extract any and all constants, and provide them descriptive names. As a note, it is possible that the API key I used will have been exhausted by the time I submit this sample. I was provided a key by email, but that one was exhausted as well by the time I tried it. Please feel free to replace the value of the constant with a fresh API key.

I will admit, I didn't use TDD when developing this program (as you can see if you investigate commit-by-commit). In my opinion, TDD is an excellent practice, though if you write your code with tests in mind you can avoid the back-and-forth process of TDD. Once you develop using TDD enough, it instills good practices, and the rigor of the actual process becomes less important. I tried to write each method to serve exactly one, testable purpose.

Another decision I made was to include sample csv files within the directory to aid with testing the address validator. The alternative would have been to create the csv files within the code itself, but it seemed simpler to provide the actual file name. To clarify their purpose, I moved the test files to their own folder. The validity of the content of these files doesn't actually matter, since the API response is stubbed, but it is important to verify that the CSV content is the actual address that is output.

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

In order to avoid hitting the API each time the testing suite was run, I stubbed out the response from the HTTParty gem I had used to facilitate the API call.

An alternative I considered was the use of VCR. VCR records an actual response, and stores it so that the call doesn't need to be made every time. The benefit of VCR is that the response recorded, being an actual response, reflects the behavior of the API well. Given that this is a smaller project, and the fact that the API response is relatively simple, I decided to simply stub, and avoid testing the behavior of the external HTTParty gem.

When testing, I realized that it made more sense to make the method validateAddress a protected method, and in turn, that caused me to remove the tests for that method, and test its behavior in the initialization test. The reason for this change was the fact that the validateAddress method is called in the initializer. Thus, when I created the address object, the API (or the stub) has already been hit, and the validation behavior has already been performed. It didn't inflate the initialization test too much to add the validation behavior to that test. I still preferred the validation split off into its own method for readability reasons, and I also preferred the validation to be called in the initializer, because I think the caller of initialize (the creator of the Address object) shouldn't need to concern themselves with that validation call.

## How to run
To run this program from the terminal, you can execute the following command
`ruby address_validator.rb sample_file.csv`
Replace `sample_file.csv` with the file path to another CSV file if you wish.