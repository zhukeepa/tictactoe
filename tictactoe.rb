def opposite(symbol)
  symbol == 'x' ? 'o' : 'x'
end

class Board
  # The tic tac toe board is stored as an array of 9 chars, where each char is either o, x, or _.
  def initialize(board = ['_']*9)
    @board  = board
  end

  def replace(pos, player)
    @board[pos] = player
  end

  def empty_at?(pos)
    return @board[pos] == '_'
  end

  def full?
    @board.count('_') == 0
  end

  def print
    puts @board[0..2].join(' ')
    puts @board[3..5].join(' ')
    puts @board[6..8].join(' ')
  end 

  def has_winner?(player)
    # center square
    if @board[4] == player
      if (@board[1] == player && @board[7] == player) || 
         (@board[3] == player && @board[5] == player) ||
         (@board[0] == player && @board[8] == player) ||
         (@board[2] == player && @board[6] == player)
        return true
      end
    end

    # assume center square is blocked. what about right lower corner? 
    if @board[8] == player
      if (@board[5] == player && @board[2] == player) ||
         (@board[7] == player && @board[6] == player)
        return true
      end
    end

    # that's blocked too. what about upper left corner? 
    if @board[0] == player
      if (@board[1] == player && @board[2] == player) ||
         (@board[3] == player && @board[6] == player)
        return true
      end
    end

    # welp, guess you didn't win! 
    return false
  end

  # returns any move for the player that can lead to an optimal outcome. 
  def best_move_for(player)
    return minimax(player)[1]
  end

private
  # returns [outcome, move]. outcome is 1 if you can win, 0 if tie is forced, -1 if loss is forced. 
  # move is the move that gets you your best outcome (it can be nil if your best outcome is -1).
  def minimax(player)
    opponent = opposite(player)
    
    # endgame cases    
    return -1, nil if has_winner?(opponent)
    return  1, nil if has_winner?(player)
    return  0, nil if full?

    # manually deal with empty board to speed up calculation. 
    return 0, 4 if @board.count('_') == 9

    best_outcome, best_move = -1, nil
    for i in 0..8
      if @board[i] == '_'
        # Temporarily fill in the space with the current player, and find opponent's best move in
        # response to that. Then replace it with an empty space to get the original board, and proceed. 
        @board[i] = player
        outcome   = -minimax(opponent)[0]
        @board[i] = '_'

        if outcome > best_outcome
          best_outcome, best_move = outcome, i
        end
      end
    end

    return best_outcome, best_move
  end
end


def play_tic_tac_toe
  puts 'Are you x or o?'
  player = gets.chomp
  
  while player != 'x' && player != 'o'
    puts 'You must enter x or o!'
    player = gets.chomp
  end
  
  b = Board.new

  puts "\nWhenever it is your turn, enter the number of your move based on the diagram below:"
  puts "1 2 3\n4 5 6\n7 8 9"

  if player == 'x'
    puts "\n"
    b.print
  end

  current = 'x'
  while true
    if current == player
      puts "\nEnter your move: "

      # indices shown to user start at 1, not 0
      move = gets.chomp.to_i - 1
      while !b.empty_at?(move) || move < 0 || move >= 9
        puts "Please enter a valid position."
        move = gets.chomp.to_i - 1
      end

      b.replace(move, player)
    else
      move = b.best_move_for(current)
      b.replace(move, current)
      puts "The AI has moved at position #{move+1}.\n\nCurrent board:\n"
      b.print
    end

    # check if game ended, and if it did, exit. 
    if b.has_winner?(current)
      puts "#{current == player ? 'You' : 'The AI'} won!"
      break
    elsif b.full?
      puts 'The game is a tie!'
      break
    end

    current = opposite(current)
  end

  puts "\nPlay again? (y/n)"
  response = gets.chomp
  while response != 'y' && response != 'n'
    puts "Please enter either 'y' or 'n'."
    response = gets.chomp
  end

  if response == 'y'
    puts "\n"
    play_tic_tac_toe # the recursion won't ever get too deep, so whatever. 
  end
end