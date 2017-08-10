drop table if exists tab1,tab2,tab3,t1,t2,t3,t4;
drop table if exists clents,firms,t6;
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

create index i_tab1_id on tab1(id);
create index i_tab1_id_num on tab1(id, num);
create index i_tab2_id on tab2(id);
create index i_tab3_text on tab3(text);

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

create index i_t1_id1_id2 on t1 (id1, id2);
create index i_t1_id1_id3 on t1 (id1, id3);
create index i_t1_id2_id3 on t1 (id2, id3);
create index i_t1_id1_id2_id3 on t1 (id1, id2, id3);


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
create index i_t2_id1_id3 on t2 (id1, id3); 
create index i_t2_id1_id2 on t2 (id1, id2);
create index i_t2_id1_id2_id3 on t2 (id1, id2, id3);
create index i_t2_id2 on t2 (id2); 

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
create index i_t3_id1_id3 on t3 (id1, id3); 
create index i_t3_id1_id2 on t3 (id1, id2);
create index i_t3_id1_id2_id3 on t3 (id1, id2, id3);

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

create index i_t4_id1_id3 on t4 (id1, id3);
create index i_t4_id3_id2 on t4(id3, id1);
create index i_t4_id1 on t4 (id1);
create index i_t4_id3 on t4 (id3);


create table clients (clno int, fname varchar(15), lname varchar(15), job varchar(15), account_balance decimal(7,2));
insert into clients values (10, 'sam','smith','auditor',5525.75);
insert into clients values (20,'james','jones','manager',8960.25);
insert into clients values (30,'john','lukas','auditor',8860.25);
insert into clients values (40,'jerry','smith','auditor',6880.5);

create index i_clients_clno_account_balance on clients (clno, account_balance);
create index i_clients_job_fname_lname on clients (job, fname, lname);
create index i_clients_clno_lname on clients (clno, lname);

create table firms (clno int, company varchar(15), city varchar(15));
insert into firms values (10,'abc_co','leduc');
insert into firms values (20,'def_ltd','nisku');
insert into firms values (20,'ghi_inc','nisku');
insert into firms values (40,'jkl_inc','leduc');
insert into firms values (30,'mno_inc','nisku');

create index i_firms_city_clno on firms (city,clno);
create index i_firms_city on firms (city);
create index i_firms_clno on firms (clno);
create index i_firms_city_clno_company on firms (city,clno,company);
create index i_firms_city_company on firms (city,company);
create index i_firms_company_city on firms (company, city);


create table t6 (id1 int, id2 varchar(30), id3 int);
insert into t6 values (5,'mnpqrt',55);
insert into t6 values (10,'abcd',100);
insert into t6 values ( 11,'abmnp',111);
insert into t6 values ( 15,'mnpde',111);
insert into t6 values ( 5,'abcde',55);
insert into t6 values ( 10,'abc',100);
insert into t6 values ( 10,'abc',100);
insert into t6 values (11,'ab ',111);
insert into t6 values ( 10,'abc',100);
insert into t6 values (10,'bcd',100);
insert into t6 values (11,'abxyz',111);
insert into t6 values (5,'amnpqrt',55);
insert into t6 values (12,'abmnp',122);
insert into t6 values (18,'mnpd ',181);
insert into t6 values (8,'abcd',88);
insert into t6 values (20,'mnp',200);
insert into t6 values (21,'mn ',211);
insert into t6 values (13,'abmnp',133);

create index i_t6_id2 on t6 (id2);
create index i_t6_id1_id3 on t6 (id1, id3);
create index i_t6_id2_id3 on t6 (id2, id3);
create index i_t6_id2_id1 on t6 (id2, id1);
create index i_t6_id1_id2_id3 on t6 (id1, id2, id3);

select * from tab1 a,tab1 b where a.id>0 and b.id=1 using index a.i_tab1_id_num keylimit 1 order by a.id, a.num, b.id, b.num;
select * from tab1, tab2, tab3 where tab1.id=1 and tab2.id=1 and tab3.text='abc' using index i_tab3_text keylimit 1 order by tab1.id, tab1.num, tab2.id;
select
	t1.id1, t2.id2, t3.id3, t4.id1, t6.id3, firms.clno, clients.lname
	from
	t1,t2,t3,t4,t6,firms,clients
	where
		t1.id1=1 and t2.id2='abc' and t3.id3=111 and t4.id1=10 and t6.id2='abc'
		and firms.company='ghi_inc' and clients.job='auditor'
	using index i_clients_job_fname_lname
	order by t1.id1, t2.id2, t3.id3, t4.id1, t6.id3, firms.clno, clients.lname;

drop table tab1;
drop table tab2;
drop table tab3;
drop table t1;
drop table t2;
drop table t3;
drop table t4;
drop table t6;
drop table clients;
drop table firms;
