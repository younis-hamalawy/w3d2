
DROP TABLE IF EXISTS users;

CREATE TABLE users (

  id INTEGER PRIMARY KEY,
  fname VARCHAR,
  lname VARCHAR

);


DROP TABLE IF EXISTS questions;

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR,
  body VARCHAR,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS questions_follows;

CREATE TABLE questions_follows (
  questions_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (questions_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)

);

DROP TABLE IF EXISTS replies;

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,
  user_id INTEGER NOT NULL,
  body VARCHAR,
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_id) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_likes;

CREATE TABLE question_likes (
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  users (fname,lname)
VALUES
  ('Jeff', 'Sessions'),
  ('Mike', 'Flynn'),
  ('Vlad', 'The Putin');

INSERT INTO
  questions (title, body, user_id)
VALUES
  ('Russian question', 'Did you or did you not have contact with the Russian government', 2),
  ('Flying monkey?', 'Do flying monkeys exist?', 2),
  ('The God Delima', 'Are you real?', 3),
  ('Unhappy question', 'Why does no one like my questions?', 3);

INSERT INTO
  questions_follows(questions_id, user_id)
VALUES
  (1, 2),
  (3, 3),
  (2, 3),
  (1, 3);

INSERT INTO
  replies(question_id, parent_id, user_id, body)
VALUES
  (2, NULL, 3, "I am a flying monkey!"),
  (2, 1, 1, "Yes Master"),
  (3, NULL, 1, "NO!"),
  (3, NULL, 2, "I can neither confirm or deny, at this time!");

INSERT INTO
  question_likes(question_id, user_id)
VALUES
  (1, 2),
  (3, 3),
  (2, 3),
  (1, 3);
