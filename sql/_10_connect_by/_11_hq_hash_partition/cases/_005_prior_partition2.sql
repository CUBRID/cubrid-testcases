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


select id,parentid,text
        from hash_test
        start with text='A'
        connect by -parentid=prior (-id) or parentid=prior(-id)
        order by id;

select id,parentid,text
        from hash_test
        start with text='A'
        connect by -parentid=prior (-id) or prior(-id)=parentid
        order by id;

select id,parentid,text,level
        from hash_test
        start with text='A'
        connect by parentid=prior id and 9999>prior id
        order by id;

select id,parentid,text
        from hash_test
        where text<>'B' and length(text)=1
        start with text='A'
        connect by nocycle -parentid=prior (-id) or 9999>prior id
        order by id;

select id,parentid,text
        from hash_test
        start with text='A'
        connect by prior (-id)=-parentid
        order by id;

select id,parentid,text
        from hash_test
        start with text='A'
        connect by prior (-id)=999 or 999=prior(-id)
        order by id;

drop table hash_test;


