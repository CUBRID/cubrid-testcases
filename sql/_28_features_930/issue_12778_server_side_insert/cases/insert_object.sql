set system parameters 'create_table_reuseoid=no';
--+ holdcas on;
--insert with object

create table t1(a int auto_increment, b char(10) default 'abc');
insert into t1 values(1, default);

create table t2(a t1, b enum('a', 'b', 'c') default 3);

create table t3(a date default '2000-10-10', b t2);
insert into t3 values('2014-03-25', insert into t2(a) values(insert into t1(a) values(2)));


create table t4(a set of object, b t3, c float default 3.3);
insert into t4(a, b) values({insert into t2(a) values(insert into t1 values default)}, insert into t3(b) values(insert into t2(a) values(insert into t1(a) values(2))));

select t4 into var1 from t4;
insert into t3(b) values(insert into t2(a) values(insert into t1(b) values(default))) into :var2;
insert into t4(a, b) values(var1, var2);
insert into t4(a, b) values({var1}, var2);
select b, c from t4 order by 1, 2;


alter table t3 alter column a set default '2014-3-26';
alter table t4 change a a set of object default {var1};
insert into t4(b) values(insert into t3(b) values(insert into t2(a) values(insert into t1(b) values(default))));
select b.a from t4 order by 1;

alter table t2 modify b enum('a', 'b', 'c') default 1;
insert into t4(b) values(insert into t3(b) values(insert into t2(a) values(insert into t1(b) values(default))));
select b.b.b from t4 order by 1;

alter table t1 auto_increment=100;
alter table t2 modify b enum('a', 'b', 'c') default 1;
insert into t4(b) values(insert into t3(b) values(insert into t2(a) values(insert into t1(b) values(default))));
select b.b.a.a from t4 order by 1;


drop table t1, t2, t3, t4;

--+ holdcas off;
set system parameters 'create_table_reuseoid=yes';
