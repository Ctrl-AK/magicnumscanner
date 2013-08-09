# Tool: MagicNumber Scanner v1.0 

# Christian Navarrete (chr1x@izpwning.me) / 2013
# Website: http://chr1x.izpwning.me / Tw: @chr1x

# Features:
# - Magic-number scanning based on a simple signature list.
# - Automatically generates a URL with the identified extension pointing to the http://filext.com/ website.
#  (e.g. http://filext.com/file-extension/EXE)

# TODO:
# - Generation of HTML report that shows more information about the file extension.

# NOTE: signatures taken from the website of Gary C. Kessler - http://www.garykessler.net/
# This is a proof of concept tool to show how to deal with binary data using the Ruby language.

# If you find any bugs, let me know. Thanks. ]¬)

require './magic_num_scanner_lib'

mns=MagicNumScanner.new()
mns.action!(ARGV[0])
print mns.report+"\n\n"
mns.clean_virtual_file_vars