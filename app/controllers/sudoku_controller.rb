class SudokuController < ApplicationController
  def index
    @board ||= [[5,3,0,0,7,0,0,0,0],
              [6,0,0,1,9,5,0,0,0],
              [0,9,8,0,0,0,0,6,0],
              [8,0,0,0,6,0,0,0,3],
              [4,0,0,8,0,3,0,0,1],
              [7,0,0,0,2,0,0,0,6],
              [0,6,0,0,0,0,2,8,0],
              [0,0,0,4,1,9,0,0,5],
              [0,0,0,0,8,0,0,7,9]]
  end

  def submit

    @board = Array.new(9) { Array.new(9, 0) }
    array_params = params.require(:array).permit!
    array_params.to_h.each_with_index do |(row_key, row), i|
      row.each_with_index do |(col_key, col), j|
        @board[i][j] = col.to_i
      end
    end

    if valid_sudoku?(@board)
      flash[:notice] = "Solution is right"
    else
      flash[:alert] = "Solution is wrong"
    end
  end

  def auto
    @board ||= [[5,3,0,0,7,0,0,0,0],
                [6,0,0,1,9,5,0,0,0],
                [0,9,8,0,0,0,0,6,0],
                [8,0,0,0,6,0,0,0,3],
                [4,0,0,8,0,3,0,0,1],
                [7,0,0,0,2,0,0,0,6],
                [0,6,0,0,0,0,2,8,0],
                [0,0,0,4,1,9,0,0,5],
                [0,0,0,0,8,0,0,7,9]]
    solve_sudoku(@board)
  end

  def solve_sudoku(board)
    find_empty_cell = lambda { |row, col|
      9.times { |i| 9.times { |j| return [i, j] if board[i][j] == 0 } }
      nil
    }

    is_valid = lambda { |row, col, num|
      # Check row
      return false if board[row].include?(num)

      # Check column
      return false if board.any? { |r| r[col] == num }

      # Check box
      box_row, box_col = (row / 3) * 3, (col / 3) * 3
      3.times do |i|
        3.times do |j|
          return false if board[box_row + i][box_col + j] == num
        end
      end

      return true
    }

    solve = lambda {
      cell = find_empty_cell.call(0, 0)
      return true if cell.nil?

      row, col = cell
      1.upto(9) do |num|
        if is_valid.call(row, col, num)
          board[row][col] = num
          return true if solve.call()
          board[row][col] = 0
        end
      end

      return false
    }

    solve.call()
  end



  private

def valid_sudoku?(board)
  board.each do |row|
    return false unless row.uniq.size == 9
  end
  9.times do |j|
    column = board.map { |row| row[j] }
    return false unless column.uniq.size == 9
  end
  3.times do |i|
    3.times do |j|
      square = []
      3.times do |ii|
        3.times do |jj|
          square << board[i * 3 + ii][j * 3 + jj]
        end
      end
      return false unless square.uniq.size == 9
    end
  end

  true
end
  end

