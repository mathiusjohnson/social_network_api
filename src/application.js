const fs = require("fs");
const path = require("path");

const express = require("express");
const bodyparser = require("body-parser");
const helmet = require("helmet");
const cors = require("cors");

const app = express();
const cookieParser = require("cookie-parser");
app.use(cookieParser());

const db = require("./db");

const comments = require("./routes/comments");
const likes = require("./routes/likes");
const mentorPoints = require("./routes/mentor_points");
const mentorStack = require("./routes/mentor_stack");
const messages = require("./routes/messages");
const posts = require("./routes/posts");
const postsStacks = require("./routes/posts_stacks");
const studentPoints = require("./routes/student_points");
const studentStack = require("./routes/student_stack");
const stackPreferences = require("./routes/stack_preferences");
const index = require("./routes/index");
const login = require("./routes/login-logout");
const tutorExperiences = require("./routes/tutor_experiences");
const userProfiles = require("./routes/user_profiles");
const users = require("./routes/users");
const register = require("./routes/register");
const userChallenges = require("./routes/user_challenges");

function read(file) {
  return new Promise((resolve, reject) => {
    fs.readFile(
      file,
      {
        encoding: "utf-8",
      },
      (error, data) => {
        if (error) return reject(error);
        resolve(data);
      }
    );
  });
}

module.exports = function application(
  ENV,
  actions = { updateComments: () => {}, deleteComments: () => {} }
) {
  app.use(cors());
  app.use(helmet());
  app.use(bodyparser.json());

  app.use("/api", comments(db, actions.updateComments, actions.deleteComments));
  app.use("/api", likes(db));
  app.use("/api", mentorPoints(db));
  app.use("/api", mentorStack(db));
  app.use("/api", messages(db));
  app.use("/api", posts(db));
  app.use("/api", postsStacks(db));
  app.use("/api", studentPoints(db));
  app.use("/api", studentStack(db));
  app.use("/api", stackPreferences(db));
  app.use("/api", index());
  app.use("/api", login(db));
  app.use("/api", tutorExperiences(db));
  app.use("/api", userProfiles(db));
  app.use("/api", users(db));
  app.use("/api", register(db));
  app.use("/api", userChallenges(db));

  if (ENV === "development" || ENV === "test") {
    Promise.all([
      read(path.resolve(__dirname, `db/schema/create.sql`)),
      read(path.resolve(__dirname, `db/schema/${ENV}.sql`)),
    ])
      .then(([create, seed]) => {
        app.get("/api/debug/reset", (request, response) => {
          db.query(create)
            .then(() => db.query(seed))
            .then(() => {
              console.log("Database Reset");
              response.status(200).send("Database Reset");
            });
        });
      })
      .catch((error) => {
        console.log(`Error setting up the reset route: ${error}`);
      });
  }

  app.close = function () {
    return db.end();
  };

  return app;
};
