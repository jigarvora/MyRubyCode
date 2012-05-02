require 'date'
require File.join(File.dirname(__FILE__),'fileParser')

class RecordsOrganizer

  attr_reader :output
  def initialize(outFileName='tmp.txt')
	# Initial Setup
    @masterList = Array.new()
	@outFormat = Array.new()
	@outFileName = outFileName

	inputFilesDir = File.join(File.dirname(__FILE__),'input_files')
	@masterList << FileParser.parse(File.join(inputFilesDir,'pipe.txt'),'|',[:lastName,:firstName,:middle_initial,:gender,:favorite_color,:dob])
	@masterList << FileParser.parse(File.join(inputFilesDir,'space.txt'),' ',[:lastName,:firstName,:middle_initial,:gender,:dob,:favorite_color])
	@masterList << FileParser.parse(File.join(inputFilesDir,'comma.txt'),',',[:lastName,:firstName,:gender,:favorite_color,:dob])
	@masterList.flatten!

	# Set the output format
	@outFormat = [:lastName, :firstName, :gender, :dob, :favorite_color]

	sortAndPrint
  end

  def sortAndPrint
	@myOutFile = File.new(@outFileName,"w")
	@masterList.sort! do |record1,record2|
	  record1[:gender] == record2[:gender] ? record1[:lastName] <=> record2[:lastName] : record1[:gender] <=> record2[:gender]
	end
	@myOutFile.puts("Output 1:")
	printRecords

	@masterList.sort! do |record1,record2|
	  record1[:dob] == record2[:dob] ? record1[:lastName] <=> record2[:lastName] : record1[:dob] <=> record2[:dob]
	end
	@myOutFile.puts("Output 2:")
	printRecords

	@masterList.sort! do |record1,record2|
	  record2[:lastName] <=> record1[:lastName]
	end
	@myOutFile.puts("Output 3:")
	printRecords

	@myOutFile.close

	File.open(@outFileName,"r") do |aFile|
	  puts (@output = aFile.readlines)
	end

  end
	
  def printRecords
	@masterList.each do |record|
	  tmp = ""
	  @outFormat.each do |key|	 
		tmp = tmp + ((d=record[key]).kind_of?(Date) ? ("#{d.month}/#{d.day}/#{d.year} "):("#{d} "))
	  end
	  tmp.strip!
      @myOutFile.puts("#{tmp}")
    end
	@myOutFile.print("\n")
  end
end








