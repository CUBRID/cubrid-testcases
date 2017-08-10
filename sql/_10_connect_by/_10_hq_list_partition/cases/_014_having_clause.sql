create table list_test(id int,
                        parentid int, text varchar(32)
                        )
        PARTITION BY list(id)
        (
        PARTITION p0 VALUES IN (1,2),
        PARTITION p1 VALUES IN (3,4),
        PARTITION p2 VALUES IN (5,6),
        PARTITION p3 VALUES IN (7,8) );

insert into list_test values(1,null,'A');
insert into list_test values(2,null,'B');
insert into list_test values(3,1,'AA');
insert into list_test values(4,1,'AB');
insert into list_test values(5,2,'BA');
insert into list_test values(6,2,'BB');
insert into list_test values(7,6,'BBA');
insert into list_test values(8,7,'CBA');

select level,count(*) as "count"
        from list_test
        start with parentid is null
        connect by prior id=parentid
        group by level
        having level=2;

select connect_by_isleaf,count(*) as "count"
        from list_test
        start with parentid is null
        connect by prior id=parentid
        group by connect_by_isleaf
        having connect_by_isleaf=1;

update list_test set parentid=7 where id=2;

select connect_by_iscycle,count(*) as "count"
        from list_test
        start with text in ('A','B')
        connect by nocycle prior id=parentid
        group by connect_by_iscycle
        having connect_by_iscycle=1;

drop table list_test;


