/*
Test Case: delete & select
Priority: 1
Reference case: 
Author: Lily

Test Point:
B reference A,  test the behavior

NUM_CLIENTS = 2
C1: select from referenced table where sleep(1); 
C2: delete from reference table where id=1;
C2: insert into reference table values(1,'new');
C2: commit;
C1: commit;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t_foreign;
C1: DROP TABLE IF EXISTS t_primary;
C1: CREATE TABLE t_primary(id INT PRIMARY KEY,col VARCHAR(10) ) REUSE_OID;
C1: CREATE TABLE t_foreign(id INT,col VARCHAR(10),FOREIGN KEY(id) REFERENCES t_primary(id) ON DELETE CASCADE ) REUSE_OID;
/*C1: CREATE TABLE t_foreign(id INT,col VARCHAR(10),FOREIGN KEY(id) REFERENCES t_primary(id) ON DELETE CASCADE ON CACHE OBJECT t_pri_obj);*/
C1: INSERT INTO t_primary VALUES(1,'a');
C1: INSERT INTO t_primary VALUES(2,'b');
C1: INSERT INTO t_foreign(id,col) VALUES(1,'test');
C1: INSERT INTO t_foreign(id,col) VALUES(1,'do');
C1: INSERT INTO t_foreign(id,col) VALUES(2,'make');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SELECT t_foreign.* FROM (select sleep(1)) x,t_foreign WHERE id>0 order by 1,2;
MC: wait until C1 ready;

C2: DELETE FROM t_primary WHERE id=1;
C2: INSERT INTO t_primary VALUES(3,'new');
C2: INSERT INTO t_foreign VALUES(3,'new_child');
MC: wait until C2 ready;

C2: commit;
MC: wait until C2 ready;

C1: commit;
C1: SELECT * FROM t_primary ORDER BY id,2;
C1: SELECT * FROM t_foreign ORDER BY id,2;
MC: wait until C1 ready;

C2: quit;
C1: quit;

