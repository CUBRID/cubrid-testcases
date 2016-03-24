/*
Test Case: alter table & delete,insert,select,update
Priority: 1
Reference case:
Author: Lily

Test Point:
C1 alter table, other tansactions are blocked.

*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C2: commit;
/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT PRIMARY KEY,col VARCHAR(10), grade INT);
C1: INSERT INTO tb1 VALUES(3,'hijk',12);
C1: commit work;

/* test case */
C1: ALTER TABLE tb1 ADD COLUMN email VARCHAR(20);
C1: INSERT INTO tb1 VALUES(1,'abc',10,'com.123');
C1: select * from db_class where owner_name='PUBLIC';
MC: wait until C1 ready;
C2: INSERT INTO tb1 VALUES(5,'Test',4,'test@nnn.com');
MC: wait until C2 blocked;
MC: sleep 1;
C1: commit;
MC: wait until C2 ready;
C2: desc tb1;
C2: ALTER TABLE tb1 drop COLUMN email;
C2: SELECT * FROM tb1 ORDER BY id;
C2: INSERT INTO tb1 VALUES(14,'dev',76);
C2: drop table tb1;
MC: wait until C2 ready;
C1: select * from db_class where owner_name='PUBLIC';
MC: wait until C1 ready;
C2: commit;
MC: wait until C1 ready;
C1: select * from db_class where owner_name='PUBLIC';
C1: commit;
C1: select * from db_class where owner_name='PUBLIC';
C1: commit;
C2: quit;
C1: quit;

