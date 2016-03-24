-- test collation in views

-- default collations
create table t1 (s1 string);
insert into t1 values ('aa');
insert into t1 values ('Ab');
insert into t1 values ('aaa');
insert into t1 values ('Aba');
insert into t1 values ('aaA');
insert into t1 values ('AbA');
insert into t1 values ('aac');
insert into t1 values ('Abc');
insert into t1 values ('aaC');
insert into t1 values ('AbC');
insert into t1 values ('aa1');
insert into t1 values ('Ab1');
insert into t1 values ('aaa1');
insert into t1 values ('Aba1');
insert into t1 values ('aaA1');
insert into t1 values ('AbA1');
insert into t1 values ('aac1');
insert into t1 values ('Abc1');
insert into t1 values ('aaC1');
insert into t1 values ('AbC1');

create view v1 as select * from t1;

select * from t1 order by 1;
select * from v1 order by 1;

drop view v1;
drop table t1;


create table t1 (s1 string collate utf8_en_ci);
insert into t1 values ('aa');
insert into t1 values ('Ab');
insert into t1 values ('aaa');
insert into t1 values ('Aba');
insert into t1 values ('aaA');
insert into t1 values ('AbA');
insert into t1 values ('aac');
insert into t1 values ('Abc');
insert into t1 values ('aaC');
insert into t1 values ('AbC');
insert into t1 values ('aa1');
insert into t1 values ('Ab1');
insert into t1 values ('aaa1');
insert into t1 values ('Aba1');
insert into t1 values ('aaA1');
insert into t1 values ('AbA1');
insert into t1 values ('aac1');
insert into t1 values ('Abc1');
insert into t1 values ('aaC1');
insert into t1 values ('AbC1');

create view v1 as select * from t1;

select * from t1 order by 1;
select * from v1 order by 1;

drop view v1;
drop table t1;
