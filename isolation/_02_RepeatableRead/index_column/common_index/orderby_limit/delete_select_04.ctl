/*
Test Case: delete & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/index_column/common_index/orderby_limit/delete_select_01.ctl 
Author: Lily

Test Point:
there are simple order by keyword and  NULLS FIRST in select statement.

NUM_CLIENTS = 2
C1: DELETE FROM tb1 WHERE id <= 3;
C2: select * from tb1 order by id; 
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1( id INT, name VARCHAR(10) );
C1: INSERT INTO tb1 VALUES(1,NULL), (2,NULL), (3,'AB'), (4,NULL), (5,'AB'),(6,NULL), (7,'ABCD'), (8,NULL), (9,'ABCD'), (10,NULL);
C1: CREATE INDEX idx_id on tb1(id);
C1: commit work;

/* test case */
C1: DELETE FROM tb1 WHERE id <= 3;
MC: wait until C1 ready;

C2: SELECT * FROM tb1 ORDER BY name ,1 NULLS FIRST;
MC: wait until C2 ready;

C1: commit work;
MC: wait until C1 ready;

C2: SELECT * FROM tb1 ORDER BY name ,1 NULLS FIRST;
C2: commit work;
C2: SELECT * FROM tb1 ORDER BY name ,1 NULLS FIRST;
MC: wait until C2 ready;

/* test case */
C1: DELETE FROM tb1 WHERE id >= 5;
MC: wait until C1 ready;

C2: SELECT * FROM tb1 ORDER BY name ,1 NULLS LAST;
MC: wait until C2 ready;

C1: commit work;
MC: wait until C1 ready;

C2: SELECT * FROM tb1 ORDER BY name ,1 NULLS LAST;
C2: commit work;
C2: SELECT * FROM tb1 ORDER BY name ,1 NULLS LAST;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;
