-- case 1. No cache
create serial s1;
create table t (a int, b int); 
select s1.next_value, s1.current_value;
select serial_next_value(s1), serial_next_value(s1, 1), serial_current_value(s1);
insert into t values (s1.next_value, s1.next_value);
select * from t;
insert into t values (serial_next_value(s1), serial_next_value(s1));
select * from t;

drop serial s1;
drop table t;

-- case 2. No cache increment by 10

create serial s1;
create table t (a int, b int);

select s1.next_value, s1.current_value;
select serial_next_value(s1, 10), serial_next_value(s1, 10), serial_current_value(s1);
insert into t values (s1.next_value, s1.next_value);
select * from t;
insert into t values (serial_next_value(s1, 10), serial_next_value(s1, 10));
select * from t;

drop serial s1;
drop table t;

-- case 3. No cache increment by 10 maxvalue 40

create serial s1 maxvalue 40;
create table t (a int, b int);

select s1.next_value, s1.current_value;
select serial_next_value(s1, 10), serial_next_value(s1, 10), serial_current_value(s1);
insert into t values (s1.next_value, s1.next_value);
select * from t;
insert into t values (serial_next_value(s1, 10), serial_next_value(s1, 10));
select * from t;

drop serial s1;
drop table t;

-- case 4. cache 10
create serial s1 cache 10;
create table t (a int, b int);

select s1.next_value, s1.current_value;
select serial_next_value(s1), serial_next_value(s1, 1), serial_current_value(s1);
insert into t values (s1.next_value, s1.next_value);
select * from t;
insert into t values (serial_next_value(s1), serial_next_value(s1));
select * from t;
select serial_next_value(s1), serial_next_value(s1), serial_next_value(s1),
serial_next_value(s1), serial_next_value(s1);
select serial_next_value(s1), serial_next_value(s1), serial_next_value(s1),
serial_next_value(s1), serial_next_value(s1);

drop serial s1;
drop table t;

--case 5. increment by 5 cache 10
create serial s1 cache 10;
create table t (a int, b int);

select s1.next_value, s1.current_value;
select serial_next_value(s1), serial_next_value(s1, 5), serial_current_value(s1);
insert into t values (s1.next_value, s1.next_value);
select * from t;
insert into t values (serial_next_value(s1, 5), serial_next_value(s1, 5));
select * from t;
select serial_next_value(s1, 5), serial_next_value(s1, 5), serial_next_value(s1, 5),
serial_next_value(s1, 5), serial_next_value(s1, 5);
select serial_next_value(s1, 5), serial_next_value(s1, 5), serial_next_value(s1, 5),
serial_next_value(s1, 5), serial_next_value(s1, 5);

drop serial s1;
drop table t;

--case 6. increment by 15 cache 10
create serial s1 cache 10;
create table t (a int, b int);

select s1.next_value, s1.current_value;
select serial_next_value(s1), serial_next_value(s1, 15), serial_current_value(s1);
insert into t values (s1.next_value, s1.next_value);
select * from t;
insert into t values (serial_next_value(s1, 15), serial_next_value(s1, 15));
select * from t;
select serial_next_value(s1, 15), serial_next_value(s1, 15), serial_next_value(s1, 15),
serial_next_value(s1, 15), serial_next_value(s1, 15);
select serial_next_value(s1, 15), serial_next_value(s1, 15), serial_next_value(s1, 15),
serial_next_value(s1, 15), serial_next_value(s1, 15);

drop serial s1;
drop table t;

