WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                [[2, 5, 8], [1, 4, 7], [3, 6, 9]] +
                [[1, 5, 9], [3, 5, 7]]

INITIAL_MARKER = ' '.freeze
PLAYER_MARKER = 'X'.freeze
COMPUTER_MARKER = 'O'.freeze

# rubocop:disable Metrics/AbcSize
def display_board(board)
  system 'cls'
  puts "You are #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}."
  puts ""
  puts "     |     |"
  puts "  #{board[1]}  |  #{board[2]}  |  #{board[3]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{board[4]}  |  #{board[5]}  |  #{board[6]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{board[7]}  |  #{board[8]}  |  #{board[9]}"
  puts "     |     |"
  puts ""
end
# rubocop:enable Metrics/AbcSize

def prompt(msg)
  puts ">>> #{msg}"
end

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def clear_screen
  system('clear') || system('cls')
end

def player_choice
  prompt "Should the computer(C) or player(P) go first? Enter letter only."
  answer = ''
  loop do
    answer = gets.chomp
    break if answer.casecmp('c').zero? || answer.casecmp('p').zero?
    prompt "Invalid answer. Please enter 'C' or 'P' only."
  end
  if answer.casecmp('c').zero?
    'Computer'
  elsif answer.casecmp('p').zero?
    'Player'
  end
end

def turn_decider
  prompt "Player moves first by default. First to 5 points wins."
  prompt "Enter 'D' for default or 'C' to change order."
  answer = ''
  loop do
    answer = gets.chomp
    break if answer.casecmp('c').zero? || answer.casecmp('d').zero?
    prompt "Invalid answer. Please enter 'C' or 'D' only."
  end
  if answer.casecmp('c').zero?
    player_choice
  elsif answer.casecmp('d').zero?
    'Player'
  end
end

def empty_squares(board)
  board.keys.select { |num| board[num] == INITIAL_MARKER }
end

def joinor(board, punct=",", conjunction="or")
  if board.count > 1
    conjunct = " " + conjunction + " "
    last_item = board[-1].to_s.prepend(conjunct)
    board.delete_at(-1)
    board.join(punct) + last_item
  else
    board[0]
  end
end

def player_places_piece!(board)
  square = ''
  loop do
    prompt "Choose: #{joinor(empty_squares(board))}."
    square = gets.chomp.to_i
    break if empty_squares(board).include?(square)
    prompt "Sorry, please choose a valid entry from the list."
  end
  board[square] = PLAYER_MARKER
end

def find_at_risk_square(line, board, marker)
  if board.values_at(*line).count(marker) == 2
    board.select { |key, value| line.include?(key) && value == ' ' }.keys.first
  end
end

def computer_square_choice(board, marker)
  risky_square = nil
  WINNING_LINES.each do |line|
    risky_square = find_at_risk_square(line, board, marker)
    break if risky_square
  end
  risky_square
end

def computer_places_piece!(board)
  square = computer_square_choice(board, COMPUTER_MARKER)

  if !square
    square = computer_square_choice(board, PLAYER_MARKER)
  end

  if !square
    square = (board[5] == ' ' ? 5 : empty_squares(board).sample)
  end

  board[square] = COMPUTER_MARKER
end

def board_full?(board)
  empty_squares(board).empty?
end

def someone_won?(board)
  !!detect_winner(board)
end

def place_piece!(board, current_player)
  if current_player == 'Computer'
    computer_places_piece!(board)
  elsif current_player == 'Player'
    player_places_piece!(board)
  end
end

def alternate_player(current_player)
  if current_player == 'Computer'
    'Player'
  elsif current_player == 'Player'
    'Computer'
  end
end

def detect_winner(board)
  WINNING_LINES.each do |line|
    if board.values_at(*line).count(PLAYER_MARKER) == 3
      return 'Player'
    elsif board.values_at(*line).count(COMPUTER_MARKER) == 3
      return 'Computer'
    end
  end
  nil
end

def announce_winner(player_score, computer_score)
  if computer_score == 5
    prompt "Computer wins!"
  elsif player_score == 5
    prompt "Player wins!"
  end
end

def replay_choice
  answer = ''
  loop do
    prompt("Enter 'Y' to play again. 'N' to exit.")
    answer = gets.chomp
    break if answer.casecmp('y').zero? || answer.casecmp('n').zero?
    prompt("Sorry, invalid answer.")
  end
  answer.downcase
end

def player_and_computer_turns(board, current_player)
  loop do
    clear_screen
    display_board(board)
    place_piece!(board, current_player)
    current_player = alternate_player(current_player)
    break if someone_won?(board) || board_full?(board)
  end
end

loop do
  player_score = 0
  computer_score = 0
  first_move = turn_decider
  loop do
    board = initialize_board
    current_player = first_move

    player_and_computer_turns(board, current_player)

    clear_screen
    display_board(board)

    if detect_winner(board) == 'Computer'
      computer_score += 1
    elsif detect_winner(board) == 'Player'
      player_score += 1
    end

    prompt "Score - Player: #{player_score} Computer: #{computer_score}"

    announce_winner(player_score, computer_score)
    break if player_score == 5 || computer_score == 5
    sleep 2
  end
  try_again = replay_choice
  break if try_again == 'n'
  clear_screen
end

prompt 'Thanks for playing Tic Tac Toe! Goodbye!'
