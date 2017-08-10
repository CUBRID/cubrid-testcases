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

select id,parentid,text
        from range_test
        where prior id=6 and prior id=6
        start with parentid is null
        connect by parentid=prior id
        order by id;

select id,parentid,text
        from range_test
        where prior id is null
        start with parentid is null
        connect by parentid=prior id
        order by id;

select id,parentid,text
        from range_test
        where prior id is null and prior id is not null
        start with parentid is null
        connect by parentid=prior id
        order by id;

select id,parentid,text
        from range_test
        where prior id>=2 and prior id<=6
        start with parentid is null
        connect by parentid=prior id
        order by id;

select id,parentid,text
        from range_test
        where prior text like 'A%'
        start with parentid is null
        connect by parentid=prior id
        order by id;

select id,parentid,text
        from range_test
        where (prior id>=2 and prior id<=6) and (prior id>=50 and prior id<=100)
        start with parentid is null
        connect by parentid=prior id
        order by id;

select id,parentid,text
        from range_test
        where prior id=1 and prior id<=20
        start with parentid is null
        connect by parentid=prior id
        order by id;

select id,parentid,text
        from range_test
        where prior id<=20 and prior id>=10 and prior id<=200 and prior id>=0
        start with parentid is null
        connect by parentid=prior id
        order by id;

select range_test.*,prior 1 as "col1"
        from range_test
        start with parentid is null
        connect by parentid=prior id
        order by id;

select range_test.*,prior id as "col1"
        from range_test;

drop table range_test;

