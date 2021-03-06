-- DROP TABLE IF EXISTS progress_bars
-- CASCADE;
DROP TABLE IF EXISTS users
CASCADE;
DROP TABLE IF EXISTS messages
CASCADE;
DROP TABLE IF EXISTS posts
CASCADE;
DROP TABLE IF EXISTS likes
CASCADE;
DROP TABLE IF EXISTS comments
CASCADE;
DROP TABLE IF EXISTS user_profiles
CASCADE;
DROP TABLE IF EXISTS tutor_experiences
CASCADE;
DROP TABLE IF EXISTS mentor_stack
CASCADE;
DROP TABLE IF EXISTS student_stack
CASCADE;
DROP TABLE IF EXISTS stack_preferences
CASCADE;
DROP TABLE IF EXISTS posts_stacks
CASCADE;
DROP TABLE IF EXISTS avatars
CASCADE;
DROP TABLE IF EXISTS random_usernames
CASCADE;
DROP TABLE IF EXISTS coding_challenges
CASCADE;
DROP TABLE IF EXISTS user_challenges
CASCADE;
DROP TABLE IF EXISTS coding_tests
CASCADE;

-- ************************************************************
-- users table
-- ************************************************************
CREATE TABLE users
(
  id SERIAL PRIMARY KEY NOT NULL,
  username VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  password VARCHAR(255) NOT NULL,
  active BOOLEAN NOT NULL DEFAULT TRUE
);
-- ************************************************************
-- messages table
-- ************************************************************
CREATE TABLE messages
(
  id SERIAL PRIMARY KEY NOT NULL,
  sender_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  receiver_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  receiver_read BOOLEAN NOT NULL DEFAULT FALSE,
  text_body TEXT NOT NULL,
  time_sent TIMESTAMP NOT NULL,
  active BOOLEAN NOT NULL DEFAULT TRUE
);
-- ************************************************************
-- posts table
-- ************************************************************
CREATE TABLE posts
(
  id SERIAL PRIMARY KEY NOT NULL,
  owner_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  text_body TEXT NOT NULL,
  time_posted TIMESTAMP NOT NULL,
  is_mentor BOOLEAN NOT NULL DEFAULT FALSE,
  is_student BOOLEAN NOT NULL DEFAULT FALSE,
  status_field VARCHAR(255) NOT NULL,
  active BOOLEAN NOT NULL DEFAULT TRUE
);
-- ************************************************************
-- likes table
-- ************************************************************
CREATE TABLE likes
(
  id SERIAL PRIMARY KEY NOT NULL,
  post_id INTEGER REFERENCES posts(id) ON DELETE CASCADE,
  liker_id INTEGER REFERENCES users(id) ON DELETE CASCADE
);
-- ************************************************************
-- comments table
-- ************************************************************
CREATE TABLE comments
(
  id SERIAL PRIMARY KEY NOT NULL,
  post_id INTEGER REFERENCES posts(id) ON DELETE CASCADE,
  commenter_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  text_body TEXT NOT NULL
);
-- ************************************************************
-- user_profiles table
-- ************************************************************
CREATE TABLE user_profiles
(
  id SERIAL PRIMARY KEY NOT NULL,
  user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  dob DATE,
  location VARCHAR(255),
  is_mentor BOOLEAN DEFAULT FALSE,
  is_student BOOLEAN DEFAULT FALSE,
  avatar VARCHAR(255),
  active BOOLEAN DEFAULT TRUE
);
-- ************************************************************
-- tutor_experiences table
-- ************************************************************
CREATE TABLE tutor_experiences
(
  id SERIAL PRIMARY KEY NOT NULL,
  mentor_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  student_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  creator_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  mentor_rating INTEGER DEFAULT NULL,
  student_rating INTEGER DEFAULT NULL,
  mentor_comments TEXT DEFAULT NULL,
  student_comments TEXT DEFAULT NULL,
  status VARCHAR(255) NOT NULL,
  date_initiated TIMESTAMP,
  date_accepted TIMESTAMP,
  date_completed TIMESTAMP,
  receiver_seen BOOLEAN NOT NULL DEFAULT FALSE
);
-- ************************************************************
-- mentor_stack table
-- ************************************************************
CREATE TABLE mentor_stack
(
  id SERIAL PRIMARY KEY NOT NULL,
  user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL
);
-- ************************************************************
-- student_stack table
-- ************************************************************
CREATE TABLE student_stack
(
  id SERIAL PRIMARY KEY NOT NULL,
  user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL
);

-- ************************************************************
-- stack_preferences table
-- ************************************************************
CREATE TABLE stack_preferences
(
  id SERIAL PRIMARY KEY NOT NULL,
  name VARCHAR(255) NOT NULL
);

-- ************************************************************
-- stack_preferences table
-- ************************************************************
CREATE TABLE posts_stacks
(
  id SERIAL PRIMARY KEY NOT NULL,
  stack_preference_id INTEGER REFERENCES stack_preferences(id) ON DELETE CASCADE,
  post_id INTEGER REFERENCES posts(id) ON DELETE CASCADE
);


-- ************************************************************
-- avatars table
-- ************************************************************
CREATE TABLE avatars
(
  id SERIAL PRIMARY KEY NOT NULL,
  url VARCHAR(255) NOT NULL
);


-- ************************************************************
-- random_usernames table
-- ************************************************************
CREATE TABLE random_usernames
(
  id SERIAL PRIMARY KEY NOT NULL,
  name VARCHAR(255) NOT NULL
);


-- CREATE FUNCTION update_users
-- (_username users.username%TYPE,
-- _location user_profiles.location%TYPE,
-- _avatar user_profiles.avatar%TYPE,
-- _id user_profiles.user_id%TYPE)

-- returns void 
-- $$
-- BEGIN
--   /* add two update queries inside this function */
--   /* 1 Updating  table standards*/
--   update users
--   set users.username = '_username'
--   where id = '_id';

--   update user_profiles
--   set user_profilles.location = '_location',
--   set user_profiles
--   .avatar = '_avatar'
--   where user_id = _id;

-- END
-- $$
--   LANGUAGE 'plpgsql' VOLATILE SECURITY DEFINER; 


-- ************************************************************
-- coding_challenges table
-- ************************************************************
CREATE TABLE coding_challenges
(
  id SERIAL PRIMARY KEY NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  difficulty VARCHAR(255) NOT NULL
);

-- ************************************************************
-- user_challenges table
-- ************************************************************
CREATE TABLE user_challenges
(
  id SERIAL PRIMARY KEY NOT NULL,
  user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  coding_challenge_id INTEGER REFERENCES coding_challenges(id) ON DELETE CASCADE,
  completed BOOLEAN NOT NULL DEFAULT FALSE
);


-- ************************************************************
-- coding_tests table
-- ************************************************************
CREATE TABLE coding_tests
(
  id SERIAL PRIMARY KEY NOT NULL,
  coding_challenge_id INTEGER REFERENCES coding_challenges(id) ON DELETE CASCADE,
  description TEXT NOT NULL,
  input VARCHAR(255),
  output VARCHAR(255)
);
