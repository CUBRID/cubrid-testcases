/*
Test Case: delete & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/index_column/common_index/subquery/delete_select_01.ctl
Author: Lily

Test Point:
there is a multiple-row subquery in select statement.

NUM_CLIENTS = 2
C1: select * from tb1 order by id;
C2: DELETE FROM tb1;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id varchar(10),name varchar(10),age int);
C1: INSERT INTO tb1 VALUES(1,'Tom',56);INSERT INTO tb1 VALUES(2,'Jonh',25);INSERT INTO tb1 VALUES(3,'Susan',56);
C1: INSERT INTO tb1 VALUES(4,'Carol',21);INSERT INTO tb1 VALUES(5,'Jack',39);INSERT INTO tb1 VALUES(6,'Jim',56);
C1: CREATE INDEX idx_id on tb1(id);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SELECT b.* FROM ( SELECT * FROM tb1 WHERE age=(SELECT MAX(age) FROM tb1) ORDER BY id) b ;
MC: sleep 1;
C2: DELETE FROM tb1 WHERE id>=4;
C2: commit work;
MC: wait until C2 ready;
C1: SELECT b.* FROM ( SELECT * FROM tb1 WHERE age=(SELECT MAX(age) FROM tb1) ORDER BY id) b ;
MC: wait until C1 ready;
C2: SELECT * FROM tb1 ORDER BY id;
C2: commit work;

C1: commit;
C2: quit;
C1: quit;
