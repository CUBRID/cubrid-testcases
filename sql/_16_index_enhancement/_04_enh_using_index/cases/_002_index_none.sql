
create table tab1(id int, num int);
create table tab2(id int);
create table tab3(text varchar(80));

insert into tab1 values (0,0),(0,1),(0,2),(0,3),(0,4);
insert into tab1 values (1,0),(1,1),(1,2),(1,3),(1,4);
insert into tab1 values (2,0),(2,1),(2,2),(2,3),(2,4);
insert into tab1 values (3,0),(3,1),(3,2),(3,3),(3,4);
insert into tab1 values (4,0),(4,1),(4,2),(4,3),(4,4);
insert into tab1 values (5,0),(5,1),(5,2),(5,3),(5,4);
insert into tab2 values (0),(1),(2),(3),(4),(5),(6),(7);
insert into tab3 values ('abc'),('def'),('ghi'),('jkl'),('mno'),('pqr'),('stu'),('vwx'),('yz');

create index idx15 on tab1(id);
create index idx16 on tab1(id, num);
create index idx17 on tab2(id);
create index idx18 on tab3(text);

create table t1 (id1 int, id2 varchar(30), id3 int);
insert into t1 values (5,'mnpqrt',55);
insert into t1 values (10,'abcd',100);
insert into t1 values ( 11,'abmnp',111);
insert into t1 values ( 15,'mnpde',111);
insert into t1 values ( 5,'abcde',55);
insert into t1 values ( 10,'abc',100);
insert into t1 values ( 10,'abc',100);
insert into t1 values (11,'ab ',111);
insert into t1 values ( 10,'abc',100);
insert into t1 values (10,'bcd',100);
insert into t1 values (11,'abxyz',111);
insert into t1 values (5,'amnpqrt',55);
insert into t1 values (12,'abmnp',122);
insert into t1 values (18,'mnpd ',181);
insert into t1 values (8,'abcd',88);
insert into t1 values (20,'mnp',200);
insert into t1 values (21,'mn ',211);
insert into t1 values (13,'abmnp',133);

create index idx40 on t1 (id1, id2);
create index idx41 on t1 (id1, id3);
create index idx42 on t1 (id2, id3);
create index idx43 on t1 (id1, id2, id3);

create table t2 (id1 int, id2 varchar(30), id3 int);
insert into t2 values (5,'mnpqrt',55);
insert into t2 values (10,'abcd',100);
insert into t2 values ( 11,'abmnp',111);
insert into t2 values ( 15,'mnpde',111);
insert into t2 values ( 5,'abcde',55);
insert into t2 values ( 10,'abc',100);
insert into t2 values ( 10,'abc',100);
insert into t2 values (11,'ab ',111);
insert into t2 values ( 10,'abc',100);
insert into t2 values (10,'bcd',100);
insert into t2 values (11,'abxyz',111);
insert into t2 values (5,'amnpqrt',55);
insert into t2 values (12,'abmnp',122);
insert into t2 values (18,'mnpd ',181);
insert into t2 values (8,'abcd',88);
insert into t2 values (20,'mnp',200);
insert into t2 values (21,'mn ',211);
insert into t2 values (13,'abmnp',133);

create index idx65 on t2 (id1, id3); 
create index idx66 on t2 (id1, id2);
create index idx67 on t2 (id1, id2, id3);
create index idx68 on t2 (id2); 

create table t3 (id1 int, id2 varchar(30), id3 int);
insert into t3 values (5,'mnpqrt',55);
insert into t3 values (10,'abcd',100);
insert into t3 values ( 11,'abmnp',111);
insert into t3 values ( 15,'mnpde',111);
insert into t3 values ( 5,'abcde',55);
insert into t3 values ( 10,'abc',100);
insert into t3 values ( 10,'abc',100);
insert into t3 values (11,'ab ',111);
insert into t3 values ( 10,'abc',100);
insert into t3 values (10,'bcd',100);
insert into t3 values (11,'abxyz',111);
insert into t3 values (5,'amnpqrt',55);
insert into t3 values (12,'abmnp',122);
insert into t3 values (18,'mnpd ',181);
insert into t3 values (8,'abcd',88);
insert into t3 values (20,'mnp',200);
insert into t3 values (21,'mn ',211);
insert into t3 values (13,'abmnp',133);

create index idx90 on t3 (id1, id3); 
create index idx91 on t3 (id1, id2);
create index idx92 on t3 (id1, id2, id3);

create table t4 (id1 int, id2 varchar(30), id3 int);
insert into t4 values (5,'mnpqrt',55);
insert into t4 values (10,'abcd',100);
insert into t4 values ( 11,'abmnp',111);
insert into t4 values ( 15,'mnpde',111);
insert into t4 values ( 5,'abcde',55);
insert into t4 values ( 10,'abc',100);
insert into t4 values ( 10,'abc',100);
insert into t4 values (11,'ab ',111);
insert into t4 values ( 10,'abc',100);
insert into t4 values (10,'bcd',100);
insert into t4 values (11,'abxyz',111);
insert into t4 values (5,'amnpqrt',55);
insert into t4 values (12,'abmnp',122);
insert into t4 values (18,'mnpd ',181);
insert into t4 values (8,'abcd',88);
insert into t4 values (20,'mnp',200);
insert into t4 values (21,'mn ',211);
insert into t4 values (13,'abmnp',133);

create index idx114 on t4 (id1, id3);
create index idx115 on t4(id3, id1);
create index idx116 on t4 (id1);
create index idx117 on t4 (id3);

select count(*) from tab1 a,tab1 b where a.id>0 and b.id>0 using index a.none;
select count(*) from tab1 a,tab1 b where a.id>0 and b.id>0 using index a.none, b.none;
select count(*) from tab1, tab2, tab3 where tab1.id>0 and tab2.id>0 and tab3.text>'abc' using index i_tab1_id_num, tab2.none, i_tab3_text;
select count(*) from tab1, tab2, tab3 where tab1.id>0 and tab2.id>0 and tab3.text>'abc' using index tab1.none, i_tab2_id, i_tab3_text;

select
	count(*)
	from
	t1,t2,t3,t4
	where
		t1.id1=18 and t2.id2='ab' and t3.id3=181 and t4.id1=21
	using index
		t1.none, i_t2_id2, t3.none, t4.none;

drop table tab1;
drop table tab2;
drop table tab3;
drop table t1;
drop table t2;
drop table t3;
drop table t4;
