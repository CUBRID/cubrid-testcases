/*
Test Case: delete & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/index_column/common_index/groupbydelete_select_01.ctl
Author: Lily

Test Point:
there are a simple GROUP BY and rollup keyword in select statement.

NUM_CLIENTS = 2
C1: DELETE FROM tb1 WHERE id =501 ;
C2: SELECT * FROM tb1 order by 1,2; 
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT, name VARCHAR(20), month_num INT, amount INT DEFAULT 100);
C1: INSERT INTO tb1 VALUES(201, 'George' , 1, 450), (201, 'George' , 2, 250), (201, 'Laura'  , 1, 100), (201, 'Laura'  , 2, 500),(301, 'Max'    , 1, 300), (301, 'Max'    , 2, 300);
C1: INSERT INTO tb1 VALUES(501, 'Stephan', 1, 300), (501, 'Stephan', 2, DEFAULT), (501, 'Chang'  , 1, 150),(501, 'Chang'  , 2, 150),(501, 'Sue'    , 1, 150), (501, 'Sue'    , 2, 200);
C1: CREATE INDEX idx_id on tb1(id);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 WHERE id = 201 AND 0=(select sleep(1) );
C1: SELECT id AS a1, name AS a2, avg(amount) AS a3 FROM tb1 WHERE amount > 100 GROUP BY a1, a2 WITH ROLLUP;
C1: commit work;
MC: wait until C1 ready;

C2: SELECT * FROM tb1 order by 1,2,3,4;
C2: commit work;
MC: wait until C2 ready;

C2: quit;
C1: quit;
