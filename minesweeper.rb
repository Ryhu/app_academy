require "byebug"
class Minesweeper
  attr_reader :board

  def initialize(boardX = 9,boardY = 9, bombs = 15)
    @board = Board.new(boardX, boardY, bombs)
    @win_count = 0
  end

  def reveal(pos)
    @board[pos].revealed = true
    @board.render
    if @board[pos].bombed?
      game_over
    else
      @win_count += 1
      if win_check
        return "YOU WINNNNNN"
      end
      if @board[pos].value == 0
        zero_propegate(pos)
      else
        prompt_user
      end
    end
  end


  def zero_propegate(pos)
    CONSTANTS.each do |el|
      if self.board.in_bounds?([el[0] + pos[0] , el[1] + pos[1]])
        unless @board[[el[0] + pos[0], el[1] + pos[1]]].revealed?
          reveal(@board[[el[0] + pos[0], el[1] + pos[1]]].position)
        end
      end
    end
  end

  def win_check
    @win_count == @board.boardX * @board.boardY - @board.bombs
  end

  def flag_bomb(pos)
    @board[pos[0]][pos[1]].flagged = true
    @board.render
    prompt_user
  end

  def game_over
    puts "Game Over"
  end

  def prompt_user
    pos = []
    puts "Enter command"
    puts "reveal, flag"
    command = gets.chomp

    puts "Enter position in ?,?"
    pos = gets.chomp.split(',').map(&:to_i)

    reader(command,pos)
  end

  def reader(command,pos)
    if command == "reveal"
      reveal(pos)
    elsif command == "flag"
      flag_bomb(pos)
    elsif command == "ping"
      ping(pos)
    else
      prompt_user
      "learnt o type muffa"
    end
  end

end


CONSTANTS = [[-1 , -1] , [-1 , 0] , [-1 , 1],
             [0 , -1]             , [0 , 1],
             [1 , -1] ,  [1 , 0]  , [1 , 1]]

class Tile
  attr_accessor :value, :position

  def initialize(pos, board)
    @bombed = false
    @flagged = false
    @revealed = false
    @position = pos
    @value = 0
    tile_board = board
  end

  # def value= (value)
  #   @value =  value
  # end

  def revealed?
    @revealed
  end

  def revealed= (boolean)
    @revealed = boolean
  end

  def bombed?
    @bombed
  end

  def bombed= (boolean)
    @bombed = boolean
  end

  def flagged?
    @flagged
  end

  def in_bounds?(pos)
    pos[0].between?(0,@board.length-1) && pos[1].between?(0,@board[0].length-1)
  end
end




class Board
  attr_reader :boardX, :boardY, :bombs

  def initialize(boardX, boardY, bombs)
    @board_size = [boardX,boardY]
    @boardX = boardX
    @boardY = boardY
    @bombs = bombs
    @board = []
    board_maker
    put_numbers
  end

  def [](pos)
    x,y = pos
    return @board[x][y]
  end

  def board_maker
    making_board = Array.new(@boardX){Array.new(@boardY)}
    making_board.each_with_index do | row, idx1 |
      row.each_with_index do | col, idx2 |
        making_board[idx1][idx2] = Tile.new([idx1,idx2], self)
      end
    end
      making_board.flatten.sample(@bombs).each{|tile| tile.bombed = true}
      @board = making_board
  end

  def board= (board)
    @board = board
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
        if @board[el[0] + pos[0]][el[1] + pos[1]].bombed? == true
        around += 1
        end
      end
    end
    around
  end


  def render
        @board.each_with_index do | row, idx1 |
          row.each_with_index do | col, idx2 |
                if @board[idx1][idx2].flagged?
                  print 'F'
                else
                      if @board[idx1][idx2].revealed?
                            if @board[idx1][idx2].value == 0
                              print '_'
                            elsif @board[idx1][idx2].bombed?
                              print 'X'
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
