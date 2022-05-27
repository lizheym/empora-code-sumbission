# Should be the 'runnable' file
# Takes in a file name as input
# Parses the file, line by line, passing the line as a string to the address instatiator
# Prints the output to the console
# The thoughts/questions I currently have are (for myself, for design purposes):
#   - Should I allow the creation of the address object before we know whether it's valid?
#   - Maybe a user input attribute on the address
#   - The validation could probably be a method on the address itself? I want to keep the address validator slim