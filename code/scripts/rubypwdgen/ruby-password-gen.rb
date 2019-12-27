#!/usr/bin/env ruby
# coding: utf-8
# ruby-password-gen.rb
# Author: Aren Tyr (aren.unix@yandex.com)
#
# Date: 2019-12-27
# Version 1.0
#
# ==============================================================================
# This script implements a simple password generation facility to stdout.
# It provides options for specifying the length of the desire password, and
# whether you want to include either/both numbers and symbols in the resultant
# generated password as well.
#
# You can either specify these options as command line arguments or else call the
# script without any and it will query you for your desired choices.
#
# This was the first time I've used Ruby so was a nice learning exercise to see how
# its functionality and syntax compares to other languages like Python.
#
# Courtesy of the SecureRandom library, the passwords it generates are pretty strong.
#
# To try to increase the randomness/entrophy even further, I generate the final password
# by three passes via an initial reduction from a 10000 character generated 'input'
# password. This way there should be no particular pattern even to the occurrence order
# of the alphanumeric characters, number symbols, and special characters, let alone the
# generated randomness within each of these subsets.
# ==============================================================================


require 'securerandom'

input_arguments = ARGV

length = ""
bool_numbers = ""
bool_symbols = ""

def displayUsage
  puts " "
  puts "------ USAGE -------"
  puts "Either specify 0 arguments (interactive input), 1 argument (password length)"
  puts "or 3 arguments (length & generation options): "
  puts " "
  puts "<password length> <numbers (y/n)> <symbols (y/n)>"
  puts " "
  puts "-> Length input or argument must be a number between 5-500"
  puts "-> Numbers input or argument must be either 'y' or 'n' (no quotes!)"
  puts "-> Symbols input or argument must be either 'y' or 'n' (no quotes!)"
  puts " "
  puts "Examples:"
  puts " "
  puts "$ ruby-password-gen 125"
  puts "This instructs to generate a password of length 125, including numbers and symbols."
  puts "$ ruby-password-gen 40 n n"
  puts "This instructs to generate a password of length 40, only using upper/lower case characters."
  puts "$ ruby-password-gen 80 y n"
  puts "This instructs to generate a password of length 80, including numbers, but not including"
  puts "special symbols."
  puts "$ ruby-password-gen 55 y y"
  puts "This instructs to generate a password of length 55, including both numbers and symbols."
  puts "'ruby-password-gen 55' would have the same effect."
  puts "--------------------"
end

def checkLengthInput(length)
  if length.to_i == 0 || length.to_i < 5 || length.to_i > 500
    puts "'#{length}' -> Invalid input."
    puts "Please specify a integer to indicate length of password between 5 and 500"
    displayUsage
    exit(0)
  end
end

def checkNumbersInput(bool_numbers)
  if bool_numbers.downcase != "y" && bool_numbers.downcase != "n"
    puts "Invalid option. Please specify 'y' or 'n' for whether you want numbers in the generated password"
    displayUsage
    exit(0)
  end
end

def checkSymbolsInput(bool_symbols)
  if bool_symbols.downcase != "y" && bool_symbols.downcase != "n"
    puts "Invalid option. Please specify 'y' or 'n' for whether you want numbers in the generated password"
    displayUsage
    exit(0)
  end
end


def generatePassword(length, bool_numbers, bool_symbols)
  i = 0
  password = ""

  # ==== Phase/Pass 1 ===========
  # Generate a 10000 character phase 1 passwords
  # We use suitable indexes into the standard ASCII table to
  # select our character/symbol options
  while i < 10000 do
    pwtxt = SecureRandom.random_number(26) + 65
    password = password + pwtxt.chr
    pwtxt = SecureRandom.random_number(26) + 97
    password = password + pwtxt.chr
    if bool_symbols.downcase == "y"
      pwtxt = SecureRandom.random_number(14) + 33
      password = password + pwtxt.chr
      pwtxt = SecureRandom.random_number(6) + 58
      password = password + pwtxt.chr
    end
    if bool_numbers.downcase == "y"
      pwtxt = SecureRandom.random_number(10) + 48
      password = password + pwtxt.chr
    end
    i = i + 1
  end

  # ==== Phase/Pass 2 ===========
  # 10000 character phase 1 password generated
  # Now let us randomly pick a selection of 5000 indexed
  # characters from this 10000 character input to generate
  # the phase 2 password

  i = 0
  phase2_pwd = ""

  while i < 5000
    phase2_pwd = phase2_pwd + password[SecureRandom.random_number(10000)]
    i = i + 1
  end

  i = 0

  # Reset our initial phase 1 password
  password = ""

  # ==== Phase/Pass 3 ===========
  # Final phase 3 pass to narrow down to our final desired password length.
  # Select up to a maximum of 500 characters from this phase 2 bank of 5000
  # random characters (+ numbers/symbols, if specified)
  while i < length.to_i
    password = password + phase2_pwd[SecureRandom.random_number(5000)]
    i = i + 1
  end

  puts " "
  puts "------------------- "
  puts "Generated Password: "
  puts "------------------- "
  puts " "

  # The final password
  puts password
  puts " "
  puts "------------------- "
  exit(0)

end

# Interactive use
if input_arguments.length == 0

  print "Enter length of desired password [5-500]: "
  STDOUT.flush
  length = gets.chomp
  checkLengthInput(length)
  print "Use numbers? [y/n]: "
  STDOUT.flush
  bool_numbers = gets.chomp
  checkNumbersInput(bool_numbers)
  print "Use special symbols? [y/n]: "
  STDOUT.flush
  bool_symbols = gets.chomp
  checkSymbolsInput(bool_symbols)

  generatePassword(length, bool_numbers, bool_symbols)

# Length only specified (= default to using numbers + symbols as well)
elsif input_arguments.length == 1

  checkLengthInput(input_arguments[0])

  generatePassword(input_arguments[0], "y", "y")

# All three arguments specified; length, use numbers y/n, use symbols y/n
elsif input_arguments.length == 3
  checkLengthInput(input_arguments[0])
  checkNumbersInput(input_arguments[1])
  checkSymbolsInput(input_arguments[2])

  generatePassword(input_arguments[0], input_arguments[1], input_arguments[2])

# An unknown or incorrect number of arguments. 
else

  displayUsage

end



