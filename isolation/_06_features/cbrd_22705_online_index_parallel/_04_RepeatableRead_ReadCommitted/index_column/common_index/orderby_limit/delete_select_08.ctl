/*
Test Case: delete & select
Priority: 1
Reference case:
Author: Lily

Test Point:
there are simple order by keyword in select statement.

NUM_CLIENTS = 2
C1: SELECT * FROM tb1 WHERE sleep(1);  
C2: DELETE FROM tb1 WHERE id =501;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT, name VARCHAR(20), month1 INT, amount INT DEFAULT 100); 
C1: INSERT INTO tb1 VALUES(201, 'George' , 1, 450);INSERT INTO tb1 VALUES (201, 'George' , 2, 250);INSERT INTO tb1 VALUES (201, 'Laura'  , 1, 100);INSERT INTO tb1 VALUES (201, 'Laura'  , 2, 500);INSERT INTO tb1 VALUES(301, 'Max'  , 1, 300);INSERT INTO tb1 VALUES (301, 'Max'  , 2, 300); 
C1: INSERT INTO tb1 VALUES(501, 'Stephan', 1, 300);INSERT INTO tb1 VALUES (501, 'Stephan', 2, DEFAULT);INSERT INTO tb1 VALUES (501, 'Chang'  , 1, 150);INSERT INTO tb1 VALUES(501, 'Chang'  , 2, 150);INSERT INTO tb1 VALUES(501, 'Sue'    , 1, 150);INSERT INTO tb1 VALUES(501, 'Sue'    , 2, 200); 
C1: CREATE INDEX idx_id on tb1(id) with online parallel 3;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SELECT tb1.* FROM tb1 ORDER BY id DESC, name ASC,3,4;
MC: sleep 1;
C2: DELETE FROM tb1 WHERE id = 501; 
MC: wait until C2 ready;
C2: commit work;
MC: wait until C2 ready;
C1: SELECT * FROM tb1 ORDER BY id DESC, name ASC,3,4;
C1: SELECT * FROM tb1 ORDER BY id,2,3,4;
C1: commit;
MC: wait until C1 ready;

C2: quit;
C1: quit;
