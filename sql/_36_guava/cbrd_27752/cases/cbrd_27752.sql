autocommit off;

/**
 *  This test case verifies CBRD-27752: an INSERT in a trigger action runs on the server when its
 *  own target table has no trigger for it, and gives the same results as on the client.
 *
 *  An INSERT in a trigger action always ran on the client. It now runs on the server, where an
 *  ON DUPLICATE KEY UPDATE or a REPLACE that hits a row of an earlier statement of the same
 *  transaction passes the row instead of locking it - the deadlock of the issue needs a second
 *  transaction and is checked by the isolation TCs. It stays on the client while the statement
 *  that fired the trigger is a client UPDATE of more than one row, which defers its unique check.
 *
 *  Each odd case runs a block of statements whose trigger action INSERT runs on the server.
 *  The even case after it runs the same block, character for character, with a trigger whose
 *  action is the same INSERT with the hint INSERT_EXECUTION_MODE(0), which keeps that INSERT on
 *  the client. The two cases must print the same rows.
 *
 *  Coverage:
 *    Case 1:  an AFTER UPDATE action inserts a child of the new key, fired by a one-row UPDATE,
 *             whose action INSERT runs on the server, and then by a two-row UPDATE, whose action
 *             INSERT stays on the client
 *    Case 2:  Case 1 with the action INSERT on the client
 *    Case 3:  LAST_INSERT_ID after an INSERT whose action inserts into a table with AUTO_INCREMENT
 *    Case 4:  Case 3 with the action INSERT on the client
 *    Case 5:  an action ON DUPLICATE KEY UPDATE on a row that an earlier statement updated
 *    Case 6:  Case 5 with the action INSERT on the client
 *    Case 7:  an action REPLACE on a row that an earlier statement updated
 *    Case 8:  Case 7 with the action INSERT on the client
 */

-- the odd cases rely on insert_execution_mode at its default, under which these INSERT statements run on the server

drop table if exists t27752_p, t27752_ch, t27752_a, t27752_b, t27752_s, t27752_t;
commit;


evaluate 'Case 1: an action inserts a child of the new key, one-row then two-row UPDATE; result = keys 10, 102, 103 with a child each';
create table t27752_p (k int primary key);
create table t27752_ch (cid int auto_increment primary key, pk int, foreign key (pk) references t27752_p (k));
insert into t27752_p values (1), (2), (3);
create trigger trg27752_p after update on t27752_p execute insert into t27752_ch (pk) values (obj.k);
commit;
update t27752_p set k = 10 where k = 1;
commit;
update t27752_p set k = k + 100 where k in (2, 3);
commit;
select k from t27752_p order by k;
select pk from t27752_ch order by pk;
drop trigger trg27752_p;
drop table t27752_ch, t27752_p;
commit;


evaluate 'Case 2: Case 1 with the action INSERT on the client; result = the same as Case 1';
create table t27752_p (k int primary key);
create table t27752_ch (cid int auto_increment primary key, pk int, foreign key (pk) references t27752_p (k));
insert into t27752_p values (1), (2), (3);
create trigger trg27752_p after update on t27752_p execute insert /*+ INSERT_EXECUTION_MODE(0) */ into t27752_ch (pk) values (obj.k);
commit;
update t27752_p set k = 10 where k = 1;
commit;
update t27752_p set k = k + 100 where k in (2, 3);
commit;
select k from t27752_p order by k;
select pk from t27752_ch order by pk;
drop trigger trg27752_p;
drop table t27752_ch, t27752_p;
commit;


evaluate 'Case 3: LAST_INSERT_ID after an INSERT whose action inserts into an AUTO_INCREMENT table; result = 1, the value of the firing INSERT';
create table t27752_a (id int auto_increment primary key, v int);
create table t27752_b (id int auto_increment (100, 1) primary key, aid int);
create trigger trg27752_a after insert on t27752_a execute insert into t27752_b (aid) values (obj.id);
commit;
insert into t27752_a (v) values (10);
select last_insert_id ();
select id, v from t27752_a order by id;
select id, aid from t27752_b order by id;
commit;
drop trigger trg27752_a;
drop table t27752_b, t27752_a;
commit;


evaluate 'Case 4: Case 3 with the action INSERT on the client; result = the same as Case 3';
create table t27752_a (id int auto_increment primary key, v int);
create table t27752_b (id int auto_increment (100, 1) primary key, aid int);
create trigger trg27752_a after insert on t27752_a execute insert /*+ INSERT_EXECUTION_MODE(0) */ into t27752_b (aid) values (obj.id);
commit;
insert into t27752_a (v) values (10);
select last_insert_id ();
select id, v from t27752_a order by id;
select id, aid from t27752_b order by id;
commit;
drop trigger trg27752_a;
drop table t27752_b, t27752_a;
commit;


-- Case 5 to Case 8: the UPDATE of row 1 gives its row lock back when it ends, and the action of the
-- INSERT into t27752_s that follows reaches row 1 again; the second INSERT reaches a key with no row
evaluate 'Case 5: an action ON DUPLICATE KEY UPDATE on a row that an earlier statement updated; result = (1, 101), (2, 0), (3, 0)';
create table t27752_t (id int primary key, v int);
create table t27752_s (id int);
insert into t27752_t values (1, 0), (2, 0);
create trigger trg27752_s after insert on t27752_s execute insert into t27752_t values (obj.id, 0) on duplicate key update v = v + 100;
commit;
update t27752_t set v = v + 1 where id = 1;
insert into t27752_s values (1);
insert into t27752_s values (3);
select id, v from t27752_t order by id;
commit;
drop trigger trg27752_s;
drop table t27752_s, t27752_t;
commit;


evaluate 'Case 6: Case 5 with the action INSERT on the client; result = the same as Case 5';
create table t27752_t (id int primary key, v int);
create table t27752_s (id int);
insert into t27752_t values (1, 0), (2, 0);
create trigger trg27752_s after insert on t27752_s execute insert /*+ INSERT_EXECUTION_MODE(0) */ into t27752_t values (obj.id, 0) on duplicate key update v = v + 100;
commit;
update t27752_t set v = v + 1 where id = 1;
insert into t27752_s values (1);
insert into t27752_s values (3);
select id, v from t27752_t order by id;
commit;
drop trigger trg27752_s;
drop table t27752_s, t27752_t;
commit;


evaluate 'Case 7: an action REPLACE on a row that an earlier statement updated; result = (1, 100), (2, 0), (3, 100)';
create table t27752_t (id int primary key, v int);
create table t27752_s (id int);
insert into t27752_t values (1, 0), (2, 0);
create trigger trg27752_s after insert on t27752_s execute replace into t27752_t values (obj.id, 100);
commit;
update t27752_t set v = v + 1 where id = 1;
insert into t27752_s values (1);
insert into t27752_s values (3);
select id, v from t27752_t order by id;
commit;
drop trigger trg27752_s;
drop table t27752_s, t27752_t;
commit;


evaluate 'Case 8: Case 7 with the action INSERT on the client; result = the same as Case 7';
create table t27752_t (id int primary key, v int);
create table t27752_s (id int);
insert into t27752_t values (1, 0), (2, 0);
create trigger trg27752_s after insert on t27752_s execute replace /*+ INSERT_EXECUTION_MODE(0) */ into t27752_t values (obj.id, 100);
commit;
update t27752_t set v = v + 1 where id = 1;
insert into t27752_s values (1);
insert into t27752_s values (3);
select id, v from t27752_t order by id;
commit;
drop trigger trg27752_s;
drop table t27752_s, t27752_t;
commit;

autocommit on;
