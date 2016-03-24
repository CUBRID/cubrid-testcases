--+ holdcas on;
--cases from dev

set system parameters 'group_concat_max_len=1024';

create table t(i int);
insert into t values (4),(2),(3),(6),(1),(5);
select group_concat(i*2+1 order by 1 separator '') from t;
drop table t;



create table t (test_no int, std_id int, score1 int, score2 int, score3 int);
insert into t values(1, 1, 50, 70, 80); 
insert into t values(1, 2, 40, 30, 50); 
insert into t values(1, 3, 90, 90, 100); 
insert into t values(1, 4, 80, 70, 90); 
insert into t values(2, 1, 60, 60, 80); 
insert into t values(2, 2, 30, 60, 70); 
insert into t values(2, 3, 80, 90, 95); 
insert into t values(2, 4, 60, 70, 100); 
insert into t values(3, 1, 80, 80, 90); 
insert into t values(3, 2, 70, 60, 95); 
insert into t values(3, 3, 90, 70, 85); 
insert into t values(3, 4, 70, 80, 90); 

-- check expression
select test_no, group_concat(score1 order by 1) from t group by test_no;
select std_id, group_concat(score2 order by 1) from t group by std_id;
select std_id, group_concat(score1 + 100 order by 1), group_concat(score2 - 100 order by 1) from t group by std_id;
select std_id, group_concat(score1 * 10 order by 1), group_concat(score3 / 10 order by 1) from t group by std_id;
select std_id, group_concat(score1 + 5.4 order by 1), group_concat(score2 - 6.3 order by 1) from t group by std_id;
select std_id, group_concat(score1 * 0.7 order by 1), group_concat(score3 / 9 order by 1) from t group by std_id;

-- when expression returns floating-point values
-- MySQL returns the same results by the following statements, but CUBRID does not.
select group_concat(score3 / 9 order by 1) from t;
select group_concat(score3 / 9.0 order by 1) from t;

-- check DISTINCT and SEPARATOR
select std_id, group_concat(score1 order by 1), group_concat(score2 order by 1), group_concat(score3 order by 1) from t group by std_id;
select std_id, group_concat(distinct score1 order by 1), group_concat(score1 order by 1) from t group by std_id;
select std_id, group_concat(distinct score1 order by 1 separator '+'), group_concat(score2 order by 1 separator '-'), group_concat(score3 order by 1) from t group by std_id;

-- DISTINCT with expression
select group_concat(distinct score1 + 1 order by 1) from t;
select group_concat(distinct score1 - 1 order by 1) from t;
select group_concat(distinct score1 * 10 order by 1) from t;
select group_concat(distinct score1 / 10 order by 1) from t;

-- separator is accepted but it returns wrong result
select std_id, group_concat(distinct score1 order by 1 separator X'31') from t group by std_id;
select std_id, group_concat(distinct score1 order by 1 separator B'00110001') from t group by std_id;
select std_id, group_concat(score1 order by 1 separator X'31') from t group by std_id;
select std_id, group_concat(score1 order by 1 separator B'00110001') from t group by std_id;

-- check parameter 
set system parameters 'group_concat_max_len=16';
select std_id, group_concat(score1 order by 1 separator '******') from t group by std_id;
-- set default value if invalid value is given
set system parameters 'group_concat_max_len=-1';
select std_id, group_concat(score1 order by 1 separator '******') from t group by std_id;
set system parameters 'group_concat_max_len=1024';

-- return an error when no group by clause is specified
select std_id, group_concat(score1) from t;
-- but the following statements can be executed
select group_concat(score1 order by 1) from t;
select group_concat(score1 order by 1), group_concat(score2 order by 1), group_concat(distinct score3 order by 1) from t;


-- check expression including date/time types
create table t2 (id int, d date, t time, dt datetime, ts timestamp);
insert into t2 values(1, date'08/02/2010', time'09:30:30 AM', datetime'09:30:30.000 AM 08/02/2010', timestamp'09:30:30 AM 08/02/2010');
insert into t2 values(1, date'08/12/2010', time'09:40:40 AM', datetime'09:40:40.000 AM 08/12/2010', timestamp'09:40:40 AM 08/12/2010');
insert into t2 values(2, date'08/01/2010', time'08:30:30 AM', datetime'08:30:30.000 AM 08/01/2010', timestamp'08:30:30 AM 08/01/2010');
insert into t2 values(2, date'08/11/2010', time'08:40:40 AM', datetime'08:40:40.000 AM 08/11/2010', timestamp'08:40:40 AM 08/11/2010');
select id, group_concat(d order by 1), group_concat(t order by 1), group_concat(dt order by 1), group_concat(ts order by 1) from t2 group by id;
select id, group_concat(d order by 1), group_concat(d + 1 order by 1) from t2 group by id;
select id, group_concat(t order by 1), group_concat(t + 1 order by 1) from t2 group by id;
select id, group_concat(dt order by 1), group_concat(dt + 1 order by 1) from t2 group by id;
select id, group_concat(ts order by 1), group_concat(ts + 1 order by 1) from t2 group by id;
select id, group_concat(d order by 1), group_concat(d - 1 order by 1) from t2 group by id;
select id, group_concat(t order by 1), group_concat(t - 1 order by 1) from t2 group by id;
select id, group_concat(dt order by 1), group_concat(dt - 1 order by 1) from t2 group by id;
select id, group_concat(ts order by 1), group_concat(ts - 1 order by 1) from t2 group by id;

select id, group_concat(ts order by 1), group_concat(ts - (ts - 1) order by 1) from t2 group by id;

-- check bit types
-- the result is different with that of MySQL
create table t3 (id int, b bit(8));
insert into t3 values(1, b'00110001'), (1, b'00110010'), (1, b'00110011'), (1, b'00110010');
insert into t3 values(2, b'00110100'), (2, b'00110110'), (2, b'00110111'), (2, b'00110100');
select id, group_concat(b order by 1) from t3 group by id;
select id, group_concat(distinct b order by 1) from t3 group by id;
select id, group_concat(b order by 1 separator B'00110000') from t3 group by id;

-- CUBRID returns an error, but MySQL does not.
select id, group_concat(b separator '-') from t3 group by id;


-- check if the table includes null
create table t4 (id int, score int);
insert into t4 values(1, 100), (1, 90), (1, null), (1, 60);
insert into t4 values(2, 80), (2, null), (2, 50), (2, null);
insert into t4 values(3, null), (3, null), (3, null), (3, null);
select id, group_concat(score order by 1) from t4 group by id;
select id, group_concat(distinct score order by 1) from t4 group by id;

-- finalize
drop table t4;
drop table t3;
drop table t2;
drop table t;

commit;
--+ holdcas off;
