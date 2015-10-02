class Minesweeper

end

class GameCode

end


class Tile
  def initialize(pos, board)
    @bombed = false
    @flagged = false
    @revealed = false
    @position = pos
    @value = nil
    tile_board = board
  end

  def value= (value)
    @value =  value
  end

  def reveal
  end

  def neighbors(pos)
      #add values to pos to give all neighbors
      in_bounds?
  end

  def neighbor_bomb_count
  end

  def in_bounds?(pos)
    if pos[0].between?(0,board.length-1) && pos[1].between?(0,board[0].length-1)
  end

end



class Board
  def initialize(boardX = 9,boardY = 9, bombs = 15)
    @board_size = [boardX,boardY]
    @boardX = boardX
    @boardY = boardy
    @board  = board_maker
    @bombs = bombs

  end

  def board_maker
    stack = []
    (@boardX * @boardY) times do
      stack << Tile.new
    end
    bombs times each do |el|
      stack[el].value = 9
    end
    stack = stack.shuffle

    board.map {|el| }
  end
end
