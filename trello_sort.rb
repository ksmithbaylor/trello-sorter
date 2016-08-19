require 'trello'
require 'highline'

APP_KEY = 'eff2fc1d803d4b2c6d7e0fd81cb273ee'
CONFIG_FILE = "#{ENV['HOME']}/.trello-sorter"

def prompt_for_token
  puts "Open the following URL in your browser to log in:"
  puts "\n\t#{Trello.authorize_url key: APP_KEY}\n"
  print "Paste your token here:\n> "
  token = gets.chomp
  File.open(CONFIG_FILE, 'w') do |f|
    f.print token
  end
end

def log_in token
  Trello.configure do |config|
    config.developer_public_key = APP_KEY
    config.member_token = token
  end
end

def init
  prompt_for_token if !File.file? CONFIG_FILE
  log_in File.read CONFIG_FILE
  $cli = HighLine.new
end

def choose prompt, collection
  system 'clear'
  $cli.choose do |menu|
    menu.prompt = "\n#{prompt}\n> "
    collection.reject(&:closed).each do |item|
      menu.choice(item.name.to_sym) { item }
    end
  end
end

def sort_cards cards
  cards.sort do |a, b|
    case choose 'Which card is more important?', [a, b]
      when a; -1
      when b;  1
      else     0
    end
  end
end

def apply_order cards
  system 'clear'
  puts "Sorted cards:\n\n"
  puts cards.map(&:name)
  puts

  if $cli.ask("Is this okay? (y/n)\n> ")[0].downcase == 'y'
    cards.each_with_index do |card, i|
      card.pos = 'bottom'
      card.save
    end
  else
    puts "Okay :("
  end
end

init
board = choose 'Which board would you like to look at?', Trello::Board.all.reject(&:closed)
list = choose 'Which list would you like to sort?', board.lists
sorted_cards = sort_cards list.cards
apply_order sorted_cards
