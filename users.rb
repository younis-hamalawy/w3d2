require_relative 'questions_db.rb'
require_relative 'questions.rb'
require_relative 'questions_follows'
require_relative 'likes.rb'

class Users

  attr_accessor :fname, :lname, :id

  def self.all
    data = QuestionsDBConnection.instance.execute('SELECT * FROM users')
    data.map { |datum| Users.new(datum) }
  end

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def self.find_by_name(firstname, lastname)
    data = QuestionsDBConnection.instance.execute(<<-SQL, firstname, lastname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?
    SQL
  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def followed_questions
    QuestionsFollows.followed_questions_for_user_id(@id)
  end

  def liked_questions
    Likes.num_liked_questions_for_user_id(@id)
  end

  def average_likes
    data = QuestionsDBConnection.instance.execute(<<-SQL, @id)
      SELECT
      *
        -- COUNT(questions.user_id)
      FROM
        questions
      LEFT OUTER JOIN
        question_likes ON questions.id = question_likes.question_id
      GROUP BY
        questions.id
      HAVING
        questions.user_id = ?
    SQL
    # total = data.map do |hsh|
    #   hsh.values[0].to_f
    # end
    # sum = total.inject(:+)
    # sum / total.length
  end

end

arr = Users.all
p arr[2].average_likes
#p arr[1].average_likes
