#!/usr/bin/env ruby

class Jukebox

	def initialize(playlist)
		@playlist = playlist
		@playlist.each {|a| puts a}
	end
	
	def skip_tracks(i)
	    # JV - BROKEN DEF!!
		
  		start = inc = i % @playlist.size()
  		count = 1
  
	  	while inc > 0 && count < @playlist.size() do
    		c = start
    
		    while (c + inc) % @playlist.size != start
    	  		before = (c - inc) % @playlist.size()
      			@playlist[before], @playlist[c] = @playlist[c], @playlist[before]
      			count = count + 1
      			c = c + 1
    		end
    		count = count + 1
	    	start = start - 1
		end
		puts "New Playlist:"
		@playlist.each {|a| puts a}
	end
	
	# short version (works with both Ruby 1.8 and Ruby 1.9)
	def skip_tracks_18(i)
	  t = (s = @playlist.size) - (h = i % s)
	  s = @playlist.size-1
	  @playlist[0, t], @playlist[t..s] = @playlist[h..s], @playlist[0, h]
	  
      puts "New Playlist:"
	  @playlist.each {|a| puts a}
	end
	
end

playlist = ["a", "b", "c", "d"]
playlist2 = ["a", "b", "c", "d", "e", "f", "g", "h"]

myJuke = Jukebox.new(playlist)
myJuke2 = Jukebox.new(playlist2)

myJuke.skip_tracks(3)
myJuke2.skip_tracks_18(5)


