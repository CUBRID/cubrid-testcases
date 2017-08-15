/*
Test Case: related to CUBRIDSUS-14866 -- http://bts4.nhncorp.com/nhnbts/browse/CUBRIDSUS-14866
Priority: 1
Reference case:
Author: Lily

Test Point:
[MVCC] fail to alter table when use add FOREIGN KEY constraint
*/

/* preparation */
MC: setup NUM_CLIENTS = 1;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C1: commit;

/* test case 1 */
C1: DROP TABLE IF EXISTS t_foreign;
C1: DROP TABLE IF EXISTS t_primary;
C1: CREATE TABLE t_primary(id INT, PRIMARY KEY(id));
C1: CREATE TABLE t_foreign(id INT);
C1: insert into t_foreign values(1);
C1: delete from t_foreign;
C1: alter table t_foreign add constraint fk FOREIGN KEY(id) REFERENCES t_primary(id) ON DELETE CASCADE;
C1: insert into t_primary values(1);
C1: insert into t_foreign values(1);
C1: select * from t_foreign;
C1: commit;
MC: wait until C1 ready;

/* test case 1 */
C1: set transaction isolation level repeatable read;
C1: DROP TABLE IF EXISTS t_foreign;
C1: DROP TABLE IF EXISTS t_primary;
C1: CREATE TABLE t_primary(id INT, PRIMARY KEY(id));
C1: CREATE TABLE t_foreign(id INT);
C1: insert into t_foreign values(1);
C1: delete from t_foreign;
C1: alter table t_foreign add constraint fk FOREIGN KEY(id) REFERENCES t_primary(id) ON DELETE CASCADE;
C1: insert into t_primary values(1);
C1: insert into t_foreign values(1);
C1: select * from t_foreign;
C1: commit;

C1: quit;
