require 'singleton'

class User
	attr_accessor :username, :password, :wins, :losses

	def initialize(username, password)
		@username = username
		@password = password
		@wins = 0
		@losses = 0
	end
end

class UserManager
	include Singleton

	def initialize()
		testUser = User.new("test", "test")
		@users = {}
		@users[testUser.username] = testUser
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