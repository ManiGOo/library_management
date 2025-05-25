require 'json'

# Book class to represent individual books
class Book
  attr_accessor :id, :title, :author, :borrowed_by, :borrowed_at

  def initialize(id, title, author)
    @id = id
    @title = title
    @author = author
    @borrowed_by = nil
    @borrowed_at = nil
  end

  def borrowed?
    !borrowed_by.nil?
  end

  def to_json(*args)
    {
      id: @id,
      title: @title,
      author: @author,
      borrowed_by: @borrowed_by,
      borrowed_at: @borrowed_at
    }.to_json(*args)
  end

  def self.from_json(data)
    book = new(data['id'], data['title'], data['author'])
    book.borrowed_by = data['borrowed_by']
    book.borrowed_at = data['borrowed_at'] ? Time.parse(data['borrowed_at']) : nil
    book
  end
end