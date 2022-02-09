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

select *
        from list_test
        connect by id=parentid
        order by id;

select *
        from list_test
        connect by id<>0
        order by id;

select *
        from list_test
        connect by prior id<>0
        order by id;

select *
        from list_test
        start with parentid<>0
        connect by prior id=parentid
        order by id;

select parentid,count(*) "count"
        from list_test
        start with parentid is null
        connect by prior id=parentid
        order by parentid;

select parentid,count(*) "count"
        from list_test
        connect by prior id<>0
        group by parentid
        order by parentid;

select parentid,count(*) "count"
        from list_test
        connect by id=parentid
        group by parentid
        order by parentid;

drop table list_test;

