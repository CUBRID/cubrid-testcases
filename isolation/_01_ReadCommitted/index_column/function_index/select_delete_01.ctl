/*
Test Case: delete & select
Priority: 1
Reference case: 
Author: Lily

Test Point:
use  CHAR_LENGTH(string) to create index.

NUM_CLIENTS = 2 
C1: select * from tb1 ; 
C2: delete * from tb1;

[CUBRIDQA-1391] Since CBRD-26747, fixed scan is enabled by default, causing latch to be held.
during query execution and distorting intended concurrent behavior in this TC.
Disable enable_heap_fixed_scan temporarily. See CUBRIDQA-1391 for details.
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C1: set system parameters 'enable_heap_fixed_scan=false';
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C2: set system parameters 'enable_heap_fixed_scan=false';

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id BIGINT NOT NULL,col VARCHAR(20));
C1: INSERT INTO tb1 VALUES(1,'a'),(2,'an'),(4,'java'),(4,'sales'),(3,'net'),(3,'web');
C1: CREATE INDEX idx ON tb1(CHAR_LENGTH(col));
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SELECT tb1.* FROM tb1 USE INDEX (idx) WHERE CHAR_LENGTH(col)=id and (select sleep(2)=0)<>0 order by 1,2;
C2: DELETE FROM tb1 USE INDEX (idx) WHERE CHAR_LENGTH(col)=id;
MC: wait until C2 ready;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C1: commit work;
MC: wait until C1 ready;

C1: SELECT * FROM tb1 GROUP BY id order by 1,2;
C1: commit;

C2: set system parameters 'enable_heap_fixed_scan=true';
C1: set system parameters 'enable_heap_fixed_scan=true';
C2: quit;
C1: quit;

