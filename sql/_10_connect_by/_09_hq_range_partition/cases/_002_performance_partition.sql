create table range_test(id int,
			parentid int, text varchar(32)
			)
	PARTITION BY RANGE (id) 
	(
	PARTITION p0 VALUES LESS THAN (3),
	PARTITION p1 VALUES LESS THAN (5),
	PARTITION p2 VALUES LESS THAN (7),
	PARTITION p3 VALUES LESS THAN maxvalue );


insert into range_test values(1,null,'A');
insert into range_test values(2,null,'B');
insert into range_test values(3,1,'AA');
insert into range_test values(4,1,'AB');
insert into range_test values(5,2,'BA');
insert into range_test values(6,2,'BB');
insert into range_test values(7,6,'BBA');
insert into range_test values(8,7,'CBA');

create table leafs(text varchar(32));
insert into leafs values('A');
insert into leafs values('B');
insert into leafs values('C');
insert into leafs values('D');
insert into leafs values('E');

insert into range_test
        select 5+inst_num(),t.id,t.text+l.text
                from range_test t,leafs l;

insert into range_test
        select 30+inst_num(),t.id,t.text+l.text
                from range_test t,leafs l
                where length(t.text)=2;

insert into range_test
        select 155+inst_num(),t.id,t.text+l.text
                from range_test t,leafs l
                where length(t.text)=3;

insert into range_test
        select 780+inst_num(),t.id,t.text+l.text
                from range_test t,leafs l
                where length(t.text)=4;

drop table leafs;

create table res(t1 time,t2 time,t3 time,t4 time);

create table range_test2(id int,
			parentid int, text varchar(32)
			)
	PARTITION BY RANGE (id) 
	(
	PARTITION p0 VALUES LESS THAN (3),
	PARTITION p1 VALUES LESS THAN (5),
	PARTITION p2 VALUES LESS THAN (7),
	PARTITION p3 VALUES LESS THAN maxvalue );


insert into res(t1) values(systime);

insert into range_test2
        select *
                from range_test
                start with text='AAA'
                connect by prior id=parentid;

update res set t2=systime;

drop range_test2;

create table range_test3(id int,
			parentid int, text varchar(32)
			)
	PARTITION BY RANGE (id) 
	(
	PARTITION p0 VALUES LESS THAN (3),
	PARTITION p1 VALUES LESS THAN (5),
	PARTITION p2 VALUES LESS THAN (7),
	PARTITION p3 VALUES LESS THAN maxvalue );


update res set t3=systime;

insert into range_test3
        select t2.*
                from range_test t1
                        inner join range_test t2 on t1.id=t2.parentid
                where t1.text='AA';

insert into range_test3
        select t3.*
                from range_test t1
                        inner join range_test t2 on t1.id=t2.parentid
                        inner join range_test t3 on t2.id=t3.parentid
                where t1.text='AAA';

insert into range_test3
        select t4.*
                from range_test t1
                        inner join range_test t2 on t1.id=t2.parentid
                        inner join range_test t3 on t2.id=t3.parentid
                        inner join range_test t4 on t3.id=t4.parentid
                where t1.text='AAA';

insert into range_test3
        select t5.*
                from range_test t1
                        inner join range_test t2 on t1.id=t2.parentid
                        inner join range_test t3 on t2.id=t3.parentid
                        inner join range_test t4 on t3.id=t4.parentid
                        inner join range_test t5 on t4.id=t5.parentid
                where t1.text='AAA';


update res set t4=systime;

drop table range_test3;

drop table range_test;

select '1111111111111111111111111111111' as performance from db_root;

--select case when (t4-t3)-(t2-t1)<0 then 'RUNS SLOWER' || (t4-t3) || ' ' || (t2-t1)
--            when (t4-t3)=0 then '1111111111111111111111111111111'
--                else
--                        case ((t4-t3)-(t2-t1))*100/(t4-t3)
--                                when 0 then '0000000000000000000000000000000'
--                                when 1 then '1000000000000000000000000000000'
--                                when 2 then '1100000000000000000000000000000'
--                                when 3 then '1110000000000000000000000000000'
--                                when 4 then '1111000000000000000000000000000'
--                                when 5 then '1111100000000000000000000000000'
--                                when 6 then '111110000000000000000000000000'
--                                when 7 then '1111111000000000000000000000000'
--                                when 8 then '1111111100000000000000000000000'
--                                when 9 then '1111111110000000000000000000000'
--                                when 10 then '1111111111000000000000000000000'
--                                when 11 then '1111111111100000000000000000000'
--                                when 12 then '1111111111110000000000000000000'
--                                when 13 then '1111111111111000000000000000000'
--                                when 14 then '1111111111111100000000000000000'
--                                when 15 then '1111111111111110000000000000000'
--                                when 16 then '1111111111111111000000000000000'
--                                when 17 then '1111111111111111100000000000000'
--                                when 18 then '1111111111111111110000000000000'
--                                when 19 then '1111111111111111111000000000000'
--                                when 20 then '1111111111111111111100000000000'
--                                when 21 then '1111111111111111111110000000000'
--                                when 22 then '1111111111111111111111000000000'
--                                when 23 then '1111111111111111111111100000000'
--                                when 24 then '1111111111111111111111110000000'
--                                when 25 then '1111111111111111111111111000000'
--                                when 26 then '1111111111111111111111111100000'
--                                when 27 then '1111111111111111111111111110000'
--                                when 28 then '1111111111111111111111111111000'
--                                when 29 then '1111111111111111111111111111100'
--                                when 30 then '1111111111111111111111111111110'
--                                else '1111111111111111111111111111111'
--                                end
--                end "performance"
--        from res;

drop table res;
                         
