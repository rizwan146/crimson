# frozen_string_literal: true

require 'singleton'

class User
  attr_accessor :name, :password, :wins, :losses

  def initialize(username, password)
    @name = username
    @password = password
    @wins = 0
    @losses = 0
  end
end

class UserManager
  include Singleton

  attr_reader :users

  def initialize
    testUser = User.new('test', 'test')
    @users = {}
    @users[testUser.name] = testUser

    File.open("#{__dir__}/usernames.txt", "r") do |file|
      usernames = file.read.split("\n")
      usernames.each { |user| @users[user] = User.new(user, user) }
    end
  end

  def each_user
    @users.each_value { |user| yield user }
  end

  def authenticate(username, password)
    registered?(username) && @users[username].password == password
  end

  def registered?(username)
    @users.key?(username)
  end

  def register(username, password)
    return false if registered?(username)

    user = User.new(username, password)
    @users[username] = user
    true
  end

  def [](username)
    @users[username]
  end
end