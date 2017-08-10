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

select level,count(*) as "count"
        from range_test
        start with parentid is null
        connect by prior id=parentid
        group by level
        having level=2;

select connect_by_isleaf,count(*) as "count"
        from range_test
        start with parentid is null
        connect by prior id=parentid
        group by connect_by_isleaf
        having connect_by_isleaf=1;

update range_test set parentid=7 where id=2;

select connect_by_iscycle,count(*) as "count"
        from range_test
        start with text in ('A','B')
        connect by nocycle prior id=parentid
        group by connect_by_iscycle
        having connect_by_iscycle=1;

drop table range_test;


