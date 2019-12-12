
/* t1, t2 read commited, auto-commit off */
MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;


/* init on t1 */
C1: DROP TABLE IF EXISTS t;
C1: create table t (a int);
C1: insert into t values (10);
C1: commit;
MC: wait until C1 ready;

/* test case */

/* t1 updates row on t */
C1: update t set a = 100;

/* t1 select increment (a) 
   since it already has lock on row, it will not commit increment immediately */

/* expected result 100 */ 
C1: select incr (a) from t; 
/* expected result 101 */
C1: select a from t; 
MC: wait until C1 ready;

/* expected result is 10; result 101 is not valid since t1 changes should not be visible */
C2: select a from t;
MC: wait until C2 ready;

C1: rollback;
MC: wait until C1 ready;

/* expected result is 10 */
C2: select a from t;
MC: wait until C2 ready;

C1: select a from t;
MC: wait until C1 ready;
C1: commit;
C2: commit;
C1: quit;
C2: quit;
