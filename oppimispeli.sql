CREATE DATABASE oppimispeli;
USE oppimispeli;

CREATE TABLE Course (
course_id CHAR(10) NOT NULL PRIMARY KEY,
course_name VARCHAR(100) NOT NULL,
active TINYINT(1) NOT NULL DEFAULT 1 CHECK (active = 0 OR active = 1)
);
DROP TABLE Course;

CREATE TABLE Subject (
subject_id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
lang CHAR(3) NOT NULL DEFAULT 'fin',
theme VARCHAR(30) NOT NULL,
course_id CHAR(10) NOT NULL REFERENCES Course(Course_id)
);

ALTER TABLE Subject DROP course_id;
ALTER TABLE Subject ADD course_id CHAR(10) NOT NULL REFERENCES Course(course_id);
ALTER TABLE Subject ADD FOREIGN KEY (course_id) REFERENCES Course(course_id);

UPDATE Subject SET course_id = "IHA-1100";

DROP TABLE Subject;

CREATE TABLE Question (
question_id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
subject_id INTEGER NOT NULL REFERENCES subject(subject_id)
);

CREATE TABLE MultipleQuestion (
question_id INTEGER NOT NULL PRIMARY KEY REFERENCES Question(question_id),
question_text VARCHAR(1000) NOT NULL, 
question_img BLOB
);

CREATE TABLE MultipleAnswer (
question_id INTEGER NOT NULL PRIMARY KEY REFERENCES MultipleQuestion(question_id),
answer_text1 VARCHAR(300),
answer_text2 VARCHAR(300),
answer_text3 VARCHAR(300),
answer_text4 VARCHAR(300),
answer_img1 BLOB,
answer_img2 BLOB,
answer_img3 BLOB,
answer_img4 BLOB,
correct TINYINT UNSIGNED NOT NULL CHECK (correct >= 1 AND correct <= 4)
);

CREATE TABLE Statement (
question_id INTEGER NOT NULL PRIMARY KEY REFERENCES Question(question_id),
question_text VARCHAR(1000) NOT NULL, 
question_img BLOB,
correct TINYINT(1) CHECK (correct = 0 OR correct = 1)
);

CREATE TABLE Hint (
question_id INTEGER NOT NULL PRIMARY KEY REFERENCES Question(question_id),
hint_text VARCHAR(1000) DEFAULT 'Ei vihjettä',
hint_img BLOB 
);

CREATE TABLE Feedback (
question_id INTEGER NOT NULL PRIMARY KEY REFERENCES Question(question_id),
feedback_text VARCHAR(1000),
feedback_img BLOB
);

/*Constraints*/

ALTER TABLE Subject 
	ADD CONSTRAINT AlterCourse
    FOREIGN KEY (course_id)
    REFERENCES Course(course_id)
    ON UPDATE CASCADE ON DELETE CASCADE;
    
ALTER TABLE Question 
	ADD CONSTRAINT AlterSubject
    FOREIGN KEY (subject_id)
    REFERENCES Subject(subject_id)
    ON UPDATE CASCADE ON DELETE CASCADE;
    
ALTER TABLE Question DROP FOREIGN KEY AlterSubject;
    
ALTER TABLE Statement
	ADD CONSTRAINT AlterStatement
    FOREIGN KEY (question_id)
    REFERENCES Question(question_id)
    ON UPDATE CASCADE ON DELETE CASCADE;
    
ALTER TABLE MultipleQuestion 
	ADD CONSTRAINT AlterQuestion
    FOREIGN KEY (question_id)
    REFERENCES Question(question_id)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE MultipleAnswer 
	ADD CONSTRAINT AlterAnswer
    FOREIGN KEY (question_id)
    REFERENCES MultipleQuestion(question_id)
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE Hint
	ADD CONSTRAINT AlterHint
    FOREIGN KEY (question_id)
    REFERENCES Question(question_id)
    ON UPDATE CASCADE ON DELETE CASCADE;
    
ALTER TABLE Feedback
	ADD CONSTRAINT AlterFeedback
    FOREIGN KEY (question_id)
    REFERENCES Question(question_id)
    ON UPDATE CASCADE ON DELETE CASCADE;

/*Selects*/
SELECT * FROM Course;
SELECT * FROM Subject;
SELECT * FROM Question;
SELECT * FROM MultipleQuestion;
SELECT * FROM MultipleAnswer;

/*Kaikki kysymykset*/
SELECT Question.question_id, course_id, theme, MultipleQuestion.question_text 
	FROM Question 
	JOIN Subject ON Question.subject_id = Subject.subject_id 
    JOIN MultipleQuestion ON Question.Question_id = MultipleQuestion.Question_id;

/*IHA-1100 Monitalintakysymykset ja vastaukset*/
/*JOIN*/
SELECT Question.question_id, MultipleQuestion.question_text, answer_text1, answer_text2, answer_text3, answer_text4 
	FROM Question 
	JOIN Subject ON Question.subject_id = Subject.subject_id 
    JOIN MultipleQuestion ON Question.Question_id = MultipleQuestion.Question_id
    JOIN MultipleAnswer ON MultipleQuestion.question_id = MultipleAnswer.question_id
    WHERE course_id = 'IHA-1100';

/*WHERE*/
SELECT Question.question_id, MultipleQuestion.question_text, answer_text1, answer_text2, answer_text3, answer_text4 
	FROM Question, Subject, MultipleQuestion, MultipleAnswer
    WHERE Question.subject_id = Subject.subject_id
    AND Question.Question_id = MultipleQuestion.Question_id
    AND MultipleQuestion.question_id = MultipleAnswer.question_id
    AND course_id = 'IHA-1100';


/*Courses*/
INSERT INTO Course(course_id, course_name) VALUES ("IHA-1100", "Hydrauliikan perusteet");

/*Subjects*/
INSERT INTO Subject(course_id, theme, subject_id) VALUES ("IHA-1100", "Hydrauliikan perusteet", 1);
INSERT INTO Subject(course_id, theme, subject_id) VALUES ("IHA-1100", "Toimilaitteet", 2);
INSERT INTO Subject(course_id, theme, subject_id) VALUES ("IHA-1100", "Venttiilit", 3);

/*Questions*/
INSERT INTO question(subject_id, question_id) VALUES (1, 4);

/* Perusteet*/
INSERT INTO MultipleQuestion(question_id, question_text) VALUES (1, "Pneumatiikassa väliaineena käytetään yleensä");
INSERT INTO MultipleAnswer(question_id, answer_text1, answer_text2, answer_text3, correct) VALUES (
	1, "Vettä", "Öljyä", "Ilmaa", 3);

INSERT INTO MultipleQuestion(question_id, question_text) VALUES (2, "Avoimessa hydraulijärjestelmässä väliaine palaa toimilaitteiden jälkeen");
INSERT INTO MultipleAnswer(question_id, answer_text1, answer_text2, answer_text3, answer_text4, correct) VALUES (
	2, "Pumpulle",	"Moottorille",	"Vapaaöljysäiliöön", "Tehtaalle", 3);

INSERT INTO MultipleQuestion(question_id, question_text) VALUES (4, "Hydraulijärjestelmän kokonaishyötysuhde on");
INSERT INTO MultipleAnswer(question_id, answer_text1, answer_text2, answer_text3, correct) VALUES (
	4, "Aina alle 75%", "Parhaimmillaan noin 85%", "Keskimäärin yli 85%", 2);

/*Toimilaitteet*/
INSERT INTO MultipleQuestion(question_id, question_text) VALUES (5, "Mikä tai mitkä väittämistä eivät ole totta?");
INSERT INTO MultipleAnswer(question_id, answer_text1, answer_text2, answer_text3, correct) VALUES (
	5, "Teleskooppisylinteri on tyypillinen rotaatioliikkeen toteuttava sylinteri", 
    "Rotaatioliikkeen toteuttavia vääntösylintereitä kutsutaan myös vääntömoottoreiksi", 
    "Differentiaalisylinteri on tyypillinen rotaatioliikkeen toteuttava sylinteri", 2);

INSERT INTO MultipleQuestion(question_id, question_text) VALUES (6, "Mikä tai mitkä väittämistä ovat totta?");
INSERT INTO MultipleAnswer(question_id, answer_text1, answer_text2, answer_text3, correct) VALUES (
	6, "Sylinterin nurjahdusvaara on sitä pienempi, mitä ohuempi ja pitempi männänvarsi on",
    "Sylinterin nurjahdusvaara on sitä suurempi, mitä ohuempi ja pitempi männänvarsi on",
    "Sylinterin kiinnitystapa ei vaikuta nurjahdusvaaraan", 2);

INSERT INTO MultipleQuestion(question_id, question_text) VALUES (7, "Mitä seuraavista materiaaleista ei käytetä sylinterintiivisteissä?");
INSERT INTO MultipleQuestion(question_id, question_text) VALUES (8, "Sylinteritiivisteen ominaisuuksissa ei tarvitse olennaisesti huomioida");
INSERT INTO MultipleQuestion(question_id, question_text) VALUES (9, "Hydraulimoottoreiden kiinnityksen täytyy olla erittäin tukeva");

/*Venttiilit*/
INSERT INTO MultipleQuestion(question_id, question_text) VALUES (10, "Hydrauliikassa käytetään venttiilejä");

