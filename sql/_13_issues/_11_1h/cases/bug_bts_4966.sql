create table t (col smallint);

insert into t values (1),(2),(3);

create index i_t_col on t (col);

select * from t where col < cast(2 as short);

select * from t where col < 2;

select * from t where col < cast(2 as numeric (10, 5));

select * from t where col < cast(2 as float);

select * from t where col < cast(2 as double);

select * from t where col < '2';

prepare s from 'select * from t where col < ?';
execute s using '2';
deallocate prepare s;

prepare s from 'select * from t where col < ?';
execute s using 2;
deallocate prepare s;

select * from t where col < cast(2.1 as numeric (10, 5));

select * from t where col < cast(2.1 as float);

select * from t where col < cast(2.1 as double);

select * from t where col < '2.1';

prepare s from 'select * from t where col < ?';
execute s using '2.1';

prepare s from 'select * from t where col < ?';
execute s using 2.1;

drop table t;

create table t (col int);

insert into t values (1),(2),(3);

create index i_t_col on t (col);

select * from t where col < cast(2 as short);

select * from t where col < 2;

select * from t where col < cast(2 as numeric (10, 5));

select * from t where col < cast(2 as float);

select * from t where col < cast(2 as double);

select * from t where col < '2';

prepare s from 'select * from t where col < ?';
execute s using '2';
deallocate prepare s;

prepare s from 'select * from t where col < ?';
execute s using 2;
deallocate prepare s;

select * from t where col < cast(2.1 as numeric (10, 5));

select * from t where col < cast(2.1 as float);

select * from t where col < cast(2.1 as double);

select * from t where col < '2.1';

prepare s from 'select * from t where col < ?';
execute s using '2.1';

prepare s from 'select * from t where col < ?';
execute s using 2.1;

drop table t;

create table t (col bigint);

insert into t values (1),(2),(3);

create index i_t_col on t (col);

select * from t where col < cast(2 as short);

select * from t where col < 2;

select * from t where col < cast(2 as numeric (10, 5));

select * from t where col < cast(2 as float);

select * from t where col < cast(2 as double);

select * from t where col < '2';

prepare s from 'select * from t where col < ?';
execute s using '2';
deallocate prepare s;

prepare s from 'select * from t where col < ?';
execute s using 2;
deallocate prepare s;

select * from t where col < cast(2.1 as numeric (10, 5));

select * from t where col < cast(2.1 as float);

select * from t where col < cast(2.1 as double);

select * from t where col < '2.1';

prepare s from 'select * from t where col < ?';
execute s using '2.1';

prepare s from 'select * from t where col < ?';
execute s using 2.1;

drop table t;

create table t (col float);

insert into t values (1),(2),(3);

create index i_t_col on t (col);

select * from t where col < cast(2 as short);

select * from t where col < 2;

select * from t where col < cast(2 as numeric (10, 5));

select * from t where col < cast(2 as bigint);

select * from t where col < cast(2 as float);

select * from t where col < cast(2 as double);

select * from t where col < '2';

prepare s from 'select * from t where col < ?';
execute s using '2';
deallocate prepare s;

prepare s from 'select * from t where col < ?';
execute s using 2;
deallocate prepare s;

select * from t where col < cast(2.1 as numeric (10, 5));

select * from t where col < cast(2.1 as float);

select * from t where col < cast(2.1 as double);

select * from t where col < '2.1';

prepare s from 'select * from t where col < ?';
execute s using '2.1';

prepare s from 'select * from t where col < ?';
execute s using 2.1;

drop table t;

create table t (col numeric(10,3));

insert into t values (1),(2),(3);

create index i_t_col on t (col);

select * from t where col < cast(2 as short);

select * from t where col < 2;

select * from t where col < cast(2 as numeric (10, 5));

select * from t where col < cast(2 as float);

select * from t where col < cast(2 as double);

select * from t where col < '2';

prepare s from 'select * from t where col < ?';
execute s using '2';
deallocate prepare s;

prepare s from 'select * from t where col < ?';
execute s using 2;
deallocate prepare s;

select * from t where col < cast(2.1 as numeric (10, 5));

select * from t where col < cast(2.1 as float);

select * from t where col < cast(2.1 as double);

select * from t where col < '2.1';

prepare s from 'select * from t where col < ?';
execute s using '2.1';

prepare s from 'select * from t where col < ?';
execute s using 2.1;

drop table t;

create table t (col double);

insert into t values (1),(2),(3);

create index i_t_col on t (col);

select * from t where col < cast(2 as short);

select * from t where col < 2;

select * from t where col < cast(2 as numeric (10, 5));

select * from t where col < cast(2 as float);

select * from t where col < cast(2 as double);

select * from t where col < '2';

prepare s from 'select * from t where col < ?';
execute s using '2';
deallocate prepare s;

prepare s from 'select * from t where col < ?';
execute s using 2;
deallocate prepare s;

select * from t where col < cast(2.1 as numeric (10, 5));

select * from t where col < cast(2.1 as float);

select * from t where col < cast(2.1 as double);

select * from t where col < '2.1';

prepare s from 'select * from t where col < ?';
execute s using '2.1';

prepare s from 'select * from t where col < ?';
execute s using 2.1;

drop table t;

create table t (col monetary);

insert into t values (1),(2),(3);

create index i_t_col on t (col);

select * from t where col < cast(2 as short);

select * from t where col < 2;

select * from t where col < cast(2 as numeric (10, 5));

select * from t where col < cast(2 as float);

select * from t where col < cast(2 as double);

select * from t where col < '2';

prepare s from 'select * from t where col < ?';
execute s using '2';
deallocate prepare s;

prepare s from 'select * from t where col < ?';
execute s using 2;
deallocate prepare s;

select * from t where col < cast(2.1 as numeric (10, 5));

select * from t where col < cast(2.1 as float);

select * from t where col < cast(2.1 as double);

select * from t where col < '2.1';

prepare s from 'select * from t where col < ?';
execute s using '2.1';

prepare s from 'select * from t where col < ?';
execute s using 2.1;

drop table t;

create table t (col time);

insert into t values ('12:00:01'),('13:01:02'),('14:03:58');

create index i_t_col on t (col);

select * from t where col < '13:01:02';

select * from t where col <= '13:01:02';

select * from t where col <= '2010-01-01 13:01:02';

select * from t where col <= datetime'2010-01-01 13:01:02';

select * from t where col <= date'2010-01-01';

select * from t where col <= timestamp'2010-01-01 13:01:02';

prepare s from 'select * from t where col <= ?';
execute s using '13:01:02';
execute s using '13:01:01';
execute s using '2010-01-01 13:01:02';
execute s using time'2010-01-01 13:01:02';
execute s using timestamp'2010-01-01 13:01:02';
execute s using datetime'2010-01-01 13:01:02';
deallocate prepare s;

drop table t;

create table t (col date);

insert into t values ('2010-01-01'),('2010-02-13'),('2010-03-04');

create index i_t_col on t (col);

select * from t where col < '13:01:02';

select * from t where col <= '2010-02-13';

$date, $2010-02-13
select * from t where col <= ?;

$varchar, $2010-02-13
select * from t where col <= ?;

$datetime, $2010-02-13 12:00:01
select * from t where col <= ?;

$datetime, $2010-02-13 00:00:00
select * from t where col <= ?;

$timestamp, $2010-02-13 12:00:01
select * from t where col <= ?;

$timestamp, $2010-02-13 00:00:00
select * from t where col <= ?;

drop table t;


