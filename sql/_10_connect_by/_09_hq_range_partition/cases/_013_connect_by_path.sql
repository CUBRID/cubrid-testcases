--+ holdcas on;
create table range_test(id int,
			parentid int, text varchar(32)
			)
	PARTITION BY RANGE (id)
	(
	PARTITION p0 VALUES LESS THAN (3),
	PARTITION p1 VALUES LESS THAN (5),
	PARTITION p2 VALUES LESS THAN (7),
	PARTITION p3 VALUES LESS THAN maxvalue );


insert into range_test values(1,null,'A');
insert into range_test values(2,null,'B');
insert into range_test values(3,1,'AA');
insert into range_test values(4,1,'AB');
insert into range_test values(5,2,'BA');
insert into range_test values(6,2,'BB');
insert into range_test values(7,6,'BBA');
insert into range_test values(8,7,'CBA');

select id,parentid,text,sys_connect_by_path(text,'/') as [path]
        from range_test
        start with parentid is null
        connect by prior id=parentid
        order by id;

select id,parentid,text,sys_connect_by_path(text,'/') as [path]
        from range_test
        where sys_connect_by_path(text,'/') LIKE '%A'
        start with parentid is null
        connect by prior id=parentid
        order by id;

select id,parentid,text,sys_connect_by_path(text,'/') as [path]
        from range_test
        start with parentid is null
        connect by prior id=parentid
        order by sys_connect_by_path(text,'/') desc,id;

select sys_connect_by_path(id,'\') as [path]
        from range_test
        start with parentid is null
        connect by prior id=parentid
        order by id;
set system parameters 'compat_mode=mysql';
select sys_connect_by_path(id,'\\') as [path]
        from range_test
        start with parentid is null
        connect by prior id=parentid
        order by id;
set system parameters 'compat_mode=cubrid';

select id, sys_connect_by_path(trim(text),'/') from range_test
start with parentid is null
connect by prior to_char(id)=to_char(parentid)
order by id

drop table range_test;

commit;
--+ holdcas off;
