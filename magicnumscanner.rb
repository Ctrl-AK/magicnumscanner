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

require './signatures'

$virtual_file = []
$virtual_file_mem = []

def generate_report(filetype, signature)
  filetype_url = filetype.scan(/^[A-Z0-9|]+/)[0].to_s
  if filetype_url.include?("|")
    filetype_url = filetype_url.split(/\|/)
    filetype_url.each do |filetype_ext|
      puts "Found: #{filetype} | More info: http://filext.com/file-extension/#{filetype_ext}" # | Magic: #{signature}"
    end
  else
    puts "Found: #{filetype} | More info: http://filext.com/file-extension/#{filetype_url}" # | Magic: #{signature}"
  end
end

def sig_check
  $sigs.each do |filetype, signature|
    signature = signature.downcase
    signature = signature.split(/\s/)
          
    if $virtual_file_mem[0..signature.size-1] == signature
      generate_report(filetype, signature)
    end
  end
  $binfile.close
  $virtual_file.clear
  $virtual_file_mem.clear
end

if ARGV[0].nil?
  puts ""
  puts "<MagicNumber Scanner v1.0> by chr1x (http://chr1x.izpwning.me)"
  puts ""
  puts "USE: #{$0} <input file>"
  exit
else
  puts ""
  puts "<MagicNumber Scanner v1.0> by chr1x (http://chr1x.izpwning.me)"
  puts ""
  puts "[*] Starting Magic-number scan on... <#{ARGV[0]}>"
  
  begin
    $binfile = File.open(ARGV[0], "rb") # opening file read + binary

    $binfile.each_codepoint do |bytes|
      $virtual_file.push(bytes.to_s(16))
    end    
    
    $virtual_file.each do |array_byte|
      if array_byte.size == 1
        array_byte = "0" + array_byte.to_s
        $virtual_file_mem.push(array_byte)
      else
        $virtual_file_mem.push(array_byte)
      end
    end
  rescue Exception => e
    puts "Error when opening the file: #{e.message}"
  else
    sig_check # do signature check
  end
end

