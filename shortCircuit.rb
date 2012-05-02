	
# Use include? to test if a value is in an array
# Use select to get array values that match a particular condition

	
class Circuit

	
	def initialize(nodes)
		nodeNames = *nodes	
		@nameToNode = Hash.new()
		@nodes = []
		@conns = []

	
		nodeNames.each do |n| 
			newNode = Node.new(n)
			@nameToNode[n] = newNode
			@nodes.push(newNode)
		end
		
	end
	
	def addConn(src, dest, weight)
		@nameToNode[src].addConn(@nameToNode[dest], weight)
		@nameToNode[dest].addConn(@nameToNode[src], weight)
		@conns.push([src, dest, weight])
	end
	
	def giveShortestPath(start,finish)
		foundPaths = Hash.new()
		traverse(@nameToNode[start],@nameToNode[finish],"",0,foundPaths)
		leastWeight = -1
		shortPath = ""
		foundPaths.each do |p,w|
			puts "#{p} = #{w}"
			if (leastWeight == -1 || w < leastWeight)
				shortPath = p
				leastWeight = w
			end
		end

		puts "Shortest Path = #{shortPath}  with weight #{leastWeight}"
		shortPathNodes = shortPath.split("=>")
		@remainingNodes = @conns.dup
		#puts @remainingNodes
		for i in 0..(shortPathNodes.size()-2)
			@remainingNodes.delete_if do |x|
				(x[0] == shortPathNodes[i] && x[1] == shortPathNodes[i+1]) || (x[0] == shortPathNodes[i+1] && x[1] == shortPathNodes[i])
			end
			#puts "#{shortPathNodes[i]} to #{shortPathNodes[i+1]}"
		end
		puts "["
		@remainingNodes.each do |x|
			puts "[ #{x.join(",")} ]"
		end
		puts "]"
			
	end
	
	def traverse(start,finish,nodesTravelled,weight,foundPaths)
		if(start == finish)
			nodesTravelled = nodesTravelled + "#{start.name}"
			puts "#{nodesTravelled} = #{weight}"
			foundPaths[nodesTravelled] = weight
		else
			nodesTravelled = nodesTravelled + "#{start.name}=>"
			#puts nodesTravelled
			start.each do |conn,w|
				connName = conn.name
				unless(nodesTravelled =~ /#{connName}/)
					traverse(conn,finish,nodesTravelled,weight+w,foundPaths)
				end
			end	
		end
	end
end


class Node

	@conns = []
    @weights = []
	@fullHash = Hash.new
	attr_reader :name
	
    def initialize(name)
    	@name = name
		@conns = []
		@weights = []
		@fullHash = Hash.new
    end
            
    def addConn(conn, weight)
		@conns.push(conn)
        @weights.push(weight)
    end
	
	def to_s
		puts "Node: #{name}"
		puts "Connections:"
		@conns.zip(@weights) do |c,w|
			puts "#{c.name} => #{w}"
		end
	end
	
	def each
		@conns.zip(@weights) do |c,w|
			yield [c,w]
		end
	end
	
		
end


myCirc = Circuit.new(['a','b','c','d','e','f','g','h'])
myCirc.addConn('a','b',50)
myCirc.addConn('a','d',150)
myCirc.addConn('b','c',250)
myCirc.addConn('b','e',250)
myCirc.addConn('c','e',350)
myCirc.addConn('c','d',50)
myCirc.addConn('c','f',100)
myCirc.addConn('d','f',400)
myCirc.addConn('e','g',200)
myCirc.addConn('f','g',100)
myCirc.giveShortestPath('a','g')
