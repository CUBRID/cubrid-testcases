--+ holdcas on;
--insert with subquery

drop table if exists t2, t1;
create table t1(a int auto_increment(500, 10), b char(10) default 'abc', c smallint default 100, primary key(a, b))
partition by hash(a) partitions 5;

insert into t1(a, b) values(1, 'a');
insert into t1(a, b) values(2, 'b');
insert into t1(a, b) values(3, 'c');
insert into t1(b) values('d');
insert into t1(b) values('e');
insert into t1(b, c) values('f', default);


create table t2(a int auto_increment(500, 10), b char(10) default 'abc', c enum('aa', 'bb', 'cc', 'dd', 'updated') default 'dd' collate euckr_bin, primary key(a, b), foreign key(a, b) references t1(a, b) on delete cascade on update restrict)
partition by hash(a) partitions 5;

insert into t2(a, b) values(default, select b from t1 where a=500);
insert into t2(b) values ('e');
insert into t2(b, c) values(select b from t1 where a=520, default);

select * from t2 order by 1, 2, 3;


insert into t2(a, b, c) values(select a from t1 where t1.a=(select a from t2 where a=500), select b from t1 where t1.a=(select a from t2 where a=500), 3) on duplicate key update c=(select 'updated' from t1 where a=1);
select * from t2 order by 1, 2, 3;

select 'g', 999 into var1, var2;
insert into t1(b, c) values(var1, var2); 
insert into t2 set b=(select b from t1 where b=var1), c=1;
select * from t2 order by 1, 2, 3;
drop variable var1, var2;

alter table t2 change column c c enum('aa', 'bb', 'cc', 'dd', 'updated') default 'bb';
replace into t2(a, b) values(select a from t1 where a=500, select b from t1 where a=500);
select * from t2 order by 1, 2, 3;


alter table t1 auto_increment=100;
insert into t1(b, c) select b, default(c) from t2 where t2.a=(select max(a) from t1) limit 1;
select * from t1 order by 1, 2, 3;
commit;

merge into t2 using t1
on (t1.a=t2.a and t1.b=t2.b)
when not matched then
insert values(t1.a, t1.b, select 3 from t2 where rownum=1);

select * from t2 order by 1, 2, 3;


--drop table t1, t2 on cascade constraint;
drop t2, t1;



--+ holdcas off;
