def prompt(message)
  Kernel.puts("===>> #{message}")
end

def valid_number?(num)
  num.to_f > 0.0
end

def valid_name?(name)
  name =~ /[[:alpha:]]/
end

puts <<-WELCOMEMSG

Welcome to the Mortgage Calculator!
---------------------------------------------------

WELCOMEMSG

user_name = ''
loop do
  prompt("Please enter your name.")
  user_name = gets.chomp # Name from here
  break if valid_name?(user_name)
  prompt("Oops! Don't forget to enter a valid name.")
end

prompt("Thank you #{user_name}. Let's get started.")

loop do
  prompt("What is the total amount for your loan?")
  loan_total = ''
  loop do
    loan_total = gets.chomp
    break if valid_number?(loan_total)
    prompt("Please enter a valid dollar amount.")
  end

  prompt("What is the APR in percents?")
  apr = ''
  loop do
    apr = gets.chomp
    break if valid_number?(apr)
    prompt("Please enter a valid APR value.")
  end

  prompt("And lastly, what is the loan period in months?")
  loan_length = ''
  loop do
    loan_length = gets.chomp
    break if valid_number?(loan_length)
    prompt("Please enter a valid loan period.")
  end

  # Calculations start here

  converted_apr = apr.to_f
  converted_loan_length = loan_length.to_i
  monthly_interest_rate = (converted_apr / 12) / 100

  monthly_payment = loan_total.to_f *
                    (monthly_interest_rate /
                    (1 - (1 + monthly_interest_rate)**-converted_loan_length))

  prompt(format("Your monthly payment is $%0.2f.", monthly_payment))

  prompt("Calculation complete. Please enter \'R\' to recalculate.")
  answer = gets.chomp.downcase
  break unless answer == 'r'
end

prompt("Thank you for using the calculator, #{user_name}.")
prompt("Have a great day! Goodbye!")
