-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema oppimispeli
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema oppimispeli
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `oppimispeli` DEFAULT CHARACTER SET utf8 ;
USE `oppimispeli` ;

-- -----------------------------------------------------
-- Table `oppimispeli`.`course`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `oppimispeli`.`course` (
  `course_id` CHAR(10) NOT NULL,
  `course_name` VARCHAR(100) NOT NULL,
  `active` TINYINT(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`course_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `oppimispeli`.`subject`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `oppimispeli`.`subject` (
  `subject_id` INT(11) NOT NULL AUTO_INCREMENT,
  `lang` CHAR(3) NOT NULL DEFAULT 'fin',
  `theme` VARCHAR(30) NOT NULL,
  `course_id` CHAR(10) NOT NULL,
  PRIMARY KEY (`subject_id`),
  INDEX `AlterCourse` (`course_id` ASC),
  CONSTRAINT `AlterCourse`
    FOREIGN KEY (`course_id`)
    REFERENCES `oppimispeli`.`course` (`course_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `oppimispeli`.`question`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `oppimispeli`.`question` (
  `question_id` INT(11) NOT NULL AUTO_INCREMENT,
  `subject_id` INT(11) NOT NULL,
  PRIMARY KEY (`question_id`),
  INDEX `AlterSubject` (`subject_id` ASC),
  CONSTRAINT `AlterSubject`
    FOREIGN KEY (`subject_id`)
    REFERENCES `oppimispeli`.`subject` (`subject_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `oppimispeli`.`feedback`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `oppimispeli`.`feedback` (
  `question_id` INT(11) NOT NULL,
  `feedback_text` VARCHAR(1000) NULL DEFAULT NULL,
  `feedback_img` VARBINARY(8000) NULL DEFAULT NULL,
  PRIMARY KEY (`question_id`),
  CONSTRAINT `AlterFeedback`
    FOREIGN KEY (`question_id`)
    REFERENCES `oppimispeli`.`question` (`question_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `oppimispeli`.`hint`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `oppimispeli`.`hint` (
  `question_id` INT(11) NOT NULL,
  `hint_text` VARCHAR(1000) NULL DEFAULT 'Ei vihjettä',
  `hint_img` VARBINARY(8000) NULL DEFAULT NULL,
  PRIMARY KEY (`question_id`),
  CONSTRAINT `AlterHint`
    FOREIGN KEY (`question_id`)
    REFERENCES `oppimispeli`.`question` (`question_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `oppimispeli`.`multiplequestion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `oppimispeli`.`multiplequestion` (
  `question_id` INT(11) NOT NULL,
  `question_text` VARCHAR(1000) NOT NULL,
  `question_img` VARBINARY(8000) NULL DEFAULT NULL,
  PRIMARY KEY (`question_id`),
  CONSTRAINT `AlterQuestion`
    FOREIGN KEY (`question_id`)
    REFERENCES `oppimispeli`.`question` (`question_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `oppimispeli`.`multipleanswer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `oppimispeli`.`multipleanswer` (
  `question_id` INT(11) NOT NULL,
  `answer_text1` VARCHAR(300) NULL DEFAULT NULL,
  `answer_text2` VARCHAR(300) NULL DEFAULT NULL,
  `answer_text3` VARCHAR(300) NULL DEFAULT NULL,
  `answer_text4` VARCHAR(300) NULL DEFAULT NULL,
  `answer_img1` BLOB NULL DEFAULT NULL,
  `answer_img2` BLOB NULL DEFAULT NULL,
  `answer_img3` BLOB NULL DEFAULT NULL,
  `answer_img4` BLOB NULL DEFAULT NULL,
  `correct` TINYINT(3) UNSIGNED NOT NULL,
  PRIMARY KEY (`question_id`),
  CONSTRAINT `AlterAnswer`
    FOREIGN KEY (`question_id`)
    REFERENCES `oppimispeli`.`multiplequestion` (`question_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `oppimispeli`.`statement`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `oppimispeli`.`statement` (
  `question_id` INT(11) NOT NULL,
  `question_text` VARCHAR(1000) NOT NULL,
  `question_img` VARBINARY(8000) NULL DEFAULT NULL,
  `correct` TINYINT(1) NULL DEFAULT NULL,
  PRIMARY KEY (`question_id`),
  CONSTRAINT `AlterStatement`
    FOREIGN KEY (`question_id`)
    REFERENCES `oppimispeli`.`question` (`question_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

USE `oppimispeli` ;

-- -----------------------------------------------------
-- procedure Add_Multiple_Choise
-- -----------------------------------------------------

DELIMITER $$
USE `oppimispeli`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Add_Multiple_Choise`(IN subjectIN INT, 
										IN q VARCHAR(1000), 
                                        IN a1 VARCHAR(300), 
                                        IN a2 VARCHAR(300), 
                                        IN a3 VARCHAR(300), 
                                        IN a4 VARCHAR(300),
                                        IN c TINYINT(1))
BEGIN
	/*Local variables*/
    DECLARE last_question_id INT;
    
    INSERT INTO question(subject_id) VALUES (subjectIN);
    SET last_question_id = LAST_INSERT_ID();
	
    INSERT INTO MultipleQuestion(question_id, question_text) VALUES (last_question_id, q);
	INSERT INTO MultipleAnswer(question_id, answer_text1, answer_text2, answer_text3, answer_text4, correct) VALUES (
		last_question_id, a1, a2, a3, a4);
    
END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
