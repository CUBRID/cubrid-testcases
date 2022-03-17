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

select *
        from hash_test
        connect by id=parentid
        order by id;

select *
        from hash_test
        connect by id<>0
        order by id;

select *
        from hash_test
        connect by prior id<>0
        order by id;

select *
        from hash_test
        start with parentid<>0
        connect by prior id=parentid
        order by id;

select parentid,count(*) "count"
        from hash_test
        start with parentid is null
        connect by prior id=parentid
        order by parentid;

select parentid,count(*) "count"
        from hash_test
        connect by prior id<>0
        group by parentid
        order by parentid;

select parentid,count(*) "count"
        from hash_test
        connect by id=parentid
        group by parentid
        order by parentid;

drop table hash_test;

