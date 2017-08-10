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



select id,parentid,text,prior id as "prior_id"
        from list_test
        start with parentid is null
        connect by prior id=parentid
        order by id;

select id,parentid,text
        from list_test
        where prior id is null
        start with parentid is null
        connect by prior id=parentid
        order by id;

select id,parentid,text
        from list_test
        start with parentid is null
        connect by prior id=parentid
        order by prior id,id;

select id,parentid,text,prior length(text) as "prior_length"
        from list_test
        start with parentid is null
        connect by prior id=parentid
        order by id;

select id,parentid,text,prior (id+1) as "prior_id"
        from list_test
        start with parentid is null
        connect by prior id=parentid
        order by id;

select id,parentid,text,prior (id || ' ' || text) as "prior_expr"
        from list_test
        start with parentid is null
        connect by prior id=parentid
        order by id;

set system parameters 'compat_mode=mysql';
set system parameters 'ansi_quotes=yes';

select id,parentid,text,prior (concat(id, ' ', text)) as "prior_expr"
        from list_test
        start with parentid is null
        connect by prior id=parentid
        order by id;

set system parameters 'ansi_quotes=no';
set system parameters 'compat_mode=cubrid';

drop table list_test;
commit;
--+ holdcas off;
