require_relative 'questions_db'

class QuestionsFollows
  attr_accessor :questions_id, :user_id

  def self.all
    data = QuestionsDBConnection.instance.execute('SELECT * FROM questions_follows')
    data.map { |datum| QuestionsFollows.new(datum) }
  end

  def self.followers_for_question_id(q_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, q_id)
      SELECT
        fname, lname
      FROM
        users
      JOIN
        questions_follows ON questions_follows.user_id = users.id
      WHERE
        questions_follows.questions_id = ?
    SQL
  end

  def self.followed_questions_for_user_id(u_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, u_id)
      SELECT
        *
      FROM
        questions
      JOIN
        questions_follows ON questions_follows.questions_id = questions.id
      WHERE
        questions_follows.user_id = ?
    SQL
  end

  def initialize(options)
    @questions_id = options['questions_id']
    @user_id = options['user_id']
  end

  def self.most_followed_questions(n)
    data = QuestionsDBConnection.instance.execute(<<-SQL, n)
      SELECT
        questions.title
      FROM
        questions
      JOIN
        questions_follows ON questions_follows.questions_id = questions.id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(*) desc
      LIMIT
        ?
    SQL
  end
end

# print QuestionsFollows.most_followed_questions(1)
# print QuestionsFollows.most_followed_questions(2)
#print QuestionsFollows.followers_for_question_id(1)
# p QuestionsFollows.followed_questions_for_user_id(2)
