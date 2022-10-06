class Game 
  attr_accessor :board, :available

  def initialize(player1, player2)
    @board = Array.new(7) {Array.new(6) { |i| i } }
    @available_moves = Array.new(7) {Array.new(6) { true } }
    @player1 = player1
    @player2 = player2
  end

  def player_turn(column, player)
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
            if (column_counter + i) > 6 && (position_counter + i > 5)
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
end