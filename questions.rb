require_relative 'questions_db.rb'
require_relative 'questions_follows.rb'
require_relative 'likes.rb'

class Questions
  attr_accessor :title, :body, :id, :user_id

  def self.all
    data = QuestionsDBConnection.instance.execute('SELECT * FROM questions')
    data.map { |datum| Questions.new(datum) }
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
  end

  def self.most_followed(n)
    QuestionsFollows.most_followed_questions(n)
  end

  def self.find_by_author_id(author_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        user_id = ?
    SQL
    data
  end

  def questions_author
    data = QuestionsDBConnection.instance.execute(<<-SQL, @id)
      SELECT
        fname, lname
      FROM
        users
      WHERE
        id = ?
    SQL
    data
  end

  def replies
    Replies.find_by_question_id(@id)
  end

  def followers
    QuestionsFollows.followers_for_question_id(@id)
  end

  def likers
    Likes.likers_for_question_id(@id)
  end

  def likers
    Likes.num_likes_for_question_id(@id)
  end

  def self.most_liked(n)
    Likes.most_liked_questions(n)
  end


end

# arr = Questions.all
# p arr[0].followers
