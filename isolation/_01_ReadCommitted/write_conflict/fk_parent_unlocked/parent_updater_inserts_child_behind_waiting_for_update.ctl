/*
Test Case: fk_parent_unlocked/parent_updater_inserts_child_behind_waiting_for_update
Priority: 1
Reference case: CBRD-27463 (CUBRID/cubrid#8198), CBRD-27941
Author: hgryoo

Test Point:
A transaction updates a parent row, and another transaction's SELECT ... FOR UPDATE of that row holds the row lock while it waits for the first transaction.
The first transaction then inserts a child of that parent. The foreign key check finds the parent without locking its row, so the INSERT does not wait and the two do not deadlock.
This is the TPC-C Payment and New-Order deadlock of CBRD-27941 (district as the parent, history as the child).

NUM_CLIENTS = 2
C1: UPDATE t27463_district SET d_ytd = d_ytd + 10 WHERE d_w_id = 1 AND d_id = 1;
C2: SELECT d_next_o_id FROM t27463_district WHERE d_w_id = 1 AND d_id = 1 FOR UPDATE;
C1: INSERT INTO t27463_history VALUES (1, 1, 1, 10);
C1: COMMIT;
C2: UPDATE t27463_district SET d_next_o_id = d_next_o_id + 1 WHERE d_w_id = 1 AND d_id = 1;
C2: COMMIT;
*/

MC: setup NUM_CLIENTS = 2;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: login as 'dba';
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t27463_history;
C1: DROP TABLE IF EXISTS t27463_district;
C1: CREATE TABLE t27463_district (d_w_id INT, d_id INT, d_ytd INT, d_next_o_id INT, PRIMARY KEY (d_w_id, d_id));
C1: CREATE TABLE t27463_history (h_c_id INT, h_d_id INT, h_w_id INT, h_amount INT, FOREIGN KEY (h_w_id, h_d_id) REFERENCES t27463_district (d_w_id, d_id));
C1: INSERT INTO t27463_district VALUES (1, 1, 0, 1);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27463_district SET d_ytd = d_ytd + 10 WHERE d_w_id = 1 AND d_id = 1;
MC: wait until C1 ready;
C2: SELECT d_next_o_id FROM t27463_district WHERE d_w_id = 1 AND d_id = 1 FOR UPDATE;
MC: wait until C2 blocked;
C1: INSERT INTO t27463_history VALUES (1, 1, 1, 10);
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: UPDATE t27463_district SET d_next_o_id = d_next_o_id + 1 WHERE d_w_id = 1 AND d_id = 1;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 10 2 */
C1: SELECT d_ytd, d_next_o_id FROM t27463_district WHERE d_w_id = 1 AND d_id = 1;
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT COUNT(*) FROM t27463_history WHERE h_w_id = 1 AND h_d_id = 1;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TABLE t27463_history;
C1: DROP TABLE t27463_district;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
