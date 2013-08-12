#MagicNumber Scanner v1.1.0
#========
#Christian Navarrete (chr1x@izpwning.me) 
#Website: http://chr1x.izpwning.me / Tw: @chr1x#

#Christian Yerena (preth00nker@gmail.com) 
#website: http://preth00nker.com Tw: @preth00nker#

#Description
#========
#The MagicNumber Scanner is a tool written using the Ruby language that identifies the file type based on its "magic number" and can generate a HTML report that contains links that points to a website to get detailed information about the identified file.#

#NOTE: signatures taken from the website of Gary C. Kessler - http://www.garykessler.net/
#If you find any bugs, let us know. Thanks. ]¬)



require './magic_num_scanner_lib'

mns=MagicNumScanner.new()
mns.action!(ARGV[0])
print mns.report+"\n\n"
mns.generate_html_report(ARGV[1]) if if !ARGV[1].nil?
mns.clean_virtual_file_vars