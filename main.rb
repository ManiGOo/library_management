require_relative 'library'

# Command-line interface
def print_menu
  puts "\nLibrary Management System"
  puts "1. Add Book"
  puts "2. List Books"
  puts "3. Update Book"
  puts "4. Delete Book"
  puts "5. Add User"
  puts "6. List Users"
  puts "7. Update User"
  puts "8. Delete User"
  puts "9. Borrow Book"
  puts "10. Return Book"
  puts "11. Exit"
  print "Choose an option: "
end

def main
  library = Library.new

  loop do
    print_menu
    choice = gets.chomp.to_i

    case choice
    when 1
      print "Enter book title: "
      title = gets.chomp
      print "Enter book author: "
      author = gets.chomp
      library.add_book(title, author)
    when 2
      library.list_books
    when 3
      print "Enter book ID: "
      id = gets.chomp.to_i
      print "Enter new title: "
      title = gets.chomp
      print "Enter new author: "
      author = gets.chomp
      library.update_book(id, title, author)
    when 4
      print "Enter book ID: "
      id = gets.chomp.to_i
      library.delete_book(id)
    when 5
      print "Enter user name: "
      name = gets.chomp
      library.add_user(name)
    when 6
      library.list_users
    when 7
      print "Enter user ID: "
      id = gets.chomp.to_i
      print "Enter new name: "
      name = gets.chomp
      library.update_user(id, name)
    when 8
      print "Enter user ID: "
      id = gets.chomp.to_i
      library.delete_user(id)
    when 9
      print "Enter book ID: "
      book_id = gets.chomp.to_i
      print "Enter user ID: "
      user_id = gets.chomp.to_i
      library.borrow_book(book_id, user_id)
    when 10
      print "Enter book ID: "
      book_id = gets.chomp.to_i
      library.return_book(book_id)
    when 11
      puts "Exiting..."
      break
    else
      puts "Invalid option. Please try again."
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  main
end