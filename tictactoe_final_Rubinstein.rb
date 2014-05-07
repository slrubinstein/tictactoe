=begin

Tic Tac Toe!

To play our game, we've created an array of 9 items
to correspond with the 9 cells on a tic tac toe grid.
 
           1 | 2 | 3
          ___________
           4 | 5 | 6
          ___________
           7 | 8 | 9

Each cell begins as $e = 'empty'

As the human or computer mark cells, the cell turns 
to $x = 'X' or $o = 'O'.

At the same time the player aquires the number associated
with that cell as a "point". After each turn the game checks
to see if either player has points that would meet a winning
condition. If so, that player wins the game. If there is no
winner and all cells are marked, it is a cat's game.

=end

# First, we define our variables for each cell. They can be
# empty, X, or O. Each cell will begin the game as 'empty'.

$e = 'empty'
$x = 'X'
$o = 'O'

# A method to display the grid to the user.
# We will call this method at the beginning of each human
# turn. The method calls the array 3 items at a time to 
# display the array in a 3 x 3 grid.

def show_grid(current_grid)
  puts
  show_line(current_grid, 0, 2)
  show_line(current_grid, 3, 5)
  show_line(current_grid, 6, 8)
  puts
end

# A helper method to separate the array into 3 lines of 3 items.
# This method will check each itme in the grid and display it as
# empty, X, or O depending on if it has been marked.

def show_line(current_line, start, finish)
  for n in start..finish
    if current_line[n] == $e
      print '[   ]'
    elsif current_line[n] == $x
      print '[ X ]'
    else
      print '[ O ]'
    end
    n += 1
  end
  puts
end

# A method for the human to take his/her turn.
# The order of the round goes:
# 1. display current game board.
# 2. Solicit a move from the human.
# 3. Check that the move is legal. (ie. between 1-9 and an empty cell)
# 4. Change that cell to an X.
# 5. Add that cell number as a point to human's points array.

def player_turn 
  puts
  puts 'Current board'
  show_grid($game_grid)
  
  puts 'Mark an X by choosing a number.'
  move = gets.chomp
  
  if move.to_i.between?(1,9)
    add_X(move.to_i)
  elsif move == 'quit'
    exit

#  a call to print out points for debugging purposes

#  elsif move == 'print points'
#    puts "player points: #{$player_points}"
#    puts "computer points: #{$computer_points}"
#    puts $game_grid

  else
    puts 'That is not a legal move'
    player_turn
  end
end

# A method to check if the cell is empty, and if so 
# change it to X and add its number to human's points

def add_X(move)
  if $game_grid[move-1] == $e
    $game_grid[move-1] = $x
    $player_points << move
    $player_points = $player_points.sort
  else
    puts 'That is not a legal move.'
    player_turn
  end
end

# A method for the computer to take a turn and mark O.
# We've added some basic strategy for the first round
# to try and avoid a game that is too simple.
# Generally, the computer picks a random cell to mark.
# The method checks to make sure the random cell is empty
# or it will repeat the process and choose a new random.

def computer_turn
  
  #If it is the first round, we implement 'first round strategy'.

  if $computer_points == []
    computer_move = first_round_strategy(computer_move)
  else
    computer_move = rand(9)
  end

  if $game_grid[computer_move] == $e
    $game_grid[computer_move] = $o
    $computer_points << (computer_move + 1)
    $computer_points = $computer_points.sort
    puts
  else
    computer_turn
  end
end
  
# Very basic first round strategy to try and avoid a super
# easy game. This method checks if the human marked a corner
# on his/her first move and if so chooses the opposite corner
# as the computer's move. If the human did not mark a corner,
# it returns a random number for the computer's move.

def first_round_strategy(computer_move)
  if $player_points == [1]
    computer_move = 8
  elsif $player_points == [3]
    computer_move = 6
  elsif $player_points == [7]
    computer_move = 2
  elsif $player_points == [9]
    computer_move = 0
  else
    computer_move = rand(9)
  end
  return computer_move
end

# This is the main game method. It resets the grid to
# completely empty and the player and computer points
# to empty. We set the variable $win to false, and unless
# it turns true, the game carries out as: human turn,
# check win conditions, computer turn, check win conditions.

def game
  $game_grid = [$e, $e, $e, $e, $e, $e, $e, $e, $e]
  $player_points = []
  $computer_points = []
  $win = false
  
  while $win == false
    player_turn  
    check_win
    computer_turn
    check_win
  end
end

# Based on our numbering system you win if you have:
# [1,2,3], [4,5,6], [7,8,9], [1,4,7], [2,5,8], [3,6,9],
# [1, 5, 9], [3, 5, 7]
# After each human and computer turn, we check if 
# winning conditions have been met. 
# First we check to see if either player has a winning
# conditions combination in their points. If not, we check 
# if there are any empty spaces left. If neither player has
# winning conditions and there are no more empties, it is
# a cat's game. Depending on who won, we pass a variable to
# the win_game method. Otherwise, the game continues.

def check_win
  win_conditions = [[1,2,3], [4,5,6], 
  [7,8,9], [1,4,7], 
  [2,5,8], [3,6,9],
  [1, 5, 9], [3, 5, 7]]
  
  win_conditions.each do |c|
    if $player_points & c == c
      $win = true
      win_game('human')
    elsif $computer_points & c == c
      $win = true
      win_game('computer')
    end
  end
  if $game_grid & [$e] == []
    win_game('tie')
    $win = true
  end
end

# A method to declare a winner and ask if the human
# wants to play another game.

def win_game winner
  show_grid($game_grid)
  
  if winner == 'human'
    puts 'Rats! You win!'
  elsif winner == 'computer'
    puts 'Ha ha ha! You lose!'
  elsif winner == 'tie'
    puts 'Cat\'s game!'
  end
 
# Printing out points for debugging purposes 
  
#  puts "Points:"
#  puts "player points: #{$player_points}"
#  puts "computer points: #{$computer_points}"
#  puts $game_grid
  
  while true
    puts 'Would you like to play again?'
    answer = gets.chomp.downcase
    if answer == 'yes'
      puts 'Another game coming right up.'
      game
    elsif (answer == 'quit') || (answer == 'no')
      puts 'Goodbye!'
      exit
    else
      puts "I do not understand '#{answer}'."
      puts 'Please type "yes" or "quit:".'
    end
  end
end

# The game instructions are printed out when the 
# file is initially loaded.

def welcome
  puts
  puts 'Welcome to Tic Tac Toe!'
  puts 'The goal is to choose 3 boxes in a line,'
  puts 'horizontally, vertically, or diagonally.'
  puts '(press Enter to continue)'
  continue = gets.chomp
  puts 'This is your game board:'
  puts '[ 1 ][ 2 ][ 3 ]'
  puts '[ 4 ][ 5 ][ 6 ]'
  puts '[ 7 ][ 8 ][ 9 ]'
  puts 'You can choose a box by entering its number.'
  puts 'You can also quit anytime by typing "quit".'
  puts '(press Enter to continue)'
  continue = gets.chomp
  puts 'Are you ready to play?'
  puts 'Type: "yes" to play, "quit" to exit, or anything else'
  puts 'to repeat the instructions.'
  continue = gets.chomp
  if continue.downcase == 'yes'
    game
  elsif continue.downcase == 'quit'
    puts 'Goodbye!'
    exit
  else
    welcome
  end
end

# We call the welcome method to start the game.

welcome