/*
Test Case: delete & select
Priority: 1
Reference case:
Author: Lily

Test Point:
C1 delete rows, C2 select rows,overlapped.
transactions are not blocked.

NUM_CLIENTS = 2
C1: DELETE FROM tb1; --equivalence
C2: SELECT FROM tb1;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C2: commit;
/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1( id INT, col VARCHAR(10));
C1: INSERT INTO tb1 VALUES(101,'Tom'),(102,'Mike'),(103,'Stephan'),(102,'Lucy'),(103,'Elena'),(103,NULL),(104,NULL),(105,NULL),(105,'Ben');
C1: CREATE INDEX idx_1 ON tb1(id,col);
C1: CREATE INDEX idx_2 ON tb1(col);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 WHERE id = 103 AND col IS NULL;
C1: DELETE FROM tb1 WHERE id = 104;
C1: DELETE FROM tb1 WHERE col= 'Ben';
MC: wait until C1 ready;
C2: SELECT * FROM tb1 ORDER BY 1,2;
C2: DELETE FROM tb1 WHERE id =105 AND col IS NOT NULL;
MC: wait until C2 blocked;
C1: commit work;
MC: wait until C2 ready;
C2: commit work;
C2: SELECT * FROM tb1 ORDER BY 1,2;
C2: commit;
C2: quit;
C1: quit;
