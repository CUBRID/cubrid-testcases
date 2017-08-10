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

select * 
        from hash_test 
        order by id;

select *
        from hash_test
        connect by prior id=parentid
        order siblings by id;

select *
        from hash_test
        start with parentid is null
        connect by prior id=parentid
        order siblings by id;

drop table hash_test;

