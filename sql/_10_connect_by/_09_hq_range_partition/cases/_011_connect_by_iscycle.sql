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

select id,parentid,text,connect_by_iscycle
        from range_test
        start with text in ('A','B')
        connect by nocycle prior id=parentid
        order by id;

select id,parentid,text,connect_by_iscycle
        from range_test
        where connect_by_isleaf=1
        start with text in ('A','B')
        connect by nocycle prior id=parentid
        order by id;

select id,parentid,text,connect_by_iscycle
        from range_test
        start with text in ('A','B')
        connect by nocycle prior id=parentid
        order by connect_by_iscycle,id;

select connect_by_iscycle,count(*) "count"
        from range_test
        start with text in ('A','B')
        connect by nocycle prior id=parentid
        group by connect_by_iscycle
        order by connect_by_iscycle;

select parentid,sum(connect_by_iscycle) "sum"
        from range_test
        start with text in ('A','B')
        connect by nocycle prior id=parentid
        group by parentid
        having sum(connect_by_iscycle)>-1;

drop table range_test;

