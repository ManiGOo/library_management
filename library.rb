require 'json'
require_relative 'book'
require_relative 'user'

# Library class to manage books and users
class Library
  def initialize
    @books = []
    @users = []
    @data_file = 'library_data.json'
    load_data
  end

  # CRUD for Books
  def add_book(title, author)
    id = @books.empty? ? 1 : @books.map(&:id).max + 1
    book = Book.new(id, title, author)
    @books << book
    save_data
    puts "Book added: #{book.title} by #{book.author}"
  end

  def list_books
    if @books.empty?
      puts "No books in the library."
    else
      @books.each do |book|
        status = book.borrowed? ? "Borrowed by User #{book.borrowed_by}" : "Available"
        puts "ID: #{book.id}, Title: #{book.title}, Author: #{book.author}, Status: #{status}"
      end
    end
  end

  def update_book(id, title, author)
    book = @books.find { |b| b.id == id }
    if book
      book.title = title
      book.author = author
      save_data
      puts "Book updated: #{book.title} by #{book.author}"
    else
      puts "Book with ID #{id} not found."
    end
  end

  def delete_book(id)
    book = @books.find { |b| b.id == id }
    if book
      if book.borrowed?
        puts "Cannot delete: Book is currently borrowed."
      else
        @books.delete(book)
        save_data
        puts "Book deleted: #{book.title}"
      end
    else
      puts "Book with ID #{id} not found."
    end
  end

  # CRUD for Users
  def add_user(name)
    id = @users.empty? ? 1 : @users.map(&:id).max + 1
    user = User.new(id, name)
    @users << user
    save_data
    puts "User added: #{user.name}"
  end

  def list_users
    if @users.empty?
      puts "No users registered."
    else
      @users.each do |user|
        borrowed_books = @books.select { |b| b.borrowed_by == user.id }
        book_titles = borrowed_books.map(&:title).join(", ")
        puts "ID: #{user.id}, Name: #{user.name}, Borrowed Books: #{book_titles.empty? ? 'None' : book_titles}"
      end
    end
  end

  def update_user(id, name)
    user = @users.find { |u| u.id == id }
    if user
      user.name = name
      save_data
      puts "User updated: #{user.name}"
    else
      puts "User with ID #{id} not found."
    end
  end

  def delete_user(id)
    user = @users.find { |u| u.id == id }
    if user
      if @books.any? { |b| b.borrowed_by == user.id }
        puts "Cannot delete: User has borrowed books."
      else
        @users.delete(user)
        save_data
        puts "User deleted: #{user.name}"
      end
    else
      puts "User with ID #{id} not found."
    end
  end

  # Borrowing and Returning Books
  def borrow_book(book_id, user_id)
    book = @books.find { |b| b.id == book_id }
    user = @users.find { |u| u.id == user_id }
    if book && user
      if book.borrowed?
        puts "Book is already borrowed."
      else
        book.borrowed_by = user.id
        book.borrowed_at = Time.now
        save_data
        puts "#{user.name} borrowed #{book.title}"
      end
    else
      puts "Book or User not found."
    end
  end

  def return_book(book_id)
    book = @books.find { |b| b.id == book_id }
    if book
      if book.borrowed?
        user = @users.find { |u| u.id == book.borrowed_by }
        book.borrowed_by = nil
        book.borrowed_at = nil
        save_data
        puts "#{user.name} returned #{book.title}"
      else
        puts "Book is not borrowed."
      end
    else
      puts "Book with ID #{book_id} not found."
    end
  end

  # File I/O
  def save_data
    data = {
      books: @books.map { |book| JSON.parse(book.to_json) },
      users: @users.map { |user| JSON.parse(user.to_json) }
    }
    File.write(@data_file, JSON.pretty_generate(data))
  rescue StandardError => e
    puts "Error saving data: #{e.message}"
  end

  def load_data
    return unless File.exist?(@data_file)

    data = JSON.parse(File.read(@data_file))
    @books = data['books'].map { |b| Book.from_json(b) }
    @users = data['users'].map { |u| User.from_json(u) }
  rescue StandardError => e
    puts "Error loading data: #{e.message}"
  end
end