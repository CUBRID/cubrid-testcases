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
		where t1.text='AA';

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

drop table tree;

select case when (t4-t3+3)-(t2-t1)<0 then 'RUNS SLOWER' || (t4-t3) || ' ' || (t2-t1)
                   when (t4-t3)=0 then '1111111111111111111111111111111'
		else
			case ((t4-t3+3)-(t2-t1))*100/(t4-t3) 
				when 0 then '0000000000000000000000000000000'
				when 1 then '1000000000000000000000000000000'
				when 2 then '1100000000000000000000000000000'
				when 3 then '1110000000000000000000000000000'
				when 4 then '1111000000000000000000000000000'
				when 5 then '1111100000000000000000000000000'
				when 6 then '111110000000000000000000000000'
				when 7 then '1111111000000000000000000000000'
				when 8 then '1111111100000000000000000000000'
				when 9 then '1111111110000000000000000000000'
				when 10 then '1111111111000000000000000000000'
				when 11 then '1111111111100000000000000000000'
				when 12 then '1111111111110000000000000000000'
				when 13 then '1111111111111000000000000000000'
				when 14 then '1111111111111100000000000000000'
				when 15 then '1111111111111110000000000000000'
				when 16 then '1111111111111111000000000000000'
				when 17 then '1111111111111111100000000000000'
				when 18 then '1111111111111111110000000000000'
				when 19 then '1111111111111111111000000000000'
				when 20 then '1111111111111111111100000000000'
				when 21 then '1111111111111111111110000000000'
				when 22 then '1111111111111111111111000000000'
				when 23 then '1111111111111111111111100000000'
				when 24 then '1111111111111111111111110000000'
				when 25 then '1111111111111111111111111000000'
				when 26 then '1111111111111111111111111100000'
				when 27 then '1111111111111111111111111110000'
				when 28 then '1111111111111111111111111111000'
				when 29 then '1111111111111111111111111111100'
				when 30 then '1111111111111111111111111111110'
				else '1111111111111111111111111111111'
				end 
		end "performance"
	from res;

set system parameters 'compat_mode=mysql';
set system parameters 'ansi_quotes=yes';

select case when (t4-t3+3)-(t2-t1)<0 then concat('RUNS SLOWER', (t4-t3), ' ', (t2-t1))
                   when (t4-t3)=0 then '1111111111111111111111111111111'
		else
			case ((t4-t3+3)-(t2-t1))*100/(t4-t3) 
				when 0 then '0000000000000000000000000000000'
				when 1 then '1000000000000000000000000000000'
				when 2 then '1100000000000000000000000000000'
				when 3 then '1110000000000000000000000000000'
				when 4 then '1111000000000000000000000000000'
				when 5 then '1111100000000000000000000000000'
				when 6 then '111110000000000000000000000000'
				when 7 then '1111111000000000000000000000000'
				when 8 then '1111111100000000000000000000000'
				when 9 then '1111111110000000000000000000000'
				when 10 then '1111111111000000000000000000000'
				when 11 then '1111111111100000000000000000000'
				when 12 then '1111111111110000000000000000000'
				when 13 then '1111111111111000000000000000000'
				when 14 then '1111111111111100000000000000000'
				when 15 then '1111111111111110000000000000000'
				when 16 then '1111111111111111000000000000000'
				when 17 then '1111111111111111100000000000000'
				when 18 then '1111111111111111110000000000000'
				when 19 then '1111111111111111111000000000000'
				when 20 then '1111111111111111111100000000000'
				when 21 then '1111111111111111111110000000000'
				when 22 then '1111111111111111111111000000000'
				when 23 then '1111111111111111111111100000000'
				when 24 then '1111111111111111111111110000000'
				when 25 then '1111111111111111111111111000000'
				when 26 then '1111111111111111111111111100000'
				when 27 then '1111111111111111111111111110000'
				when 28 then '1111111111111111111111111111000'
				when 29 then '1111111111111111111111111111100'
				when 30 then '1111111111111111111111111111110'
				else '1111111111111111111111111111111'
				end 
		end "performance"
	from res;

set system parameters 'ansi_quotes=no';
set system parameters 'compat_mode=cubrid';




drop table res;
commit;
--+ holdcas off;
