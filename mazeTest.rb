require 'test/unit'
require 'maze'

MAZE1 = %{#####################################
# #   #     #A        #     #       #
# # # # # # ####### # ### # ####### #
# # #   # #         #     # #       #
# ##### # ################# # #######
#     # #       #   #     # #   #   #
##### ##### ### ### # ### # # # # # #
#   #     #   # #   #  B# # # #   # #
# # ##### ##### # # ### # # ####### #
# #     # #   # # #   # # # #       #
# ### ### # # # # ##### # # # ##### #
#   #       #   #       #     #     #
#####################################}
# Maze 1 should SUCCEED

MAZE2 = %{#####################################
# #       #             #     #     #
# ### ### # ########### ### # ##### #
# #   # #   #   #   #   #   #       #
# # ###A##### # # # # ### ###########
#   #   #     #   # # #   #         #
####### # ### ####### # ### ####### #
#       # #   #       # #       #   #
# ####### # # # ####### # ##### # # #
#       # # # #   #       #   # # # #
# ##### # # ##### ######### # ### # #
#     #   #                 #     #B#
#####################################}
# Maze 2 should SUCCEED

MAZE3 = %{#####################################
# #   #           #                 #
# ### # ####### # # # ############# #
#   #   #     # #   # #     #     # #
### ##### ### ####### # ##### ### # #
# #       # #  A  #   #       #   # #
# ######### ##### # ####### ### ### #
#               ###       # # # #   #
# ### ### ####### ####### # # # # ###
# # # #   #     #B#   #   # # #   # #
# # # ##### ### # # # # ### # ##### #
#   #         #     #   #           #
#####################################}
# Maze 3 should FAIL

MAZE7 = %{##############
#A #
######## ## ##
#B #
##############}

MAZE8 = %{##############
#A #
########### ##
#C #
##############}

class MazeTest < Test::Unit::TestCase
   #myM = Maze.new(MAZE1)
   
   def test_good_mazes
     assert_equal true, Maze.new(MAZE1).solvable?
     assert_equal true, Maze.new(MAZE2).solvable?
	 assert_equal true, Maze.new(MAZE7).solvable?
   end
 
   def test_bad_mazes
     assert_equal false, Maze.new(MAZE3).solvable?
	 assert_equal false, Maze.new(MAZE8).solvable?
   end
 
   def test_maze_steps
     assert_equal 44, Maze.new(MAZE1).steps
     assert_equal 75, Maze.new(MAZE2).steps
     assert_equal 0, Maze.new(MAZE3).steps
	 assert_equal 16, Maze.new(MAZE7).steps
	 assert_equal 0, Maze.new(MAZE8).steps
   end
end

