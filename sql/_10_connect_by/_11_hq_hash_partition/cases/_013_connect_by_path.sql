--+ holdcas on;
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

select id,parentid,text,sys_connect_by_path(text,'/') as [path]
        from hash_test
        start with parentid is null
        connect by prior id=parentid
        order by id;

select id,parentid,text,sys_connect_by_path(text,'/') as [path]
        from hash_test
        where sys_connect_by_path(text,'/') LIKE '%A'
        start with parentid is null
        connect by prior id=parentid
        order by id;

select id,parentid,text,sys_connect_by_path(text,'/') as [path]
        from hash_test
        start with parentid is null
        connect by prior id=parentid
        order by sys_connect_by_path(text,'/') desc,id;

select sys_connect_by_path(id,'\') as [path]
        from hash_test
        start with parentid is null
        connect by prior id=parentid
        order by id;
set system parameters 'compat_mode=mysql';

select sys_connect_by_path(id,'\\') as [path]
        from hash_test
        start with parentid is null
        connect by prior id=parentid
        order by id;
set system parameters 'compat_mode=cubrid';

select id, sys_connect_by_path(trim(text),'/') from hash_test
start with parentid is null
connect by prior to_char(id)=to_char(parentid)
order by id

drop table hash_test;

commit;
--+ holdcas off;
