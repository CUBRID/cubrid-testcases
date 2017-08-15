/*
Test Case: trigger - commit
Priority: 1
Reference case:
Author: Lily

Test Point:
Event Type:COMMIT,   Event time:after, Action: print

NUM_CLIENTS = 2
C1: insert, then commit; 
C2: insert the table;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tt1;
C1: CREATE TABLE tt1( id INT, col VARCHAR(10));
C1: CREATE TRIGGER trg1 AFTER COMMIT EXECUTE PRINT 'Success to commit the transaction';
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: INSERT INTO tt1 VALUES(1,'test');
C1: commit work;
MC: wait until C1 ready;
C2: INSERT INTO tt1 VALUES(2,'test');
C2: commit;
C2: drop trigger trg1;
C2: commit;
MC: wait until C2 ready;
C1: select * from tt1 order by 1,2;
C1: drop trigger trg1;
C1: commit;
C1: INSERT INTO tt1 VALUES(3,'test');
C1: commit;

C2: quit;
C1: quit;
