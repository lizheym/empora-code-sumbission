# Overview
This program was written in Ruby, and is designed to be a command-line program to validate a US address, or a series of US addresses against a given API.

This program includes three different code-containing files (in addition two two test files for the two classes I created). The address_processing_script file is the runnable file, and purely calls the address_processor. For testing purposes, I couldn't include script-like code within the class files.

I tried to keep the AddressProcessor class slim, and concern it exclusively with reading the CSV and actually writing to the console the string output provided by the Address itself. The AddressProcessor didn't need to be concerned with the concepts of raw and corrected addresses and the specific API interface.

I tried to extract any and all constants, and provide them descriptive names. To swap out the API key for the key used for testing code submissions, please swap out the value of the constant.

I will admit, I didn't use TDD when developing this program (as you can see if you investigate commit-by-commit). In my opinion, TDD is an excellent practice, though if you write your code with tests in mind you can avoid the back-and-forth process of TDD. Once you develop using TDD enough, it instills good practices, and the rigor of the actual process becomes less important. I tried to write each method to serve exactly one, testable purpose.

Another decision I made was to include sample csv files within the directory to aid with testing the address validator. The alternative would have been to create the csv files within the code itself, but it seemed simpler to provide the actual file name. To clarify the purpose of these files, I moved the test files to their own folder. The validity of the content of these files doesn't actually matter, since the API response is stubbed, but it is important to verify that the CSV is correctly parsed, and that the output corresponds to the address(es) from the CSV.

There were values returned from the API that I did not record on the Address object, because I try to tend towards only writing and recording what is currently needed. I can always add values such as `formattedaddress` and `county` if they are needed in the future (I noted that `formattedAddress` was not in the format specified by the problem statement, so I decided to format the address myself in this program). Partially for my own reference, here is the API documentation: https://www.address-validator.net/api.html#address-validation-api

## Assumptions

The CSV inputs will be correctly formatted. Otherwise, the CSV parser will throw an error. I decided not to handle errors in this program, since the problem definition didn't require it. The CSV parser provides a relatively verbose error.

Similarly, I didn't throw an error in the case of incorrectly formed API responses.

## Valid address case
There are three possible responses from the address validation API (along with responses for cases such as invalid API or exhausted limit): VALID, SUSPECT, and INVALID

The provided README specified only what to do when the address is SUSPECT or INVALID. I used some liberty and still printed the provided address if it was valid, and to mirror the INVALID case, I appended '-> Address Valid' for full information.

## Testing approach

As a related note, I used `pry` to debug this program. I find it useful to inspect the code itself, especially when being called from the tests. To clean up the code, though, I did remove the `pry` import. When modifying this code in the future, I will re-include `pry`.

In order to avoid hitting the API each time the testing suite was run, I stubbed out the response from the HTTParty gem I had used to facilitate the API call. In a `before` clause, I allowed `HTTParty` to receive `get` and return a response I formed in the testing suite. When applicable, I also confirmed that `HTTParty` received `get` with the correct API request path.

An alternative I considered was the use of VCR. VCR records an actual response and stores it so that the call doesn't need to be made every time. The benefit of VCR is that the response recorded, being an actual response, reflects the behavior of the API well. This may avoid incorrect assumptions the person writing the tests may make about the API. Given that this is a smaller project, and the fact that the API response is relatively simple, I decided to simply stub, and avoid testing the behavior of the external HTTParty gem.

When testing, I realized that it made more sense to make the method validateAddress a protected method, and in turn, that caused me to remove the tests for that method, and test its behavior in the initialization test. The reason for this change was the fact that the validateAddress method is called in the initializer. When I wanted to test validateAddress, I created an Address object, which resulted in the method implicitly being called. When I wanted to test the explicit call of validateAddress, the behavior had already been performed.
It didn't inflate the initialization test too much to add the validation behavior to that test. I still preferred the validation split off into its own method for readability reasons, and I also preferred the validation to be called in the initializer, because I think the caller of initialize (the creator of the Address object) shouldn't need to concern themselves with that validation call.

Two stylistic testing preferences I have are to:
- Declare many attributes dynamically, using `let`, even if functionally I could have included those values in one of the `let`s at a higher level. For readability, I group the `let` statements, ordered in increasing order of specificity.
- I prefer not to concatenate too many values in my actual assertions, especially when that concatenation reflects the way the code was written. For example, even though I had access to the corrected address values in `address_spec.rb`, I didn't include those in the assertions for `correctedAddress` because it would reflect too closely the way the code was implemented. This could lead to uncaught errors, since the assertion could have been copy-pasted from the code.

## Gem install
In this program, I used the httparty gem to facilitate easier HTTP calls.
To install this gem, please run:
`gem install httparty`

## How to run the tests

`rspec address_spec.rb`
`rspec address_processor_spec.rb`

## How to run
To run this program from the terminal, you can execute the following command
`ruby address_processing_script.rb test_files/sample_file.csv`
Replace `test_files/sample_file.csv` with the file path to another CSV file if you wish.