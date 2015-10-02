



class Minesweeper
  def initialize(boardX = 9,boardY = 9, bombs = 15)
    @board = Board.new(boardX, boardY, bombs)
  end

  def reveal(pos)
    @board[pos[0]][pos[1]].revealed = true
    if @board[pos[0]][pos[1]].revealed
      game_over
    end
    @board.render
  end

  def flag_bomb(pos)
    @board[pos[0]][pos[1]].flagged = true
    @board.render
  end

  def game_over
    puts "Game Over"
  end

  def prompt_user
    puts "Enter command"
    puts "reveal, flag, ping"
    command = gets.chomp

    puts "Enter position in ?,?"
    pos = gets.chomp

    reader(command,pos)
  end

  def reader(command,pos)
    if command == "reveal"
      reveal(pos)
  end

end


CONSTANTS = [[-1 , -1] , [-1 , 0] , [-1 , 1],
             [0 , -1]             , [0 , 1],
             [1 , -1] ,  [1 , 0]  , [1 , 1]]

class Tile
  attr_accessor :value

  def initialize(pos, board)
    @bombed = false
    @flagged = false
    @revealed = true
    @position = pos
    @value = 0
    tile_board = board
  end

  # def value= (value)
  #   @value =  value
  # end

  def revealed
    @revealed
  end

end



class Board
  def initialize(boardX, boardY, bombs)
    @board_size = [boardX,boardY]
    @boardX = boardX
    @boardY = boardY
    @bombs = bombs
    @board = board_maker
    put_numbers

  end

  def board_maker
    making_board = Array.new(@boardX){Array.new(@boardY)}
    making_board.each_with_index do | row, idx1 |
      row.each_with_index do | col, idx2 |
        making_board[idx1][idx2] = Tile.new([idx1,idx2], self)
      end
    end
      making_board.flatten.sample(@bombs).each{|tile| tile.value = 9}
      making_board
  end

  def put_numbers
    @board.each_with_index do | row, idx1 |
      row.each_with_index do | col, idx2 |
        if @board[idx1][idx2].value == 0
          @board[idx1][idx2].value = surroundings([idx1,idx2])
        end
      end
    end
  end


  def in_bounds?(pos)
    pos[0].between?(0,@board.length-1) && pos[1].between?(0,@board[0].length-1)
  end

  def surroundings(pos)
    around = 0
    CONSTANTS.each do |el|
      if in_bounds?([el[0] + pos[0] , el[1] + pos[1]])
        if @board[el[0] + pos[0]][el[1] + pos[1]].value == 9
        around += 1
        end
      end
    end
    around
  end

  def render
    @board.each_with_index do | row, idx1 |
      row.each_with_index do | col, idx2 |
        if @board[idx1][idx2].flagged
          print 'F'
          if @board[idx1][idx2].revealed
            if @board[idx1][idx2].value == 0
              print '_'
            else
            print @board[idx1][idx2].value
            end
          else
            print '*'
          end
        end
        print ' '
      end
      puts
    end
  end

end
