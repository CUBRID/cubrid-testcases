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

create table list_test2(id int,
                        parentid int, text varchar(32)
                        )
        PARTITION BY list(id)
        (
        PARTITION p0 VALUES IN (1,2),
        PARTITION p1 VALUES IN (3,4),
        PARTITION p2 VALUES IN (5,6),
        PARTITION p3 VALUES IN (7,8) );

insert into list_test2 values(1,1,'-A-');
insert into list_test2 values(2,2,'-B-');
insert into list_test2 values(3,3,'-AA-');
insert into list_test2 values(4,4,'-AB-');
insert into list_test2 values(5,5,'-BA-');
insert into list_test2 values(6,6,'-BB-');
insert into list_test2 values(7,7,'-BBA-');
insert into list_test2 values(8,null,'-C-');



select t.id,t.text,t2.text,level
        from list_test t
                inner join list_test2 t2 on t.id=t2.id
        start with t.parentid is null
        connect by prior t.id=t.parentid
        order by t.id;

select t.id,t.text,t2.text,level
        from list_test t
                left join list_test2 t2 on t.id=t2.id
        start with t.parentid is null
        connect by prior t.id=t.parentid
        order by t.id;

select t.id,t.text,t2.text,level
        from list_test t
                right join list_test2 t2 on t.id=t2.id
        start with t.parentid is null
        connect by prior t.id=t.parentid
        order by t.id;

drop table list_test;

drop table list_test2;     
