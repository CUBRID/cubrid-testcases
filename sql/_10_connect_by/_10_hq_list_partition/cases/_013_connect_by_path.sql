--+ holdcas on;
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

select id,parentid,text,sys_connect_by_path(text,'/') as [path]
        from list_test
        start with parentid is null
        connect by prior id=parentid
        order by id;

select id,parentid,text,sys_connect_by_path(text,'/') as [path]
        from list_test
        where sys_connect_by_path(text,'/') LIKE '%A'
        start with parentid is null
        connect by prior id=parentid
        order by id;

select id,parentid,text,sys_connect_by_path(text,'/') as [path]
        from list_test
        start with parentid is null
        connect by prior id=parentid
        order by sys_connect_by_path(text,'/') desc,id;

select sys_connect_by_path(id,'\') as [path]
        from list_test
        start with parentid is null
        connect by prior id=parentid
        order by id;
set system parameters 'compat_mode=mysql';
select sys_connect_by_path(id,'\\') as [path]
        from list_test
        start with parentid is null
        connect by prior id=parentid
        order by id;
set system parameters 'compat_mode=cubrid';

select id, sys_connect_by_path(trim(text),'/') from list_test
start with parentid is null
connect by prior to_char(id)=to_char(parentid)
order by id;

drop table list_test;

commit;
--+ holdcas off;
