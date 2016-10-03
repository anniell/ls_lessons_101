VALID_CHOICES = { 'r' => 'rock',
                  'p' => 'paper',
                  'sc' => 'scissors',
                  'l' => 'lizard',
                  'sp' => 'spock' }

WINNING_COMBOS = {  'rock' => %w(scissors lizard),
                    'scissors' => %w(paper lizard),
                    'paper' => %w(spock rock),
                    'spock' => %w(scissors rock),
                    'lizard' => %w(paper spock) }

def prompt(message)
  puts("=>> #{message}")
end

def win?(first, second)
  WINNING_COMBOS[first].include?(second)
end

def display_winner(player, computer)
  if player == 5
    prompt("You won this round!")
  elsif computer == 5
    prompt("Computer won this round!")
  end
end

def player_choice_reader
  player = ''
  loop do
    prompt("Please choose one and enter the corresponding letter:")
    VALID_CHOICES.each { |letter, word| puts "#{letter.upcase} = #{word}" }
    player = gets.chomp.downcase
    VALID_CHOICES.key?(player) ? break : prompt("That's not a valid choice.")
  end
  VALID_CHOICES[player]
end

def replay?
  answer = ''
  loop do
    prompt("Enter 'Y' to play again. 'N' to exit.")
    answer = gets.chomp
    break if answer.casecmp('y').zero? || answer.casecmp('n').zero?
    prompt("Sorry, invalid answer.")
  end
  answer
end

puts <<-GREETING
Welcome to RPSSL!
----------------------------------

GREETING

prompt("First player with 5 points wins. Let's play!")

loop do
  computer_score = 0
  player_score = 0
  loop do
    player_choice = player_choice_reader
    computer_choice = VALID_CHOICES.values.sample

    prompt("You: #{player_choice} - Computer: #{computer_choice}")

    if win?(player_choice, computer_choice)
      player_score += 1
    elsif win?(computer_choice, player_choice)
      computer_score += 1
    else
      prompt("It's a tie!")
      next
    end

    prompt("-CURRENT SCORE- You: #{player_score} | Computer: #{computer_score}")

    break if player_score == 5 || computer_score == 5
  end

  display_winner(player_score, computer_score)

  player_retry = replay?

  break if player_retry != 'y'
end

prompt("Thank you for playing! Goodbye!")
