class Maze
  
  attr_reader :steps

  def initialize(mazeStr)

	@mazeMap = Array.new()
	@costs = Array.new()
	@parent = Array.new()
	@visited = Array.new()

	@startX = 0
	@startY = 0
	@endX = 0
	@endY = 0
	@solvable = false
	@steps = 0

	yCoord = 0
	mazeStr.split("\n").each do |a|
	  @mazeMap[yCoord] = a.split(//)
	  if(@mazeMap[yCoord].index("A"))
		@startY = @mazeMap[yCoord].index("A")
		@startX = yCoord
	  end
	  if(@mazeMap[yCoord].index("B"))
	    @endY = @mazeMap[yCoord].index("B")
		@endX = yCoord
	  end

	  yCoord = yCoord+1
	end
	
	puts "----"
	puts @mazeMap[0][0]
	puts @mazeMap[1][1]
	puts @mazeMap[1][2]
	puts @startX
	puts @startY
	puts @endX
	puts @endY
	
	queue = [[@startX,@startY]]
	@costs[@startX] = Array.new()
	@parent[@startX] = Array.new()
	@costs[@startX][@startY] = 0
	startTraversing(queue)
	#mazeStr.each_char do |a|
	#  if(a == "\n") 
    #		puts a
	#  else
		#puts a
	#  end
	#puts getMoves(5,6)
	#end
  end

  def getMoves(xPos, yPos)
	# North, South, East, West
	moves = Array.new()

	if(@mazeMap[xPos-1][yPos] =~ /(\s|B)/)
	  moves.push([xPos-1,yPos])
	end
	if(@mazeMap[xPos+1][yPos] =~ /(\s|B)/)
	  moves.push([xPos+1,yPos])
	end
	if(@mazeMap[xPos][yPos+1] =~ /(\s|B)/)
	  moves.push([xPos,yPos+1])
	end
	if(@mazeMap[xPos][yPos-1] =~ /(\s|B)/)
	  moves.push([xPos,yPos-1])
	end
	return moves
  end

  def solvable?
	return @solvable
  end

  def startTraversing(queue)
	coord = queue.shift
	xPos = coord[0]
	yPos = coord[1]
	#reached = false
	if(@visited[xPos].nil?)
	  @visited[xPos]=Array.new()
	end
	@visited[xPos][yPos] = 1
	#puts "xPos = #{xPos}, yPos = #{yPos}"
	myMoves = getMoves(xPos,yPos)
	
	
	myMoves.each do |a|
	  moveX = a[0]
	  moveY = a[1]
	  #puts "Checking: #{moveX}, #{moveY}"
	  if(@visited[moveX].nil? || @visited[moveX][moveY].nil? || (@visited[moveX][moveY] == 0))
		if(@costs[moveX].nil?)
		    @costs[moveX] = Array.new()
			@parent[moveX] = Array.new()
		end
		@costs[moveX][moveY] = @costs[xPos][yPos]+1
		@parent[moveX][moveY] = [xPos,yPos]

		if(moveX == @endX && moveY == @endY)
		  print "Reached finish with a cost of #{@costs[moveX][moveY]}"
		  @steps = @costs[moveX][moveY]
		  @solvable = true

		end

		#puts "Adding to queue: #{moveX}, #{moveY}"
		#queue << [moveX, moveY]
		queue.push([moveX, moveY])
	  end
	end
	if(!@solvable && queue.size() > 0)
		startTraversing(queue)
	end
  end


end


