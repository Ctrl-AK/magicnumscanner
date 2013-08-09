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

class MagicNumScanner

  attr_accessor :virtual_file, :virtual_file_mem, :reported_signatures

  def initialize vf=[], vfm=[]
     @virtual_file = vf
     @virtual_file_mem = vfm
     @reported_signatures=[]
  end

  def generate_reported_object(filetype, signature)
    filetype_url = filetype.scan(/^[A-Z0-9|]+/)[0].to_s
    if filetype_url.include?("|")
      filetype_url = filetype_url.split(/\|/)
      refs         = filetype_url.collect { |filetype_ext| "http://filext.com/file-extension/#{filetype_ext}"}
      {filetype: filetype, ref: refs, signature: signature }
    else
      {filetype: filetype, ref: ["http://filext.com/file-extension/#{filetype_url}"], signature: signature }
    end
  end  

  def sig_check
    SIGN.each do |filetype, signature|
      signature = signature.downcase.split(/\s/)
      if @virtual_file_mem[0..signature.size-1] == signature
        @reported_signatures<<generate_reported_object(filetype, signature)
      end
    end
    @reported_signatures
  end

  def action!(file)
     outcome=[]
     if file.nil?
       print "\n<MagicNumber Scanner v1.0> by chr1x (http://chr1x.izpwning.me)\n\n"
       print "\tUSE: #{$0} <input file>\n\n"
       exit
     else
       print "\n<MagicNumber Scanner v1.0> by chr1x (http://chr1x.izpwning.me)\n\n"
       puts "\t[*] Starting Magic-number scan on... <#{file}>\n"
       
       begin
         binfile = File.open(file, "rb") # opening file read + binary

         binfile.each_codepoint do |bytes|
           @virtual_file.push(bytes.to_s(16))
         end    
         
         @virtual_file.each do |array_byte|
           array_byte= (array_byte.size == 1) ? "0" + array_byte.to_s : array_byte
           @virtual_file_mem.push(array_byte)
         end
       rescue Exception => e
         puts "Error when opening the file: #{e.message}"
       else
         outcome=sig_check # do signature check
         binfile.close
       end
     end
     outcome
  end



  def report
     str=""
     @reported_signatures.each do |s|
          str+="\nFound: #{s[:filetype]} | Magic: #{s[:signature]}\n"
          str+="More info: "
          s[:ref].each{ |r| str+="\n\t"+r}
          str+="\n"
     end
     str
  end

  def clean_virtual_file_vars
         @virtual_file.clear
         @virtual_file_mem.clear              
  end

end

