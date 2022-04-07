--+ holdcas on;

drop table if exists with_trigger;

call login('dba', '') on class db_user;
CREATE TABLE with_trigger(a int primary key, b char(20), c double);
INSERT INTO with_trigger VALUES (1, 'AAA', 1), (2, 'BBB', 2), (3, 'CCC', 3);
SELECT * FROM with_trigger order by 1;
CREATE TRIGGER trig_bef_upd BEFORE UPDATE ON with_trigger EXECUTE INSERT INTO with_trigger VALUES (11, 'BEFORE UPDATE', 11);
CREATE TRIGGER trig_aft_upd AFTER UPDATE ON with_trigger EXECUTE UPDATE with_trigger SET b='AFTER UPDATE' WHERE a=11;
create user test_user;
grant insert, update on with_trigger to test_user;
call login ('test_user', '') on class db_user;
INSERT INTO dba.with_trigger VALUES (4, 'DDD', 7);
INSERT INTO dba.with_trigger VALUES (5, 'EEE', 8) ON DUPLICATE KEY UPDATE c=c+1;
INSERT INTO dba.with_trigger VALUES (2, 'BEFORE UPDATE', 8) ON DUPLICATE KEY UPDATE c=c+1;
call login('dba', '') on class db_user;
SELECT * from with_trigger order by 1;

drop table with_trigger;
drop user test_user;

--+ holdcas off;
