autocommit off;

/**
 *  This test case verifies CBRD-28202: a statement of a trigger action that the server runs
 *  sees the rows that the statement firing the trigger left in the client workspace.
 *
 *  A statement on a table with a trigger runs on the client, so its rows can still be in the
 *  workspace when the trigger action starts. An UPDATE or DELETE in the action runs on the
 *  server and flushed only its own target class, so its foreign key checks missed those rows:
 *  an UPDATE that points a child at the new parent failed, and a DELETE of a parent that a new
 *  child refers to passed its check and left the child to fail when it was flushed.
 *  The fix flushes the workspace before a trigger condition or action runs, except while a
 *  client UPDATE of more than one row changes a unique key and so keeps its rows until the
 *  unique check at its end (Case 7, Case 8, Case 12 and Case 13).
 *
 *  An action that fails is reported as error -528 (error evaluating action), whatever its cause,
 *  so the cases that expect a failure show what the action left with a SELECT after it.
 *
 *  Coverage:
 *    Case 1:  an AFTER INSERT action UPDATE points a child at the new parent
 *    Case 2:  the same with a firing INSERT of two rows
 *    Case 3:  Case 2 rolled back - parent 1 and child 1 of Case 1 stay, child 2 points at no parent
 *    Case 4:  an AFTER INSERT action on the child DELETEs the parent that the new child refers to - error -528, nothing changed
 *    Case 5:  the same with ON DELETE CASCADE - the parent and the new child are both deleted
 *    Case 6:  the action UPDATEs the key of that parent - error -528, nothing changed
 *    Case 7:  UPDATE k = k + 1 of a unique key on a table with a row trigger with an action
 *    Case 8:  the same with a trigger with a condition only
 *    Case 9:  a BEFORE INSERT action inserts a child of the row not inserted yet - error -528, nothing changed
 *    Case 10: a BEFORE UPDATE action inserts a child of the row being updated
 *    Case 11: an UPDATE of two rows that changes no unique key; an action DELETEs the parent that the rows left
 *    Case 12: the same with the primary key changed too - the rows wait for the end of the statement, error -528, nothing changed
 *    Case 13: UPDATE k = k + 1 of a subclass whose unique key is defined on its superclass, with a row trigger with an action
 */


drop table if exists t28202_ch, t28202_p, t28202_t, t28202_log, t28202_sub, t28202_s;
commit;


evaluate 'Case 1: an action UPDATE points a child at the new parent; result = child 1 points at parent 1';
create table t28202_p (id int primary key);
create table t28202_ch (cid int primary key, pid int, foreign key (pid) references t28202_p (id));
insert into t28202_ch values (1, null), (2, null);
create trigger trg28202_p after insert on t28202_p execute update t28202_ch set pid = obj.id where cid = obj.id;
commit;
insert into t28202_p values (1);
select id from t28202_p order by id;
select cid, pid from t28202_ch order by cid;
commit;


-- Case 2 and Case 3 go on with the tables and the trigger of Case 1, and Case 3 rolls back the transaction of Case 2
evaluate 'Case 2: the same with a firing INSERT of two rows; result = child 2 points at parent 2';
insert into t28202_p values (2), (3);
select id from t28202_p order by id;
select cid, pid from t28202_ch order by cid;


evaluate 'Case 3: Case 2 rolled back; result = parent 1 and child 1 of Case 1 stay, child 2 points at no parent';
rollback;
select id from t28202_p order by id;
select cid, pid from t28202_ch order by cid;
drop trigger trg28202_p;
drop table t28202_ch, t28202_p;
commit;


evaluate 'Case 4: an action DELETE of the parent that the new child refers to; result = error -528 from the action, nothing changed';
create table t28202_p (id int primary key);
create table t28202_ch (cid int primary key, pid int, foreign key (pid) references t28202_p (id));
insert into t28202_p values (1), (2);
create trigger trg28202_ch after insert on t28202_ch execute delete from t28202_p where id = obj.pid;
commit;
insert into t28202_ch values (10, 1);
select id from t28202_p order by id;
select cid, pid from t28202_ch order by cid;
commit;
drop trigger trg28202_ch;
drop table t28202_ch, t28202_p;
commit;


evaluate 'Case 5: the same with ON DELETE CASCADE; result = parent 1 and child 10 are deleted';
create table t28202_p (id int primary key);
create table t28202_ch (cid int primary key, pid int, foreign key (pid) references t28202_p (id) on delete cascade);
insert into t28202_p values (1), (2);
create trigger trg28202_ch after insert on t28202_ch execute delete from t28202_p where id = obj.pid;
commit;
insert into t28202_ch values (10, 1);
select id from t28202_p order by id;
select cid, pid from t28202_ch order by cid;
commit;
drop trigger trg28202_ch;
drop table t28202_ch, t28202_p;
commit;


evaluate 'Case 6: an action UPDATE of the key of that parent; result = error -528 from the action, nothing changed';
create table t28202_p (id int primary key);
create table t28202_ch (cid int primary key, pid int, foreign key (pid) references t28202_p (id));
insert into t28202_p values (1), (2);
create trigger trg28202_ch after insert on t28202_ch execute update t28202_p set id = id + 100 where id = obj.pid;
commit;
insert into t28202_ch values (10, 1);
select id from t28202_p order by id;
select cid, pid from t28202_ch order by cid;
commit;
drop trigger trg28202_ch;
drop table t28202_ch, t28202_p;
commit;


-- Case 7 and Case 8: the UPDATE moves key 1 onto key 2 before it moves key 2 away, so the unique check
-- must wait for the end of the statement; a flush in the middle of the statement fails it on the duplicate
evaluate 'Case 7: UPDATE k = k + 1 of a unique key with a row trigger with an action; result = keys 2 and 3, two log rows';
create table t28202_t (id int primary key, k int unique);
create table t28202_log (id int, k int);
insert into t28202_t values (1, 1), (2, 2);
create trigger trg28202_t after update on t28202_t execute insert into t28202_log values (obj.id, obj.k);
commit;
update t28202_t set k = k + 1;
select id, k from t28202_t order by id;
select id, k from t28202_log order by id;
commit;
drop trigger trg28202_t;
drop table t28202_t, t28202_log;
commit;


evaluate 'Case 8: the same with a trigger with a condition only; result = keys 2 and 3, no log row';
create table t28202_t (id int primary key, k int unique);
create table t28202_log (id int, k int);
insert into t28202_t values (1, 1), (2, 2);
create trigger trg28202_t after update on t28202_t if obj.k > 100 execute insert into t28202_log values (obj.id, obj.k);
commit;
update t28202_t set k = k + 1;
select id, k from t28202_t order by id;
select id, k from t28202_log order by id;
commit;
drop trigger trg28202_t;
drop table t28202_t, t28202_log;
commit;


evaluate 'Case 9: a BEFORE INSERT action inserts a child of the row not inserted yet; result = error -528 from the action, nothing changed';
create table t28202_p (id int primary key);
create table t28202_ch (cid int auto_increment primary key, pid int, foreign key (pid) references t28202_p (id));
create trigger trg28202_p before insert on t28202_p execute insert into t28202_ch (pid) values (new.id);
commit;
insert into t28202_p values (1);
select id from t28202_p order by id;
select cid, pid from t28202_ch order by cid;
commit;
drop trigger trg28202_p;
drop table t28202_ch, t28202_p;
commit;


evaluate 'Case 10: a BEFORE UPDATE action inserts a child of the row being updated; result = v 1, one child';
create table t28202_p (id int primary key, v int);
create table t28202_ch (cid int auto_increment primary key, pid int, foreign key (pid) references t28202_p (id));
insert into t28202_p values (1, 0);
create trigger trg28202_p before update on t28202_p execute insert into t28202_ch (pid) values (obj.id);
commit;
update t28202_p set v = v + 1 where id = 1;
select id, v from t28202_p order by id;
select cid, pid from t28202_ch order by cid;
commit;
drop trigger trg28202_p;
drop table t28202_ch, t28202_p;
commit;


-- Case 11 and Case 12: the action of child 1 deletes parent 1, which child 1 referred to before the UPDATE
evaluate 'Case 11: an UPDATE of two rows that changes no unique key; an action DELETE of the parent the rows left; result = parent 1 is deleted';
create table t28202_p (id int primary key);
create table t28202_ch (cid int primary key, pid int, foreign key (pid) references t28202_p (id));
insert into t28202_p values (1), (2), (3);
insert into t28202_ch values (1, 1), (2, 3);
create trigger trg28202_ch after update on t28202_ch if obj.cid = 1 execute delete from t28202_p where id = 1;
commit;
update t28202_ch set pid = 2 where cid in (1, 2);
select id from t28202_p order by id;
select cid, pid from t28202_ch order by cid;
commit;
drop trigger trg28202_ch;
drop table t28202_ch, t28202_p;
commit;


evaluate 'Case 12: the same with the primary key changed too, so the rows wait for the end of the statement; result = error -528 from the action, nothing changed';
create table t28202_p (id int primary key);
create table t28202_ch (cid int primary key, pid int, foreign key (pid) references t28202_p (id));
insert into t28202_p values (1), (2), (3);
insert into t28202_ch values (1, 1), (2, 3);
create trigger trg28202_ch after update on t28202_ch if obj.cid = 11 execute delete from t28202_p where id = 1;
commit;
update t28202_ch set cid = cid + 10, pid = 2 where cid in (1, 2);
select id from t28202_p order by id;
select cid, pid from t28202_ch order by cid;
commit;
drop trigger trg28202_ch;
drop table t28202_ch, t28202_p;
commit;


evaluate 'Case 13: UPDATE k = k + 1 of a subclass whose unique key is defined on its superclass; result = keys 2 and 3, two log rows';
create table t28202_s (id int primary key, k int unique);
create table t28202_sub under t28202_s (x int);
create table t28202_log (id int, k int);
insert into t28202_sub (id, k, x) values (1, 1, 0), (2, 2, 0);
create trigger trg28202_sub after update on t28202_sub execute insert into t28202_log values (obj.id, obj.k);
commit;
update t28202_sub set k = k + 1;
select id, k from t28202_sub order by id;
select id, k from t28202_log order by id;
commit;
drop trigger trg28202_sub;
drop table t28202_sub, t28202_s, t28202_log;
commit;

autocommit on;
