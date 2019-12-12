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

select id,parentid,text,connect_by_isleaf
        from list_test
        start with parentid is null
        connect by prior id=parentid
        order by id;

select id,parentid,text,connect_by_isleaf
        from list_test
        where connect_by_isleaf=1
        start with parentid is null
        connect by prior id=parentid
        order by id;

select id,parentid,text,connect_by_isleaf
        from list_test
        start with parentid is null
        connect by prior id=parentid
        order by connect_by_isleaf,id;

select connect_by_isleaf,count(*) "count"
        from list_test
        start with parentid is null
        connect by prior id=parentid
        group by connect_by_isleaf
        order by connect_by_isleaf;

select parentid,sum(connect_by_isleaf) "sum"
        from list_test
        start with parentid is null
        connect by prior id=parentid
        group by parentid
        having sum(connect_by_isleaf)>1;

drop table list_test;
