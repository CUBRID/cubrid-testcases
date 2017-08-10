-- test that DROP TABLE drops all associated triggers - simple tables


-- 1. simple triggers on entire table
create table t (i int, j int);
create table u (k int);

create trigger trg before insert on t execute print 'xxx';
insert into t values (1,2);

-- this should also drop 'trg'
drop table t;

-- this should work: a trigger with the same name as the dropped one
create trigger trg before update on u execute print 'yyy';
insert into u values (1);
update u set k = 2;
drop table u;

-- select * from db_root;

-- should return 0
select count(*) as trig_count from db_trigger where name like 'trg';

----------------------------------------------------------------------------

-- 2. simple triggers on some table fields
create table t (i int, j int);

-- triggers on the entire table and on some fields: should all be dropped
create trigger trg1 after insert on t execute print 'inserted into t';
create trigger trg2 before update on t(i) execute print 'updated field i of t';
create trigger trg3 before update on t(j) execute print 'updated field j of t';

-- just check that the triggers are working
insert into t values (1,2), (23, 24);
update t set i = 2;
update t set j = 4;

-- now disable t2: DROP TABLE (later) should delete even disabled triggers
alter trigger trg2 status inactive;

select count(*) as trig_count from db_trigger where name like 'trg%';

drop t;

-- select * from db_root;
select count(*) as trig_count from db_trigger where name like 'trg%';

----------------------------------------------------------------------------

-- 3. statement triggers - don't even know if they are different
create table t (i int);
create trigger trg before statement insert on t execute print 'statement insert';

insert into t values (1), (2), (3);

-- trigger "trg" should go too
drop class t;

-- check if the trigger is gone
-- select * from db_root;
select count(*) as trig_count from db_trigger where name like 'trg';

