/*
Test Case: related to CUBRIDSUS-15466
Priority: 1
Reference case:
Author: Lily

Test Point:
use S-lock on db_serial instances at select.
*/

/* preparation */
MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C2: commit;

/* test case */
C1: CREATE SERIAL s1;
MC: wait until C1 ready;
C2: select name,current_val,increment_val from db_serial; 
MC: wait until C2 blocked;
C1: commit;
/* after C2 is unblocked in order to improve the readability 
wait until C1 ready;  -- replace to MC: wait until C2 ready; */
MC: wait until C2 ready;      
C2: select name,current_val,increment_val from db_serial; 
C2: commit;
MC: wait until C2 ready;

C1: drop SERIAL s1;
MC: wait until C1 ready;
C2: select name,current_val,increment_val from db_serial; 
MC: wait until C2 blocked;
C1: commit;

MC: wait until C2 ready;
C2: select name,current_val,increment_val from db_serial; 
C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;
