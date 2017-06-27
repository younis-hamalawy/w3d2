require_relative 'questions_db.rb'

class Replies
  attr_accessor :question_id, :user_id, :id, :parent_id, :body

  def self.all
    data = QuestionsDBConnection.instance.execute('SELECT * FROM replies')
    data.map { |datum| Replies.new(datum) }
  end

  def self.find_by_user_id(input_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, input_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL
    data
  end

  def self.find_by_question_id(input_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, input_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL
    data
  end

  def initialize(options)
    @question_id = options['question_id']
    @user_id = options['user_id']
    @id = options['id']
    @parent_id = options['parent_id']
    @body=options['body']
  end

  def author
    data = QuestionsDBConnection.instance.execute(<<-SQL, @user_id)
      SELECT
        fname, lname
      FROM
        users
      WHERE
        id = ?
    SQL
    data
  end

  def question
    data = QuestionsDBConnection.instance.execute(<<-SQL, @question_id)
      SELECT
        title
      FROM
        questions
      WHERE
        id = ?
    SQL
    data
  end

  def parent
    data = QuestionsDBConnection.instance.execute(<<-SQL, @parent_id)
      SELECT
        id, body
      FROM
        replies
      WHERE
        id = ?
    SQL
    data
  end

  def child
    data = QuestionsDBConnection.instance.execute(<<-SQL, @id)
      SELECT
        id, body
      FROM
        replies
      WHERE
        parent_id = ?
    SQL
    data
  end

end

# arr = Replies.all
# p arr[0].parent
