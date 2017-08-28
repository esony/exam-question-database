CREATE PROCEDURE `Add_Multiple_Choise` (IN subjectIN INT, 
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
    
END;