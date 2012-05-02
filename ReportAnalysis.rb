#!/opt/xsite/contrib/bin/ruby -W0

require 'stringio'

class PathInfo
  # Stores information about each fail 
  include Comparable
  @@configArray = Array.new
  @@slackDescrip = Hash.new
  
  def initialize(pathNum, earlyLine, lateLine, pathText, pathSummary)
    # For each fail, generate a hash string and the corresponding hash value. This will be used to compare if two fails are equal. 
	@hashValue = 0
    @hashStr = ""
  
	@pathNum = pathNum
	@earlyPath,@earlyEdge = getNetAndEdge(earlyLine)
	@latePath,@lateEdge = getNetAndEdge(lateLine)
	@pathText = pathText
	@pathText.close_write
	@pathText.rewind
	@pathSummary = pathSummary
	@slack = pathSummary.split[1]
  	@testType = (pathSummary.split[4] == "RAT") ? "RAT" : pathSummary.split[6]
	calcHashValue
  end

  # Sets the configuration array which tells the class which netnames should be considered the same 
  def PathInfo.setConfigArray(arr)
	@@configArray = arr
  end

  # Sets the slackDescrip which a hash which maps a fail prefix to it's full description 
  def PathInfo.setSlackDescrip(sd)
	@@slackDescrip = sd
  end

  # Returns a well-formatted summary of the fail. 
  def summary
	str = "#{@pathSummary}\n\n#{@testType} = #{@@slackDescrip[@testType]}\n\nPath = #{@pathNum}\nSlack = #{@slack}\n"
	if(@earlyPath.length > 0)
	  str = str + "EP = #{@earlyPath} #{@earlyEdge}\n"
	end
	if(@latePath.length > 0)
	  str = str + "LP = #{@latePath} #{@lateEdge}\n"
	end
	str = str + "\n"
  end

  # Returns the netname and edge in the line 
  def getNetAndEdge(line)
	return "","" if (line == nil || line.length == 0)
    likelyIndex = 2
    likelyIndex = 1 if ((line !~ /->/) && line.split[0] !~ /^\d+$/)

    net = line.split[likelyIndex-1]
    edge = line.split[likelyIndex]

	if(line.split[likelyIndex] !~ /(R|F)/)
	  edge = net[net.length-1,net.length-1]
	  net = net[0,net.length-1]
    end
	return net,edge
  end

  # Generates the hash string based on the class fields and the corresponding hash value 
  def calcHashValue
	earlyAndLatePaths = "#{@earlyPath} #{@latePath}"
	@@configArray.each_with_index do |item,index|
	  earlyAndLatePaths.gsub!(/(#{item.gsub(/\s*,\s*/,'|')})/,index.to_s)
	end	
	
	@hashStr = "#{@testType} #{earlyAndLatePaths} #{@earlyEdge} #{@lateEdge}"
	@hashValue = @hashStr.hash
  end	  

  # Old hash value function (for bkup) 
  def calcHashValue2
	earlyAndLatePaths = "#{@earlyPath} #{@latePath}"
	#puts "Converting #{earlyAndLatePaths}\n"
	@@configArray.each_with_index do |item,index|
	  #puts "Replacing #{item} with #{index.to_s}\n"
	  earlyAndLatePaths.gsub!(/(#{item.gsub(/\s*,\s*/,'|')})/,index.to_s)
	  #puts "Converted  #{earlyAndLatePaths}\n"
	end	
	#puts "Converted  #{earlyAndLatePaths}\n"
	
	@hashStr = "#{@testType} #{earlyAndLatePaths.length} #{@earlyEdge} #{@lateEdge}"
	#puts "Converting the following to hash: #{str}\n"
	@hashValue = @hashStr.hash
  end	  

  # Comparable: Use hash value to compare two fails to see if they're the same 
  def <=>(other)
	#puts "\n in here #{@hashValue} #{other.getHashValue}"
	return (@hashValue <=> other.getHashValue)
  end
  
  # Returns the hash value of the failure instance 
  def getHashValue
	return @hashValue
  end

  attr_reader  :hashStr, :pathText, :pathNum
  protected    :getHashValue

end

# Read the config file to determine the netnames that should be considered similar. The config file may contain regular expressions. 
def readConfigFile(configFile)
   if(FileTest.exist?(configFile))
     configArray = Array.new
	 lines = `grep -v -E "(^#|^\s*$)" #{configFile}`
	 lines.split("\n").each {|s| configArray.push(s) }
	 PathInfo.setConfigArray(configArray)   
   else
	puts "Warning! Config file not found: #{configFile}...Continuing without it..\n"
  end
end

# Outputs the summary of the unique fails that were found 
def outputFiles(myUniquePaths)
 slackSummaryFile = "detailAnalysis/slackSummary.txt"
 File.open(slackSummaryFile,'w') do |f|
   myUniquePaths.each do |s|
	 f.puts(s.summary)
	 f.puts("--------------------------------------------------\n")
	 File.open("detailAnalysis/#{s.pathNum}.txt",'w') do |f2|
	  f2.puts(s.pathText.read)
	end
   end
 end
end

# MAIN FUNCTION 

# Run some preliminary analysis on the Unique Paths file. Outputs the fails in sorted order, etc. 

numArgs = ARGV.length
if (numArgs > 2 || numArgs == 0) 
  puts "usage:  <epEarly.gz or epLate.gz> <Optional Flag Specifying the location of config file (see /afs/apd/u/jvora/bin/tltDetailAnalysis_configFiles for example)>"
  exit
end

puts("Starting detailAnalysis. Please wait...\n")

pathsFile = ARGV[0].strip
configFile = ""
if (numArgs == 2)
  configFile = ARGV[1].strip
else
  techid = `echo $CTECHIPID`.strip
  proj = `echo $CTEPROJNAME`.strip
  if((techid.length == 0) || (proj.length == 0))
	puts "Error: Must run in CTE environment\n"
	exit
  end
  macro = pathsFile.split(".")[0]
  configFile = "/afs/apd/u/jvora/bin/tltDetailAnalysis_configFiles/#{proj}_#{techid}_#{macro}.txt"
  puts("Since you didn't specify a config file, I'm using #{configFile}\n")
end

unsortedFile = "detailAnalysis/unsorted_original.txt"
sortedFile = "detailAnalysis/sorted_original.txt"

`rm -r detailAnalysis`
`mkdir detailAnalysis`

pathSumLineStart = `gzcat #{pathsFile} | head -2000 | grep -n "WORST SLACK SUMMARY:" | awk 'BEGIN { FS = ":" } ; {print $1 }'`.to_i + 4

pathSumLineEnd = `gzcat #{pathsFile} | head -#{pathSumLineStart + 1050} | grep -n -E "[[:space:]]+Test[[:space:]]+netName" | awk 'BEGIN { FS = ":" } ; {print $1 }'`.to_i - 2

`gzcat #{pathsFile} | sed -n '#{pathSumLineStart},#{pathSumLineEnd}p' > #{unsortedFile}`
`sort -k 7,7 -k 2,2n #{unsortedFile} > #{sortedFile}`

pathSummaryInfo = Hash.new
File.open(unsortedFile, 'r') do |f|
  lineNum = 1
  while line = f.gets
	pathSummaryInfo[lineNum] = line
	lineNum = lineNum+1
  end
end


causeSlackLineStart = `gzcat #{pathsFile} | head -2000 | grep -n "Cause of Slack" | awk 'BEGIN { FS = ":" } ; {print $1 }'`.to_i + 2
causeSlackDataSplit = `gzcat #{pathsFile} | sed -n '#{causeSlackLineStart-2},#{causeSlackLineStart-2}p'`

 
causeSlackIndex = causeSlackDataSplit.index('Cause of Slack')
abbrevIndex = causeSlackDataSplit.index('Abbreviation')
descripIndex = causeSlackDataSplit.index('Comparison/Description')
causeSlackLineEnd = pathSumLineStart - 5

causeSlackText = `gzcat #{pathsFile} | sed -n '#{causeSlackLineStart},#{causeSlackLineEnd}p'`

slackDescrip = Hash.new

causeSlackText.split("\n").each do |s|
  if(s.strip.length > 0)
    abbrev = s[abbrevIndex..(descripIndex-1)].strip
    descrip = s[descripIndex..1000].strip
    slackDescrip[abbrev] = descrip
  end	
end


PathInfo.setSlackDescrip(slackDescrip)
readConfigFile(configFile)

myUniquePaths = Array.new
pathNum,isEarlyTrace = 0,0
earlyLine,lateLine,lastLine,lastValidLine = Array.new(4,"")
pathText = StringIO.new
myUniquePaths = Array.new


# Scan the file and analyze each fail. Identify the unique fails and load it into the "myUniquePaths" array. 
`gzcat #{pathsFile} | sed -n '#{pathSumLineEnd+3},\$p'`.split("\n").each do |s|
  #puts s
  if(s =~ /^-{20,}/)
	if(pathText.size > 0)
	  if(lastLine !~ /CPPR did not analyze/)
		  (isEarlyTrace == 1) ? earlyLine = lastValidLine : lateLine = lastValidLine
	  end

	  pathInst = PathInfo.new(pathNum, earlyLine, lateLine, pathText, pathSummaryInfo[pathNum])
	  isUnique = 1
	  myUniquePaths.each do |path|
		if(path == pathInst)
		  isUnique = 0
		end
	  end

	  if(isUnique == 1)
		myUniquePaths.push(pathInst)
	  end
	end

	pathNum = pathNum + 1
	isEarlyTrace = 0
	earlyLine,lateLine,lastLine,lastValidLine = Array.new(4,"")
	pathText = StringIO.new
  else
	pathText << s + "\n"
	lastValidLine = s if(s !~ /internal\s+timing/)
	if(s =~ /Early Mode/)
	  isEarlyTrace = 1
	elsif(s =~ /Late Mode/)
	  isEarlyTrace = 0
	elsif(s =~ /^\s*#{pathNum}\s+/)
	  (isEarlyTrace == 1) ? earlyLine = lastValidLine : lateLine = lastValidLine
	end

	if(s =~ /\S/)
	  lastLine = s
	end

  end
end  

# Output the unique fails 
outputFiles(myUniquePaths)
