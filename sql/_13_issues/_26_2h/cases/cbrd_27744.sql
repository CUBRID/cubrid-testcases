/**
 *  This test case verifies CBRD-27744: the rollback of a serial DDL keeps the values issued after it
 *
 *  _db_serial does not use MVCC, and a draw changes current_val in place. The rollback of a DDL that
 *  wrote a serial row now puts the definition back and keeps current_val behind no value that was
 *  issued after the write. These cases run in one session: the values after the DDL, if any, are
 *  taken by the transaction of the DDL itself. The cases with a second session, a crash or HA are
 *  shell TCs.
 *
 *  A single ALTER SERIAL stays in the workspace of the client, so a read of _db_serial right after
 *  it writes the row to the server and the rollback runs the undo of that write. The serials have no
 *  cache, so each draw writes current_val. Each serial starts at the value that a case begins from
 *  and takes it once, so started is 1.
 *
 *  Coverage:
 *    Case 1:  START WITH, then a rollback with no value taken: the old value and started stay
 *    Case 2:  the transaction of an ALTER SERIAL takes two values, then rolls back: they are not issued again
 *    Case 3:  CREATE SERIAL, then a rollback: the serial does not exist
 *    Case 4:  DROP SERIAL, then a rollback: the serial goes on from its value
 *    Case 5:  CYCLE on a NOCYCLE serial, then a rollback with no value taken: NOCYCLE and the old value stay
 *    Case 6:  INCREMENT BY -1 CYCLE, then a rollback with no value taken: the old increment and value stay
 */

autocommit off;

drop serial if exists s27744_1;
drop serial if exists s27744_2;
drop serial if exists s27744_3;
drop serial if exists s27744_4;
drop serial if exists s27744_5;
drop serial if exists s27744_6;
commit;

evaluate 'Case 1: START WITH, then a rollback with no value taken; result = 3, started 1, next 4';
create serial s27744_1 start with 3 nocache;
select s27744_1.next_value from db_root;
commit;
alter serial s27744_1 start with 100;
select current_val, started from _db_serial where name = 's27744_1';
rollback;
select current_val, started from _db_serial where name = 's27744_1';
select s27744_1.next_value from db_root;
commit;

evaluate 'Case 2: the transaction of an ALTER SERIAL takes 11 and 12, then rolls back; result = 12, next 13';
create serial s27744_2 start with 10 nocache;
select s27744_2.next_value from db_root;
commit;
alter serial s27744_2 maxvalue 1000;
select max_val from _db_serial where name = 's27744_2';
select s27744_2.next_value from db_root;
select s27744_2.next_value from db_root;
rollback;
select current_val, max_val from _db_serial where name = 's27744_2';
select s27744_2.next_value from db_root;
commit;

evaluate 'Case 3: CREATE SERIAL, then a rollback; result = no row';
create serial s27744_3 start with 1;
select count(*) from _db_serial where name = 's27744_3';
rollback;
select count(*) from _db_serial where name = 's27744_3';
commit;

evaluate 'Case 4: DROP SERIAL at 3, then a rollback; result = 3, next 4';
create serial s27744_4 start with 3 nocache;
select s27744_4.next_value from db_root;
commit;
drop serial s27744_4;
select count(*) from _db_serial where name = 's27744_4';
rollback;
select current_val from _db_serial where name = 's27744_4';
select s27744_4.next_value from db_root;
commit;

evaluate 'Case 5: CYCLE on a NOCYCLE serial at 15 with MAXVALUE 20, then a rollback; result = 15, NOCYCLE, next 16';
create serial s27744_5 start with 15 maxvalue 20 nocache;
select s27744_5.next_value from db_root;
commit;
alter serial s27744_5 cycle;
select cyclic from _db_serial where name = 's27744_5';
rollback;
select current_val, cyclic from _db_serial where name = 's27744_5';
select s27744_5.next_value from db_root;
commit;

evaluate 'Case 6: INCREMENT BY -1 CYCLE at 1 with MAXVALUE 20, then a rollback; result = 1, increment 1, NOCYCLE, next 2';
create serial s27744_6 start with 1 maxvalue 20 nocache;
select s27744_6.next_value from db_root;
commit;
alter serial s27744_6 increment by -1 cycle;
select increment_val, cyclic from _db_serial where name = 's27744_6';
rollback;
select current_val, increment_val, cyclic from _db_serial where name = 's27744_6';
select s27744_6.next_value from db_root;
commit;

drop serial s27744_1;
drop serial s27744_2;
drop serial s27744_4;
drop serial s27744_5;
drop serial s27744_6;
commit;
autocommit on;
