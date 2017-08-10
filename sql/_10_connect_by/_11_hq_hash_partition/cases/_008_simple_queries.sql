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

create index hash_test_idx on hash_test(id,parentid);

select * from hash_test order by id;

select *
        from hash_test
        connect by prior id=parentid
        order by id;

select *
        from hash_test
        start with parentid is null
        connect by prior id=parentid 
        order by id;

select *
        from hash_test
        where text like '%A'
        start with parentid is null
        connect by prior id=parentid 
        order by id;

select parentid,count(*) "count"
        from hash_test
        start with parentid is null
        connect by prior id=parentid 
        group by parentid
        order by parentid;

select parentid,count(*) "count"
        from hash_test
        start with parentid is null
        connect by prior id=parentid 
        group by parentid
        having count(*)>1
        order by parentid;

select parentid,count(*) "count"
        from hash_test
        connect by prior id=parentid
        group by parentid
        order by parentid;

select parentid,count(*) "count"
        from hash_test
        connect by prior id=parentid
        group by parentid
        having count(*)>1
        order by parentid;

select *
        from hash_test
        start with text in ('BBA','BA','AA','AB')
        connect by prior parentid=id 
        order by id;

drop index hash_test_idx on hash_test;

drop table hash_test;
