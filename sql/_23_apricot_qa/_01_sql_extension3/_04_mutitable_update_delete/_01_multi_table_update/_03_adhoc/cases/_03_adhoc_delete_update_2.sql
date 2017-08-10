drop table if exists aoo,boo;
create table aoo(a int, b bigint primary key );
create table boo(c char(20) primary key);
insert into aoo values(1,1), (2,2), (3,3);
insert into boo values('a'), ('b'), ('c');
 delete a, b from aoo a, boo b where a.a >1 and b.c='a';


drop table if exists aoo,boo;
create table aoo(a int, b bigint, primary key(b,a) ) partition by hash(a) partitions 5;
create table boo(c char(20) primary key) partition by hash(c) partitions 5;
insert into aoo values(1,1), (2,2), (3,3);
insert into boo values('a'), ('b'), ('c');
delete a, b from aoo a, boo b where a.a >1 and b.c='a';
drop aoo,boo;


drop  table if exists md_int1,md_int2;
create table md_int1(id1 int primary key ) partition by hash(id1) partitions 5;
insert into md_int1 values(1);
create table md_int2(id2 int primary key)  partition by hash(id2) partitions 5;
delete m1, m2 from md_int1 m1 left outer join md_int2 m2 on m1.id1=m2.id2;
select * from md_int1 order by 1;
drop md_int1,md_int2;


drop  table if exists m1,m2;
create table m1(id1 int primary key ) partition by hash(id1) partitions 5;
create table m2(id2 int primary key ) partition by hash(id2) partitions 5;
insert into m1 select rownum from db_class limit 10;
insert into m2 select rownum from db_class limit 10;
delete m1, m2 from m1, m2 where m1.id1=m2.id2 and m1.id1 < (select avg(id2) from m2) and rownum <2;
delete m1, m2 from m1, m2 where m1.id1=m2.id2 and m1.id1 < (select avg(id2) from m2);
drop table m1,m2;



drop  table if exists m1,m2,m3,m4,m5;
create table m1(id1 int primary key ) partition by hash(id1) partitions 5;
create table m2(id2 int primary key ) partition by hash(id2) partitions 5;
create table m3(id3 int primary key ) partition by hash(id3) partitions 5;
create table m4(id4 int primary key ) partition by hash(id4) partitions 5;
create table m5(id5 int primary key ) partition by hash(id5) partitions 5;
insert into m1 select rownum from db_class limit 10;
insert into m2 select rownum from db_class limit 10;
insert into m3 select rownum from db_class limit 10;
insert into m4 select rownum from db_class limit 10;
insert into m5 select rownum from db_class limit 10;
delete m1, m2,m3,m4,m5 from m1, m2,m3,m4,m5 where m1.id1=m2.id2  and m2.id2=m3.id3 and m1.id1=m4.id4 and m1.id1=m5.id5  and m1.id1 < (select avg(id2) from m2);
drop  table  m1,m2,m3,m4,m5;



drop  table if exists m1,m2,m3,m4,m5;
create table m1(id1 int primary key );
create table m2(id2 int primary key );
create table m3(id3 int primary key );
create table m4(id4 int primary key );
create table m5(id5 int primary key ) ;
insert into m1 select rownum from db_class limit 10;
insert into m2 select rownum from db_class limit 10;
insert into m3 select rownum from db_class limit 10;
insert into m4 select rownum from db_class limit 10;
insert into m5 select rownum from db_class limit 10;
select m1, m2,m3,m4,m5 from m1, m2,m3,m4,m5 where m1.id1=m2.id2  and m2.id2=m3.id3 and m1.id1=m4.id4 and m1.id1=m5.id5  and m1.id1 < (select avg(id2) from m2);
delete m1, m2,m3,m4,m5 from m1, m2,m3,m4,m5 where m1.id1=m2.id2  and m2.id2=m3.id3 and m1.id1=m4.id4 and m1.id1=m5.id5  and m1.id1 < (select avg(id2) from m2);
delete m1, m2,m3,m4,m5 from m1, m2,m3,m4,m5 where m1.id1=m2.id2  and m2.id2=m3.id3 and m1.id1=m4.id4 and m1.id1=m5.id5  and m1.id1 < (select avg(id2) from m2) and rownum <10;
drop  table m1,m2,m3,m4,m5;



drop  table if exists m1,m2;
create table m1(id1 int primary key ) partition by hash(id1) partitions 1;
create table m2(id2 int primary key ) partition by hash(id2) partitions 1;
delete m1, m2 from m1,m2;


drop  table if exists  m1, m2,m3,m4,m5,m6,m7,m8,m9,m10;
create table m1(id1 int primary key );
create table m2(id2 int primary key );
create table m3(id3 int primary key );
create table m4(id4 int primary key );
create table m5(id5 int primary key ) ;
create table m6(id6 int primary key );
create table m7(id7 int primary key );
create table m8(id8 int primary key );
create table m9(id9 int primary key );
create table m10(id10 int primary key ) ;
insert into m1 select rownum from db_class limit 10;
insert into m2 select rownum from db_class limit 10;
insert into m3 select rownum from db_class limit 10;
insert into m4 select rownum from db_class limit 10;
insert into m5 select rownum from db_class limit 10;
insert into m6 select rownum from db_class limit 10;
insert into m7 select rownum from db_class limit 10;
insert into m8 select rownum from db_class limit 10;
insert into m9 select rownum from db_class limit 10;
insert into m10 select rownum from db_class limit 10;
delete m1,m2,m3,m4,m5,m6,m7,m8,m9,m10 from m1 INNER JOIN m2 
on m1.id1=m2.id2 inner join m3 on m1.id1=m3.id3 inner join m4 on m1.id1=m4.id4   inner join m5 on m1.id1=m5.id5  inner join m6 on m5.id5=m6.id6  inner join m7 on m1.id1=m7.id7  inner join m8 on m1.id1=m8.id8   inner join m9 on m1.id1=m9.id9  inner join m10 on m1.id1=m10.id10;
delete m1,m2,m3,m4,m5,m6,m7,m8,m9,m10 from m1, m2,m3,m4,m5,m6,m7,m8,m9,m10;
drop table m1, m2,m3,m4,m5,m6,m7,m8,m9,m10;




drop  table if exists  m1, m2,m3,m4,m5,m6,m7,m8,m9,m10;
create table m1(id1 int auto_increment(1,10));
create table m2(id2 int auto_increment(1,10));
create table m3(id3 int auto_increment(1,10));
create table m4(id4 int auto_increment(1,10));
create table m5(id5 int auto_increment(1,10)) ;
create table m6(id6 int auto_increment(1,10));
create table m7(id7 int auto_increment(1,10));
create table m8(id8 int auto_increment(1,10));
create table m9(id9 int auto_increment(1,10));
create table m10(id10 int auto_increment(1,10)) ;
insert into m1 select null  from db_class limit 50;
insert into m2 select null  from db_class limit 50;
insert into m3 select null  from db_class limit 50;
insert into m4 select null  from db_class limit 50;
insert into m5 select null  from db_class limit 50;
insert into m6 select null  from db_class limit 50;
insert into m7 select null  from db_class limit 50;
insert into m8 select null  from db_class limit 50;
insert into m9 select null  from db_class limit 50;
insert into m10 select null  from db_class limit 50;
delete m1,m2,m3,m4,m5,m6,m7,m8,m9,m10 from m1 INNER JOIN m2 
on m1.id1=m2.id2 inner join m3 on m1.id1=m3.id3 inner join m4 on m1.id1=m4.id4   inner join m5 on m1.id1=m5.id5  inner join m6 on m5.id5=m6.id6  inner join m7 on m1.id1=m7.id7  inner join m8 on m1.id1=m8.id8   inner join m9 on m1.id1=m9.id9  inner join m10 on m1.id1=m10.id10;
delete m1,m2,m3,m4,m5,m6,m7,m8,m9,m10 from m1, m2,m3,m4,m5,m6,m7,m8,m9,m10;
drop table m1, m2,m3,m4,m5,m6,m7,m8,m9,m10;




drop table if exists foo;
create table foo(a varchar(10) primary key ) partition by hash(a) partitions 5;
insert into foo values(3);
create view v as select * from foo where a <2;
update v set a=3;
drop view v;
create view v as select * from foo where a <2;
update foo set a=1;
update v set a=3;
drop table foo;
drop view v;





drop table if exists t1;
drop table if exists t2;
create table t1(a int) partition by hash(a) partitions 10;
insert into t1 values(1), (2), (3);
create table t2(a int) partition by hash(a) partitions 10;
insert into t2 values(1), (2);
delete t1.* from t2 as t1, t1 as t2 where t1.a=t2.a and t2.a is not null;
delete t1.*,t2.* from t2 as t1, t1 as t2;
delete t1,t2 from t2 as t1, t1 as t2;
select * from t1 order by 1 ;
select * from t2 order by 1;
drop table t1,t2;




drop table if exists t1;
drop table if exists t2;
create table t1(a enum('a', 'b', 'c') primary key);
insert into t1 values(1), (2), (3);
create table t2(a enum('a', 'b', 'c') primary key);
insert into t2 values(1), (2), (3);
delete t1.*,t2.* from t2 as t1 left join t1 as t2 on  t1.a=t2.a;
drop t1, t2;




drop table if exists foo,aoo;
create table foo(a int);
insert into foo(a) values(1), (2), (3);
create table aoo(c bigint);
insert into aoo values(3), (2);
delete f, a from foo f, aoo a where f.a=a.c;
drop table foo,aoo;




drop table if exists  test;
CREATE TABLE "test"(
"col1" integer auto_increment(1,1) primary key,
"col2" smallint NOT NULL DEFAULT 0,
"col3" smallint NOT NULL DEFAULT 0,
"col4" smallint NOT NULL DEFAULT 0,
"col5" smallint NOT NULL DEFAULT 0,
"col6" smallint NOT NULL DEFAULT 0,
"col7" smallint NOT NULL DEFAULT 0,
"col8" smallint NOT NULL DEFAULT 0,
"col9" smallint NOT NULL DEFAULT 0,
"col10" smallint NOT NULL DEFAULT 0,
"col11" smallint NOT NULL DEFAULT 0,
"col12" smallint NOT NULL DEFAULT 0,
"col13" smallint NOT NULL DEFAULT 0,
"col14" smallint NOT NULL DEFAULT 0,
"col15" smallint NOT NULL DEFAULT 0,
"col16" smallint NOT NULL DEFAULT 0,
"col17" smallint NOT NULL DEFAULT 0,
"col18" smallint NOT NULL DEFAULT 0,
"col19" smallint NOT NULL DEFAULT 0,
"col20" smallint NOT NULL DEFAULT 0,
"col21" smallint NOT NULL DEFAULT 0,
"col22" smallint NOT NULL DEFAULT 0,
"col23" smallint NOT NULL DEFAULT 0,
"col24" smallint NOT NULL DEFAULT 0,
"col25" smallint NOT NULL DEFAULT 0,
"col26" smallint NOT NULL DEFAULT 0,
"col27" smallint NOT NULL DEFAULT 0,
"col28" smallint NOT NULL DEFAULT 0,
"col29" smallint NOT NULL DEFAULT 0,
"col30" smallint NOT NULL DEFAULT 0,
"col31" smallint NOT NULL DEFAULT 0,
"col32" smallint NOT NULL DEFAULT 0,
"col33" smallint NOT NULL DEFAULT 0,
"col34" smallint NOT NULL DEFAULT 0,
"col35" smallint NOT NULL DEFAULT 0,
"col36" smallint NOT NULL DEFAULT 0,
"col37" smallint NOT NULL DEFAULT 0,
"col38" smallint NOT NULL DEFAULT 0,
"col39" smallint NOT NULL DEFAULT 0,
"col40" smallint NOT NULL DEFAULT 0,
"col41" smallint NOT NULL DEFAULT 0,
"col42" smallint NOT NULL DEFAULT 0,
"col43" smallint NOT NULL DEFAULT 0,
"col44" smallint NOT NULL DEFAULT 0,
"col45" smallint NOT NULL DEFAULT 0,
"col46" smallint NOT NULL DEFAULT 0,
"col47" smallint NOT NULL DEFAULT 0,
"col48" smallint NOT NULL DEFAULT 0,
"col49" smallint NOT NULL DEFAULT 0,
"col50" smallint NOT NULL DEFAULT 0,
"col51" smallint NOT NULL DEFAULT 0,
"col52" smallint NOT NULL DEFAULT 0,
"col53" smallint NOT NULL DEFAULT 0,
"col54" smallint NOT NULL DEFAULT 0,
"col55" smallint NOT NULL DEFAULT 0,
"col56" smallint NOT NULL DEFAULT 0,
"col57" smallint NOT NULL DEFAULT 0,
"col58" smallint NOT NULL DEFAULT 0,
"col59" smallint NOT NULL DEFAULT 0,
"col60" smallint NOT NULL DEFAULT 0
)
;

drop table if exists  test2;
CREATE TABLE "test2"(
"col1" integer auto_increment(1,1) primary key,
"col2" smallint NOT NULL DEFAULT 0,
"col3" smallint NOT NULL DEFAULT 0,
"col4" smallint NOT NULL DEFAULT 0,
"col5" smallint NOT NULL DEFAULT 0,
"col6" smallint NOT NULL DEFAULT 0,
"col7" smallint NOT NULL DEFAULT 0,
"col8" smallint NOT NULL DEFAULT 0,
"col9" smallint NOT NULL DEFAULT 0,
"col10" smallint NOT NULL DEFAULT 0,
"col11" smallint NOT NULL DEFAULT 0,
"col12" smallint NOT NULL DEFAULT 0,
"col13" smallint NOT NULL DEFAULT 0,
"col14" smallint NOT NULL DEFAULT 0,
"col15" smallint NOT NULL DEFAULT 0,
"col16" smallint NOT NULL DEFAULT 0,
"col17" smallint NOT NULL DEFAULT 0,
"col18" smallint NOT NULL DEFAULT 0,
"col19" smallint NOT NULL DEFAULT 0,
"col20" smallint NOT NULL DEFAULT 0,
"col21" smallint NOT NULL DEFAULT 0,
"col22" smallint NOT NULL DEFAULT 0,
"col23" smallint NOT NULL DEFAULT 0,
"col24" smallint NOT NULL DEFAULT 0,
"col25" smallint NOT NULL DEFAULT 0,
"col26" smallint NOT NULL DEFAULT 0,
"col27" smallint NOT NULL DEFAULT 0,
"col28" smallint NOT NULL DEFAULT 0,
"col29" smallint NOT NULL DEFAULT 0,
"col30" smallint NOT NULL DEFAULT 0,
"col31" smallint NOT NULL DEFAULT 0,
"col32" smallint NOT NULL DEFAULT 0,
"col33" smallint NOT NULL DEFAULT 0,
"col34" smallint NOT NULL DEFAULT 0,
"col35" smallint NOT NULL DEFAULT 0,
"col36" smallint NOT NULL DEFAULT 0,
"col37" smallint NOT NULL DEFAULT 0,
"col38" smallint NOT NULL DEFAULT 0,
"col39" smallint NOT NULL DEFAULT 0,
"col40" smallint NOT NULL DEFAULT 0,
"col41" smallint NOT NULL DEFAULT 0,
"col42" smallint NOT NULL DEFAULT 0,
"col43" smallint NOT NULL DEFAULT 0,
"col44" smallint NOT NULL DEFAULT 0,
"col45" smallint NOT NULL DEFAULT 0,
"col46" smallint NOT NULL DEFAULT 0,
"col47" smallint NOT NULL DEFAULT 0,
"col48" smallint NOT NULL DEFAULT 0,
"col49" smallint NOT NULL DEFAULT 0,
"col50" smallint NOT NULL DEFAULT 0,
"col51" smallint NOT NULL DEFAULT 0,
"col52" smallint NOT NULL DEFAULT 0,
"col53" smallint NOT NULL DEFAULT 0,
"col54" smallint NOT NULL DEFAULT 0,
"col55" smallint NOT NULL DEFAULT 0,
"col56" smallint NOT NULL DEFAULT 0,
"col57" smallint NOT NULL DEFAULT 0,
"col58" smallint NOT NULL DEFAULT 0,
"col59" smallint NOT NULL DEFAULT 0,
"col60" smallint NOT NULL DEFAULT 0
)
;
insert into test(col1) select null from db_class limit 10;
insert into test2(col1)  select null  from db_class limit 10;
delete t1,t2 from test2 as t1, test as t2 where t1.col1=t2.col1 ;
drop table test,test2;




