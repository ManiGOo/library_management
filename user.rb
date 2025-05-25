require 'json'

# User class to represent library users
class User
  attr_accessor :id, :name

  def initialize(id, name)
    @id = id
    @name = name
  end

  def to_json(*args)
    {
      id: @id,
      name: @name
    }.to_json(*args)
  end

  def self.from_json(data)
    new(data['id'], data['name'])
  end
end