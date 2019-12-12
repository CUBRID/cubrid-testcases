create table hash_test(id int,
                        parentid int, text varchar(32)
                        )
        PARTITION BY hash(id)
        PARTITIONS 4;

insert into hash_test values(1,null,'A');
insert into hash_test values(2,null,'B');
insert into hash_test values(3,1,'AA');
insert into hash_test values(4,1,'AB');
insert into hash_test values(5,2,'BA');
insert into hash_test values(6,2,'BB');
insert into hash_test values(7,6,'BBA');
insert into hash_test values(8,7,'CBA');

select id,parentid,text,connect_by_isleaf
        from hash_test
        start with parentid is null
        connect by prior id=parentid
        order by id;

select id,parentid,text,connect_by_isleaf
        from hash_test
        where connect_by_isleaf=1
        start with parentid is null
        connect by prior id=parentid
        order by id;

select id,parentid,text,connect_by_isleaf
        from hash_test
        start with parentid is null
        connect by prior id=parentid
        order by connect_by_isleaf,id;

select connect_by_isleaf,count(*) "count"
        from hash_test
        start with parentid is null
        connect by prior id=parentid
        group by connect_by_isleaf
        order by connect_by_isleaf;

select parentid,sum(connect_by_isleaf) "sum"
        from hash_test
        start with parentid is null
        connect by prior id=parentid
        group by parentid
        having sum(connect_by_isleaf)>1;

drop table hash_test;
