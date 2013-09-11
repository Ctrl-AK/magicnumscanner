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
require  './templates'

class MagicNumScanner

  attr_accessor :virtual_file, :virtual_file_mem, :reported_signatures

  def initialize vf=[], vfm=[]
     @virtual_file = vf
     @virtual_file_mem = vfm
     @reported_signatures=[]
  end

  def generate_reported_object(filetype, signature)
    puts "filetype: #{filetype} sig: #{signature}"
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
    SIGN.each { |filetype, signature|
      if @virtual_file_mem[0..signature.downcase.split(/\s/).size-1] == signature.downcase.split(/\s/)
        @reported_signatures<<generate_reported_object(filetype, signature)
      end
    }
    
    bytes_for_file = []
    bytes_for_sig = []
    
    PACKED.each {|packer_name, packer_signature|
      #puts "Testing: #{packer_name}.."
      $packer_name = packer_name
      packer_signature.split(/\s/).each {|signature_item| bytes_for_sig << signature_item.downcase }
      start_comp = @virtual_file.to_ary.index(bytes_for_sig[0].downcase).to_i
      finish_comp = start_comp + packer_signature.size
      @virtual_file[start_comp.to_i..finish_comp.to_i].each {|x| if x.size == 1 then bytes_for_file << "0" + x else bytes_for_file << x end }  
    
    byte_counter = 0
    equality_counter = []
    bytes_for_sig.each {|fs|
        if fs.eql?(bytes_for_file[byte_counter])
          equality_counter << bytes_for_file[byte_counter]
        end
        byte_counter = byte_counter + 1
    }
    bytes_for_sig.delete("??")  # cleaning all the "??" chars from the sig array.
    
    if equality_counter == bytes_for_sig
      puts "--"
      puts "Packer/Protector <FOUND> => #{$packer_name}"
    end
    bytes_for_sig.clear
    bytes_for_file.clear
    }      
  end

  def action!(file)
     outcome=[]
     print COPYLEFT
     if file.nil?
       print USAGE
       exit
     else
       print INIT_TEXT+"<#{file}>\n\n"
       begin
         binfile = File.open(file, "rb") # opening file read + binary

         binfile.each_codepoint do |bytes|
           @virtual_file.push(bytes.to_s(16))
         end    
         
         @virtual_file.each do |array_byte|
           array_byte= (array_byte.size == 1) ? "0" + array_byte.to_s : array_byte
           #puts array_byte
           @virtual_file_mem.push(array_byte)
         end
       rescue Exception => e
         puts "Error when opening the file: #{e.message}"
       else
         outcome=sig_check # do signature check
         binfile.close
       end
     end
     #puts @virtual_file_mem.inspect
     outcome
  end

  def report
     str=""
     @reported_signatures.each do |s|
          str+="\nFound: #{s[:filetype]} | Magic: #{s[:signature]}\nMore info: "
          s[:ref].each{ |r| str+="\n\t"+r}
          str+="\n"
     end
     str
  end

  def clean_virtual_file_vars
         @virtual_file.clear
         @virtual_file_mem.clear 
  end

  def generate_html_report(output_html_file_location="output.html")
     File.open(output_html_file_location, "w+") do |f|
          output=""
          @reported_signatures.each { |s| references="";s[:ref].each{ |r| references+="<a href='#{r}'>#{r}</a></br>"};output+="<li>Found: #{s[:filetype]} | Magic: #{s[:signature]} <br/><div class='references'ref>More info:<br/>#{references}</div></li>"  }
          f.write(TEMPLATE.gsub("<<TITLE>>","Magic number scanner").gsub("<<REPORT>>",output))
     end
  end
end

