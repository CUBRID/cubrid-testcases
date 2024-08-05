/*
Test Case: related to CBRD-24407

Test point:
same scenario are executed in following three isolation levels:
  -- read committed
  -- repeatable read
  -- serializable

In this test, instead of using the set transaction syntax, we will use different commands to verify these isolation levels. The purpose is to ensure that changing isolation level and lock timeout via set system parameters is correctly applied and functioning.

We replaced the set transaction isolation level command with set system parameters 'isolation_level=value'. 
Note: The value must be numeric: serializable=6, repeatable read=5, read committed=4.

We also replaced the set transaction lock timeout command with set system parameters 'lock_timeout=value'. 
Note: The lock_timeout can be set in seconds and must include the unit (s). If the unit is not provided, it is considered milliseconds. Any value less than 1 second is rounded up to 1 second internally.
*/

/* preparation */
MC: setup NUM_CLIENTS = 2;
C1: set system parameters 'lock_timeout=-1';
C1: set system parameters 'isolation_level=4';
C2: set system parameters 'lock_timeout=-1';
C2: set system parameters 'isolation_level=4';
C2: commit;
C1: drop table if exists foo;
C1: create table foo (a int, b int, c int);
C1: commit;
MC: wait until C1 ready;

/* test case 1 -- read committed */
C1: select a, b, c from foo where a > 0 and c = 10;
MC: wait until C1 ready;
C2: insert into foo values (1,2,10);
C2: commit;
MC: wait until C2 ready;
C1: select a, b, c from foo where a > 0 and c = 10;
C1: commit;
C1: select a, b, c from foo where a > 0 and c = 10;
MC: wait until C1 ready;

C1: set system parameters 'isolation_level=5';
C2: set system parameters 'isolation_level=5';
C2: commit;
C1: drop table if exists foo;
C1: create table foo (a int, b int, c int);
C1: commit;
MC: wait until C1 ready;

/* test case 2 -- repeatable read */
C1: select a, b, c from foo where a > 0 and c = 10;
MC: wait until C1 ready;
C2: insert into foo values (1,2,10);
C2: commit;
MC: wait until C2 ready;
C1: select a, b, c from foo where a > 0 and c = 10;
C1: commit;
C1: select a, b, c from foo where a > 0 and c = 10;
MC: wait until C1 ready;

C1: set system parameters 'isolation_level=6';
C2: set system parameters 'isolation_level=6';
C2: commit;
C1: drop table if exists foo;
C1: create table foo (a int, b int, c int);
C1: commit;
MC: wait until C1 ready;

/* test case 3 -- serializable */
C1: select a, b, c from foo where a > 0 and c = 10;
MC: wait until C1 ready;
C2: insert into foo values (1,2,10);
C2: commit;
MC: wait until C2 ready;
C1: select a, b, c from foo where a > 0 and c = 10;
C1: commit;
C1: select a, b, c from foo where a > 0 and c = 10;
MC: wait until C1 ready;

C1: quit;
C2: quit;

