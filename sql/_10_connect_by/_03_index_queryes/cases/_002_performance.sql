--+ holdcas on;
create table tree(id int, parentid int, text varchar(32));

create table leafs(text varchar(32));

insert into leafs values('A');
insert into leafs values('B');
insert into leafs values('C');
insert into leafs values('D');
insert into leafs values('E');

insert into tree values(1,null,'A');
insert into tree values(2,null,'B');
insert into tree values(3,null,'C');
insert into tree values(4,null,'D');
insert into tree values(5,null,'E');

insert into tree
	select 5+inst_num(),t.id,t.text+l.text
		from tree t,leafs l;

insert into tree
	select 30+inst_num(),t.id,t.text+l.text
		from tree t,leafs l
		where length(t.text)=2;
	
insert into tree
	select 155+inst_num(),t.id,t.text+l.text
		from tree t,leafs l
		where length(t.text)=3;
		
insert into tree
	select 780+inst_num(),t.id,t.text+l.text
		from tree t,leafs l
		where length(t.text)=4;
		
drop table leafs;

select count(*) "count" from tree;

create index tree_idx on tree(id,parentid);

create table res(t1 time,t2 time,t3 time,t4 time);

create table tree2(id int,parentid int,text varchar(32));

insert into res(t1) values(systime);

insert into tree2
	select *
		from tree
		start with text='AAA'
		connect by prior id=parentid;
		
update res set t2=systime;

drop tree2;

create table tree3(id int,parentid int,text varchar(32));

update res set t3=systime;

insert into tree3
	select *
		from tree
		where text='AAA';

insert into tree3
	select t2.*
		from tree t1
			inner join tree t2 on t1.id=t2.parentid
		where t1.text='AAA';

insert into tree3
	select t3.*
		from tree t1
			inner join tree t2 on t1.id=t2.parentid
			inner join tree t3 on t2.id=t3.parentid
		where t1.text='AAA';

insert into tree3
	select t4.*
		from tree t1
			inner join tree t2 on t1.id=t2.parentid
			inner join tree t3 on t2.id=t3.parentid
			inner join tree t4 on t3.id=t4.parentid
		where t1.text='AAA';

insert into tree3
	select t5.*
		from tree t1
			inner join tree t2 on t1.id=t2.parentid
			inner join tree t3 on t2.id=t3.parentid
			inner join tree t4 on t3.id=t4.parentid
			inner join tree t5 on t4.id=t5.parentid
		where t1.text='AAA';

update res set t4=systime;

drop table tree3;

drop index tree_idx on tree;

drop table tree;


drop table res;
commit;
--+ holdcas off;
