--simple tests
--+ holdcas on;
set @a = 1;
select @a;

set @a := 2;
select @a;

select @a, @a + 1 from db_root;

-- as host variable
prepare s from 'select ? from db_root'
execute s using @a
deallocate prepare s;

--undefined session variable
select @novar from db_root;
--wrong syntax in select list
select @b = @a from db_root;

--define in select
select @a, @b:=@a+1 from db_root;

create table t (i int, s varchar(255));

insert into t values (1,'1');
insert into t values (2,'2');
insert into t values (3,'3');
insert into t values (4,'4');

set @a:=0;

select @a:=@a+1 as rowcnt, i*2 as val from t order by i;

insert into t values (@a, @a);

select @a, t.* from t order by i, s;

update t set i = @a + 1 where s = @a;

select @a, t.* from t order by i, s;

delete from t where s = @a - 1;

select @a, t.* from t order by i, s;

deallocate variable @a, @b;

drop table t;

set @a = 1, @b = 1, @c = 1;

deallocate variable @b, @c;

select @a;

select @b;

select @c;

deallocate variable @a;

set @a = 'session variable';

set @a = 'session variable', @b = 'another session variable';

select upper (@a), upper (@b);

deallocate variable @a,@b;

--not allowed in create
set @a = 'asdf';

create table t as select @a as col from db_root;

drop table t;

create view v (col) as select @a from db_root;

drop view v;

drop variable @a;

--prepared statements
prepare s from 'select @a:=?+? from db_root'
execute s using 1, 1
deallocate prepare s;

select @a from db_root;

deallocate variable @a;

--with wrong data type

set @a = date'2010-01-01';
select @a + 1;

set @a = {1, 2, 3};

deallocate variable @a;

set @str_var = 'cubrid';
select @str_var;

set @nchar_var = N'cubrid';
select @nchar_var;

set @date_var = date'2010-01-01';
select @date_var;

set @time_var = time'12:34:56';
select @time_var;

set @datetime_var = datetime'2010-01-01 12:34:56.123';
select @datetime_var;

set @timestamp_var = timestamp'2010-01-01 12:34:56';
select @timestamp_var;

set @int_var = 10;
select @int_var;

set @double_var = 123.456;
select @double_var;

set @float_var = 123.456;
select @float_var;

select repeat(@str_var, 3) from db_root;
select repeat(@nchar_var, 3) from db_root;
select year(@date_var) from db_root;
select hour(@time_var) from db_root;
select time(@datetime_var) from db_root;
select @int_var + @timestamp_var from db_root;
select @double_var - @int_var from db_root;
select (@float_var * @int_var) / @double_var from db_root;

drop variable @str_var, @nchar_var, @date_var, @time_var, @datetime_var, @timestamp_var, @int_var, @double_var, @float_var;

create table t (col smallint);
insert into t values (1),(2),(3);

set @a = (select col from t);
set @a = (select col from t where col = 1);

select @b:=col, @a := @b+col from t order by col;

select @b:=col, @a := @b+col from t order by 1, 2;
select @b:=col, @a := @b+col from t order by col desc;
select @c:=@b:=@a+col from t order by col;

select typeof (@a), typeof (@b), typeof (@c);

deallocate variable @a, @b, @c;

drop table t;

create table t (col integer);
insert into t values (1),(2),(3);

set @a = (select col from t);
set @a = (select col from t where col = 1);

select @b:=col, @a := @b+col from t order by col;

select @b:=col, @a := @b+col from t order by 1, 2;

select @b:=col, @a := @b+col from t order by col desc;
select @c:=@b:=@a+col from t order by col;

select typeof (@a), typeof (@b), typeof (@c);

deallocate variable @a, @b, @c;

drop table t;

create table t (col bigint);
insert into t values (1),(2),(3);

set @a = (select col from t);
set @a = (select col from t where col = 1);

select @b:=v.col, @a := @b+v.col from (select col from t order by col) v order by 1, 2;

select @c:=@b:=@a+v.col from (select col from t order by col) v order by 1;

select typeof (@a), typeof (@b), typeof (@c);

deallocate variable @a, @b, @c;

drop table t;

create table t (col numeric(24,10));
insert into t values (1),(2),(3);

set @a = (select col from t);
set @a = (select col from t where col = 1);

select @b:=v.col, @a := @b+v.col from (select col from t order by col) v order by 1, 2;

select @c:=@b:=@a+v.col from (select col from t order by col) v order by 1;

select typeof (@a), typeof (@b), typeof (@c);

deallocate variable @a, @b, @c;

drop table t;

create table t (col float);
insert into t values (1),(2),(3);

set @a = (select col from t);
set @a = (select col from t where col = 1);

select @b:=v.col, @a := @b+v.col from (select col from t order by col) v order by 1, 2;

select @c:=@b:=@a+v.col from (select col from t order by col) v order by 1;

select typeof (@a), typeof (@b), typeof (@c);

deallocate variable @a, @b, @c;

drop table t;

create table t (col double);
insert into t values (1),(2),(3);

set @a = (select col from t);
set @a = (select col from t where col = 1);

select @b:=v.col, @a := @b+v.col from (select col from t order by col) v order by 1, 2;

select @c:=@b:=@a+v.col from (select col from t order by col) v order by 1;

select typeof (@a), typeof (@b), typeof (@c);

deallocate variable @a, @b, @c;

drop table t;

create table t (col char(8));
insert into t values (1),(2),(3);

set @a = (select col from t);
set @a = (select col from t where col = '1');

select @b:=v.col, @a := concat ('|', @b, v.col, '|'), @a, @b from (select col from t order by col) v order by 1, 2, 3, 4;

select v.col, @c:=@b:=concat ('|', @b, v.col, '|'), @b, @c from (select col from t order by col) v order by 1, 2, 3, 4;

select typeof (@a), typeof (@b), typeof (@c);

deallocate variable @a, @b, @c;

drop table t;

create table t (col varchar(8));
insert into t values (1),(2),(3);

set @a = (select col from t);
set @a = (select col from t where col = '1');

select @b:=v.col, @a := concat ('|', @b, v.col, '|'), @a, @b from (select col from t order by col) v order by 1, 2, 3, 4;

select v.col, @c:=@b:=concat ('|', @b, v.col, '|'), @b, @c from (select col from t order by col) v order by 1, 2, 3, 4;

select typeof (@a), typeof (@b), typeof (@c);

deallocate variable @a, @b, @c;

drop table t;

create table t (col nchar(8));
insert into t values (1),(2),(3);

set @a = (select col from t);
set @a = (select col from t where col = n'1');

select @b:=v.col, @a := concat (n'|', @b, v.col, n'|'), @a, @b from (select col from t order by col) v order by 1, 2, 3, 4;

select v.col, @c:=@b:=concat (n'|', @b, v.col, n'|'), @b, @c from (select col from t order by col) v order by 1, 2, 3, 4;

select typeof (@a), typeof (@b), typeof (@c);

deallocate variable @a, @b, @c;

drop table t;

create table t (col nchar varying(8));
insert into t values (1),(2),(3);

set @a = (select col from t);
set @a = (select col from t where col = n'1');

select @b:=v.col, @a := concat (n'|', @b, v.col, n'|'), @a, @b from (select col from t order by col) v order by 1, 2, 3, 4;

select v.col, @c:=@b:=concat (n'|', @b, v.col, n'|'), @b, @c from (select col from t order by col) v order by 1, 2, 3, 4;

select typeof (@a), typeof (@b), typeof (@c);

deallocate variable @a, @b, @c;

drop table t;

create table t (col date);

insert into t values('2010-01-01 12:00:01.123');

set @a = (select col from t);

select @a;

select typeof (@a);

drop variable @a;

drop table t;

create table t (col time);

insert into t values('2010-01-01 12:00:01.123');

set @a = (select col from t);

select @a;

select typeof (@a);

drop variable @a;

drop table t;

create table t (col datetime);

insert into t values('2010-01-01 12:00:01.123');

set @a = (select col from t);

select @a;

select typeof (@a);

drop variable @a;

drop table t;

create table t (col timestamp);

insert into t values('2010-01-01 12:00:01.123');

set @a = (select col from t);

select @a;

select typeof (@a);

drop variable @a;

drop table t;

create table t (col set);

insert into t values({'2010-01-01 12:00:01.123'});

set @a = (select col from t);

select @a;

select typeof (@a);

drop variable @a;

drop table t;
commit;
--+ holdcas off;
