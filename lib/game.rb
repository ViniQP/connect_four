require 'colorize'

class Game 
  attr_accessor :board, :available_moves

  def initialize(player1, player2)
    @board = Array.new(8) {Array.new(6) { |i| i } }
    @available_moves = Array.new(7) {Array.new(6) { true } }
    @player1 = player1
    @player2 = player2
  end

  def print_board
    board = @board
    board = board.map do |column|
      column.map do |position|

        if position == @player1.player_symbol
          position = @player1.player_symbol.green
        elsif position == @player2.player_symbol
          position = @player2.player_symbol.red
        else position = " "
        end
      end
    end
    puts ''
    puts "| #{board[0][5]} | #{board[1][5]} | #{board[2][5]} | #{board[3][5]} | #{board[4][5]} | #{board[5][5]} | #{board[6][5]} | "
    puts "| #{board[0][4]} | #{board[1][4]} | #{board[2][4]} | #{board[3][4]} | #{board[4][4]} | #{board[5][4]} | #{board[6][4]} | "
    puts "| #{board[0][3]} | #{board[1][3]} | #{board[2][3]} | #{board[3][3]} | #{board[4][3]} | #{board[5][3]} | #{board[6][3]} | "
    puts "| #{board[0][2]} | #{board[1][2]} | #{board[2][2]} | #{board[3][2]} | #{board[4][2]} | #{board[5][2]} | #{board[6][2]} | "
    puts "| #{board[0][1]} | #{board[1][1]} | #{board[2][1]} | #{board[3][1]} | #{board[4][1]} | #{board[5][1]} | #{board[6][1]} | " 
    puts "| #{board[0][0]} | #{board[1][0]} | #{board[2][0]} | #{board[3][0]} | #{board[4][0]} | #{board[5][0]} | #{board[6][0]} | "
    puts "-----------------------------"
    puts '| 0 | 1 | 2 | 3 | 4 | 5 | 6 |'.yellow
  end

  def player_turn(column, player)
    if column > 6
      puts "INVALID OPTION!".red
      print 'CHOOSE ANOTHER COLUMN: '
      return player_turn(gets.chomp.to_i, player)
    end
    turn_location = 0
    @available_moves[column].each do |position|
      if position == true
        @available_moves[column][turn_location] = false
        break
      else
        turn_location += 1
      end
    end
    @board[column][turn_location] = player.player_symbol
  end

  def has_won_vertically?(player)
    streak = 0
    stop_column = false
    @board.each do |column|
        
      column.each do |position|
        if streak == 4
          stop_column = true
          break
        end

        if position == player.player_symbol
          streak += 1
        else 
          streak = 0
        end
      end
      break if streak == 4
      streak = 0 
    end
    streak == 4 ? true : false
  end

  def has_won_horizontally?(player)
    streak = 0
    column_counter = 0
    @board.each do |column|
      position_counter = 0
      column.each do |position|
        break if streak == 4

        if position == player.player_symbol
          streak += 1   
          for i in 1..3 do
            if (column_counter + i) > 6
              streak = 0
              break
            elsif @board[column_counter + i][position_counter] == player.player_symbol
              streak += 1
            else
              streak = 0
              break
            end
          end
        else
          streak = 0
        end

        position_counter += 1
      end

      column_counter += 1
    end
    streak == 4 ? true : false
  end

  def has_won_diagonally?(player)
    streak = 0
    column_counter = 0
    @board.each do |column|
      position_counter = 0
      column.each do |position|
        break if streak == 4

        if position == player.player_symbol
          streak += 1   
          for i in 1..3 do
            if (column_counter + i) > 6 && (position_counter + i) > 5
              streak = 0
              break

            elsif @board[column_counter + i][position_counter + i] == player.player_symbol
              streak += 1
            else
              streak = 0
              break
            end
          end       
        else
          streak = 0
        end
        position_counter += 1
      end

      column_counter += 1
    end
    streak == 4 ? true : false
  end

  def has_won?(player)
    conditions = [self.has_won_vertically?(player), self.has_won_horizontally?(player), self.has_won_diagonally?(player)]
    conditions.include?(true) ? true : false
  end

  def tie?
    @available_moves.all? do |column| 
      column.all?(false)
    end
  end

  def start_game
    count = 1

    loop do 
      self.print_board
      print "Player 1 Move: "
      player_turn(gets.chomp.to_i, @player1)
      if self.has_won?(@player1)
        puts
        puts "Player 1 Wins!".green
        break
      end

      self.print_board
      print "Player 2 Move: "
      player_turn(gets.chomp.to_i, @player2)
      if self.has_won?(@player2)
        puts
        puts "Player 2 Wins!".green
        break
      end

      if tie?
        puts
        puts "TIE!".yellow
        break
      end
    end
    self.print_board
  end
end