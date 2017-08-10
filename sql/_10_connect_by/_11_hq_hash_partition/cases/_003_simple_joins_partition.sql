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

create table hash_test2(id int,
                        parentid int, text varchar(32)
                        )
        PARTITION BY hash(id)
        PARTITIONS 4;

insert into hash_test2 values(1,1,'-A-');
insert into hash_test2 values(2,2,'-B-');
insert into hash_test2 values(3,3,'-AA-');
insert into hash_test2 values(4,4,'-AB-');
insert into hash_test2 values(5,5,'-BA-');
insert into hash_test2 values(6,6,'-BB-');
insert into hash_test2 values(7,7,'-BBA-');
insert into hash_test2 values(8,null,'-C-');



select t.id,t.text,t2.text,level
        from hash_test t
                inner join hash_test2 t2 on t.id=t2.id
        start with t.parentid is null
        connect by prior t.id=t.parentid
        order by t.id;

select t.id,t.text,t2.text,level
        from hash_test t
                left join hash_test2 t2 on t.id=t2.id
        start with t.parentid is null
        connect by prior t.id=t.parentid
        order by t.id;

select t.id,t.text,t2.text,level
        from hash_test t
                right join hash_test2 t2 on t.id=t2.id
        start with t.parentid is null
        connect by prior t.id=t.parentid
        order by t.id;

drop table hash_test;

drop table hash_test2;     
