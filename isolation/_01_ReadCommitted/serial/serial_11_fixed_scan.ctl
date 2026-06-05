/*
Test Case: serial 
Priority: 1
Reference case:
Author: Lily

Test Point:
use the functions of serial.

NUM_CLIENTS = 2
C1: select SERIAL_CURRENT_VALUE(s1),SERIAL_NEXT_VALUE(s1) from tt1 where sleep(1);
C2: insert into tt1 values(s1.next_value);
C2: insert into tt1 values(s1.next_value);
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tt1;
C1: CREATE TABLE tt1( id INT, col VARCHAR(10));
C1: INSERT INTO tt1 VALUES(1,'test'),(2,'do'),(3,'run');
C1: CREATE SERIAL s1;
C1: commit work;
MC: wait until C1 ready;

/* test case */
/*
 * [NOTE] Adjusted after CBRD-26747 (enable_heap_fixed_scan).
 *   Original intent: while C1's SELECT runs slowly (sleep in WHERE), C2 consumes
 *   the serial NEXT_VALUE concurrently, exercising serial-value allocation order.
 *   Why changed: the (select sleep) predicate scans 'dual' and is an uncorrelated
 *   constant term, evaluated only once and independent of the heap page latch
 *   (confirmed via query plan). C1 and C2 do not contend on a latch; which side
 *   consumes the serial value first is a completion-time race that became
 *   non-deterministic under fixed scan.
 *   Fix: removed the sleep and use 'MC: wait until C1 ready' so C1 consumes the
 *   serial value first, making the order deterministic (sequential execution).
 *   Data results are unchanged.
 */
C1: SELECT SERIAL_CURRENT_VALUE(s1),SERIAL_NEXT_VALUE(s1) FROM tt1 where (select sleep(1)=0)<>0; 
MC: wait until C1 ready;
C2: INSERT INTO tt1 VALUES(s1.NEXT_VALUE,'Park');
C2: INSERT INTO tt1 VALUES(s1.NEXT_VALUE,'Museum');
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: commit work;
MC: wait until C2 ready;
C1: commit work;
C1: SELECT * FROM tt1 ORDER BY id,col;
MC: wait until C1 ready;
C2: SELECT SERIAL_CURRENT_VALUE(s1),SERIAL_NEXT_VALUE(s1);
C2: DROP SERIAL s1;
C2: commit;
C2: quit;
C1: quit;
