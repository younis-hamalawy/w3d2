require_relative 'questions_db.rb'
#require_relative 'users'

class Likes
  attr_accessor :question_id, :user_id

  def self.all
    data = QuestionsDBConnection.instance.execute('SELECT * FROM question_likes')
    data.map { |datum| Likes.new(datum) }
  end

  def initialize(options)
    @question_id = options['question_id']
    @user_id = options['user_id']
  end

  def self.likers_for_question_id(q_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, q_id)
      SELECT
        fname, lname
      FROM
        users
      JOIN
        question_likes ON users.id=question_likes.user_id
      WHERE
        question_id = ?
    SQL
    data
  end

  def self.num_likes_for_question_id(q_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, q_id)
      SELECT
        COUNT(*)
      FROM
        users
      JOIN
        question_likes ON users.id=question_likes.user_id
      WHERE
        question_id = ?
      GROUP BY
        question_id
    SQL
    data
  end

  def self.num_liked_questions_for_user_id(u_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, u_id)
      SELECT
        COUNT(*)
      FROM
        questions
      JOIN
        question_likes ON questions.id=question_likes.question_id
      WHERE
        question_likes.user_id = ?
      GROUP BY
        question_likes.user_id
    SQL
    data
  end

  def self.most_liked_questions(n)
    data = QuestionsDBConnection.instance.execute(<<-SQL, n)
      SELECT
        questions.title
      FROM
        questions
      JOIN
        questions_likes ON questions_likes.questions_id = questions.id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(*) desc
      LIMIT
        ?
    SQL
  end

end

# p Likes.num_liked_questions_for_user_id(1)
# p Likes.num_liked_questions_for_user_id(3)
