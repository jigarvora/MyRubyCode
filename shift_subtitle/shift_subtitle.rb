#!/usr/bin/env ruby
require 'optparse'
require 'time'

puts "hi!\n"
options = {}

opt_parser = OptionParser.new do |opt|
  opt.banner = "Usage: shift_subtitle [OPERATION] [TIME] input_file output_file"
  opt.separator  ""

  opt.on("-o","--operation OPERATION","which operation do you want to execute") do |operation|
	options[:operation] = operation
 end
	
  opt.on("-t","--time TIME","How much to add or subtract?") do |time|
	if(time =~ /(\d+),(\d+)/)
		puts "Inside if\n";
		options[:secsToAdd] = $1
		options[:milliSecsToAdd] = $2
	end
  end
  
   # This displays the help screen, all programs are
   # assumed to have this option.
   opt.on( '-h', '--help', 'Display this screen' ) do
     puts opt
     exit
   end
    
end
opt_parser.parse!
puts "Operation = #{options[:operation]}\n"
puts "Secs to add = #{options[:secsToAdd]}\n"
puts "Millisecs to add = #{options[:milliSecsToAdd]}\n"

readName = ARGV[0]
writeName = ARGV[1];
#ARGV.each do |f|
#  puts "Arg: #{f}..\n"
#end

writeFile = File.open(writeName,"w")
puts readName
puts writeName

begin
	puts options[:secsToAdd]
	File.open(readName, "r") do |aFile|
		amountToShift = options[:secsToAdd].to_i + (options[:milliSecsToAdd].to_i)/1000.0
		puts "AmountToShift = #{amountToShift}\n"
  		aFile.each do |line|
		   if(line =~ /^([0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3})\s*-->\s* ([0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3})/)

		   		print line
				startTime = Time.parse($1)
				endTime = Time.parse($2)
				
				puts startTime
				puts endTime
				if(options[:operation] =~ /add/i)
					print "Adding..\n"
					startTime = startTime + amountToShift
					endTime = endTime + amountToShift
				else
					print "Subtracting..\n"
					startTime = startTime - amountToShift
					endTime = endTime - amountToShift
				end
				startUsec = startTime.usec/1000
				endUsec = endTime.usec/1000
				startUsec = sprintf("%.3d", startUsec)
				endUsec = sprintf("%.3d", endUsec)
				startStrForm = "#{startTime.strftime('%H:%M:%S')},#{startUsec}"
				endStrForm = "#{endTime.strftime('%H:%M:%S')},#{endUsec}"										
				writeFile.write("#{startStrForm} --> #{endStrForm}\n")
			else
				writeFile.write(line)
		    end
		end
	end
rescue Exception => e
 	puts e.message
	#puts e.backtrace.inspect
end	

writeFile.flush and writeFile.close
#puts "------"
#a = Time.at(04,283)
#puts a.usec
#timeToAdd = Time.at(2,500)
#b = a.send(:+,2.5)
#usec = b.usec / 1000
#usec = sprintf("%.3d",usec)
#puts usec