# trello-sorter

I (used to) organize my todo items using a Trello board. But I often found
myself struggling to prioritize the lists of tasks once they got too big. This
little utility lets you select a board and list, and presents two tasks at
a time for you to choose between. Pick the more important one each time, and at
the end all your tasks will be sorted by priority. It will even issue API calls
to the Trello board to re-order them for you!

## to use

    $ bundle install
    $ bundle exec ruby trello_sort.rb

The first time you run it, it will prompt you to log in to Trello. It will save
your token at `~/.trello-sorter` in your home directory for future use.
