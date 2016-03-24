create table tree(id int not null, parentid int, text varchar(32));

insert into tree values(1,null,'A');
insert into tree values(2,null,'B');
insert into tree values(3,1,'AA');
insert into tree values(4,1,'AB');
insert into tree values(5,2,'BA');
insert into tree values(6,2,'BB');
insert into tree values(7,3,'AAB');

create table tree0 like tree2;

create table tree2 like tree;

insert into tree2
	select *
		from tree
		order by id;
		
select *
	from tree2
	order by id,parentid,text;
	
create table tree3(id int,parentid int,text varchar(32)) as select * from tree;

select * 
	from tree3
	order by id,parentid,text ;
	
create table tree4(id1 int,parentid1 int,text1 varchar(32),id2 int,parentid2 int,text2 varchar(32)) as select t1.id as id1,t1.parentid as parentid1,t1.text as text1,t2.id as id2,t2.parentid as parentid2,t2.text as text2 from tree as t1 inner join tree t2 on t1.id=t2.id;

select *
	from tree4
	order by id1,2,3,4,5,6;
	
create table levelcount(lvl int) as select level as lvl,count(*) as cnt from tree start with parentid is null connect by parentid=prior id group by level;

select *
	from levelcount
	order by lvl;
	
create table tbl(id int);
insert into tbl values (1);
insert into tbl values (3);
insert into tbl values (2);
insert into tbl values (5);

create table source(id int,property char(20) default 'NONE');
insert into source values (1,'ONE');
insert into source values (3,'THREE');
insert into source values (2,'TWO');
insert into source values (5,'FIVE');


create table tbl1(name char(20) default 'abracadabra') partition by hash(id) partitions 4 as select * from tbl;
select * from tbl1 order by 1,2;


create table tbl2(name char(20) default 'abracadabra') partition by hash([id+2]) partitions 4 as select id+2 from tbl;
select * from tbl2 order by 1,2;



create table tbl3(name char(20) default 'abracadabra') partition by hash(id2) partitions 4 as select id+2 as id2 from tbl;
select * from tbl3 order by 1,2;


create table tbl4(name char(20) default 'abracadabra') partition by range(id) (partition p0 values less than (2), partition p1 values less than maxvalue) as select id from tbl;
select * from tbl4 order by  1,2;
select * from tbl4__p__p0 order by 1,2;
select * from tbl4__p__p1 order by 1,2;


create table tbl5(name char(20) default 'abracadabra') partition by LIST(id) (partition p0 values in (0,2,4,6), partition p1 values in (1,3,5,7) ) as select id from tbl;
select * from tbl5 order by 1,2;
select * from tbl5__p__p0 order by 1,2;
select * from tbl5__p__p1 order by 1,2;

create table src1(name char(20) default 'abracadabra') partition by range(property) (partition p0 values less than ('MMM'), partition p1 values less than maxvalue) as select * from source;
select * from src1 order by 1,2,3;
select * from src1__p__p0 order by 1,2,3;
select * from src1__p__p1 order by 1,2,3;


create table src2(name char(20) default 'abracadabra') partition by range(name) (partition p0 values less than ('abc'), partition p1 values less than maxvalue) as select * from source;
select * from src2 order by 1,2,3;
select * from src2__p__p0 order by 1,2,3;
select * from src2__p__p1 order by 1,2,3;
update src2 set name='cici' where id=1;
select * from src2 order by 1,2,3;
select * from src2__p__p0 order by 1,2,3;
select * from src2__p__p1 order by 1,2,3;


drop table tree;
drop table tree2;
drop table tree3;
drop table tree4;
drop table levelcount;
drop table tree0;

drop table tbl;
drop table tbl1;
drop table tbl2;
drop table tbl3;
drop table tbl4;
drop table tbl5;

drop table source;
drop table src1;
drop table src2;
