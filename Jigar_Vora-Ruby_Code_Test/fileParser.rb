require 'date'

class FileParser

  def self.parse(fileName, delimiter, fieldNames)
	myRecords = Array.new()
    begin
		File.open(fileName, "r") do |file|
		  file.each_line do |line|
			lineData = line.split(delimiter)
			if(lineData.length != fieldNames.length)
			  puts "Warning: Ignoring the following line in #{fileName}. The number of fields don't match the # of field names."
			  puts "#{line}"
			else			  
			  lineHash = Hash.new("")
			  lineData.each_with_index do |data,index|
				data.strip!				
				if(fieldNames[index] == :gender) 
				  data = cleanGender(data)
				elsif(fieldNames[index] == :dob)
				  data = getDate(data)
				end
				lineHash[fieldNames[index]] = data
			  end
			  myRecords << lineHash
			end
			  
		  end
		end
	rescue => err
	  puts "Exception: #{err}. Ignoring file.."
	  err
    end
	return myRecords
  end  

  private
  def self.cleanGender(gender)
	if(gender =~ /^M/) 
	  return "Male"
	end
	return "Female"
  end

  def self.getDate(dateStr)
   	m,d,y=dateStr.split(/(-|\/)/)-["/", "-"]
	return Date.new(y.to_i,m.to_i,d.to_i)
  end

end	

