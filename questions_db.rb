
require 'sqlite3'
require 'singleton'
# require_relative 'users.rb'
# require_relative 'questions.rb'
#require_relative 'questions_follows.rb'
# require_relative 'replies.rb'
#require_relative 'likes.rb'


class QuestionsDBConnection < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end

end












# usr = User.new
# print Users.find_by_name('Jeff', 'Sessions')
