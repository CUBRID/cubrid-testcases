--+ holdcas on;
-- workspace#368 (map #312, dpin-18b, D-368-02 and D-368-06): the pre-cast of an addition, subtraction, multiplication
-- or division is planned before any row - the load's over compiled domains, the gate's for a node it types - and the
-- SUM and AVG accumulators and the ORDERBY_NUM bound plan theirs too, so qdata_*_dbval casts nothing. Every answer is
-- develop's: a string beside a number or a date, an ENUM's name or ordinal, a string that does not convert (with and
-- without return_null_on_function_errors), a NULL operand that converts nothing, binds the gate types, a session
-- variable holding a string under SUM and AVG, a string ORDERBY_NUM bound, a filter index stream.
drop table if exists pp_t;
create table pp_t (i int, d double, s varchar(20), c char(8), dt date, tm time, dtt datetime, f float,
  e enum ('red', 'green', 'blue'), en enum ('10', '20', '30'), n numeric (10, 2));
insert into pp_t values (1, 1.5, '10', '20', date '2020-01-01', time '10:00:00', datetime '2020-01-01 10:00:00', 1.25, 'green', '20', 3.50);
insert into pp_t values (2, 2.5, 'abc', 'x', date '2020-02-01', time '11:00:00', datetime '2020-02-01 11:00:00', 2.75, 'blue', '30', 4.25);
insert into pp_t values (3, null, null, null, null, null, null, null, null, null, null);
insert into pp_t values (4, null, 'abc', null, null, null, null, null, null, null, null);
-- compiled nodes: a string beside a number
select i, s + i, i + s, s - i, i - s, s * i, s / i, c + d, c - n from pp_t where i = 1;
-- a string that does not convert
select s + i from pp_t where i = 2;
select i - s from pp_t where i = 2;
select s * d from pp_t where i = 2;
set system parameters 'return_null_on_function_errors=yes';
select i, s + i, i - s, s * i, s / d from pp_t order by i;
set system parameters 'return_null_on_function_errors=no';
-- a NULL operand converts nothing
select s + d, d + s, s - d, d - s, s * d, s / d from pp_t where i = 4;
-- dates beside numbers and strings
select dt + f, f + dt, dt + s, s + dt, dt - f from pp_t where i = 1;
select dt - '2019-12-25', '2020-01-10' - dt, tm - '09:00:00', '12:00:00' - tm, dtt - dt from pp_t where i = 1;
-- an ENUM: its name beside a string, its ordinal beside a number
select e + 'x', 'x' + e, e + 1, 1 + e, e - 1, 5 - e, e + e, en + 0 from pp_t where i = 1;
-- binds: the gate types the node
prepare pp_q1 from 'select ? + i, i + ?, ? - i, ? * i, ? / i from pp_t where i = 1';
execute pp_q1 using '5', '6', '7', '8', '9';
execute pp_q1 using 5, 6.5, '7.5', 8, '10';
deallocate prepare pp_q1;
prepare pp_q2 from 'select ? - i from pp_t where i = 1';
execute pp_q2 using 'abc';
execute pp_q2 using null;
deallocate prepare pp_q2;
prepare pp_q3 from 'select e + ?, ? + e, en + ? from pp_t where i = 1';
execute pp_q3 using 'x', 'y', 1;
deallocate prepare pp_q3;
-- plus as concatenation off: strings and an ENUM's name as DOUBLE
set system parameters 'plus_as_concat=no';
select s + c, c - s, en + '1', '1' + en from pp_t where i = 1;
select e + '1' from pp_t where i = 1;
set system parameters 'plus_as_concat=yes';
-- a session variable holding a string under SUM and AVG
set @pp_v = '10';
select sum(@pp_v), avg(@pp_v) from pp_t;
select i, sum(@pp_v), avg(@pp_v) from pp_t group by i order by i;
select sum(distinct @pp_v), avg(distinct @pp_v) from pp_t;
select i, sum(@pp_v) over (), avg(@pp_v) over (partition by i) from pp_t order by i;
set @pp_v = 'abc';
select sum(@pp_v) from pp_t;
drop variable @pp_v;
-- the ORDERBY_NUM bound, and LIMIT's offset + count over binds
prepare pp_q4 from 'select i from pp_t order by i for orderby_num() < ?';
execute pp_q4 using 3;
execute pp_q4 using '3';
deallocate prepare pp_q4;
prepare pp_q5 from 'select i from pp_t order by i limit ?, ?';
execute pp_q5 using 1, 2;
deallocate prepare pp_q5;
-- a filter index whose stream adds a string column to a number
drop table if exists pp_f;
create table pp_f (id int not null, s varchar(10));
insert into pp_f values (1, '10'), (2, '5'), (3, '10');
create index pp_f_fi on pp_f (id) where s + 1 = 11;
insert into pp_f values (4, '10'), (5, '40');
select id from pp_f where id > 0 and s + 1 = 11 using index pp_f_fi(+) order by id;
select id from pp_f where abs (s - 20) = 10 order by id;
drop table pp_f;
drop table pp_t;
--+ holdcas off;
