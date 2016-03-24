/*
Test Case: serial 
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/serial/serial_01.ctl
Author: Lily

Test Point:
decrease down to the minvalue then other transaction use the serial.
MaxValue:100,  MinValue:0,  CYCLE:true Cache:3

NUM_CLIENTS = 2
C1: insert into tt1 values(s1.next_value);
C2: insert into tt1 values(s1.next_value);
C2: commit;
C1: rollback;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tt1;
C1: CREATE TABLE tt1( id INT, col VARCHAR(10));
C1: CREATE SERIAL s1 START WITH 9 INCREMENT BY -2 MAXVALUE 100 MINVALUE 0 CYCLE CACHE 3;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: INSERT INTO tt1 VALUES(s1.NEXT_VALUE,'Park');
C1: SELECT SERIAL_NEXT_VALUE(s1,3);
C1: INSERT INTO tt1 VALUES(s1.NEXT_VALUE,'Museum');
MC: wait until C1 ready;
C2: INSERT INTO tt1 VALUES(s1.NEXT_VALUE,'Square');
C2: commit work;
C2: SELECT * FROM tt1 ORDER BY id;
MC: wait until C2 ready;
C1: rollback;
C1: SELECT * FROM tt1 ORDER BY id;
C1: DROP SERIAL s1;
C1: commit;
C2: quit;
C1: quit;
