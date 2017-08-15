/*
Test Case: delete & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/aggregate/delete_select_01.ctl
Author: Lily

Test Point:
simple sum, get different result after delete transaction is committed or rollback.

NUM_CLIENTS = 1
C1: SELECT SUM(id) FROM tb1;
C1: DELETE FROM tb1 WHERE id%5=0; --rollback
C1: SELECT SUM(id) FROM tb1; 
*/

MC: setup NUM_CLIENTS = 1;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id BIGINT PRIMARY KEY,col VARCHAR(10));
C1: set @newincr=0;
C1: INSERT INTO tb1 SELECT (@newincr:=@newincr+1),(@newincr)%100 FROM db_class a,db_class b,db_class c,db_class d LIMIT 100000;
C1: commit;
C1: UPDATE tb1 SET id=id-1,col=col+id;
C1: commit;
MC: wait until C1 ready;

/* test case */
/* expected 4999950000 */
C1: SELECT SUM(id) FROM tb1;
C1: commit work;
C1: DELETE FROM tb1 WHERE id%5=0;
/* expected 4000000000 */ 
C1: SELECT SUM(id) FROM tb1;
C1: rollback;
/* expected 4999950000 */
C1: SELECT SUM(id) FROM tb1;
MC: wait until C1 ready;
C1: quit;

