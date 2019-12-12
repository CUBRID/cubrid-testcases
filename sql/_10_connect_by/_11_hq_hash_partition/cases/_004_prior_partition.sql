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



select id,parentid,text,prior id as "prior_id"
        from hash_test
        start with parentid is null
        connect by prior id=parentid
        order by id;

select id,parentid,text
        from hash_test
        where prior id is null
        start with parentid is null
        connect by prior id=parentid
        order by id;

select id,parentid,text
        from hash_test
        start with parentid is null
        connect by prior id=parentid
        order by prior id,id;

select id,parentid,text,prior length(text) as "prior_length"
        from hash_test
        start with parentid is null
        connect by prior id=parentid
        order by id;

select id,parentid,text,prior (id+1) as "prior_id"
        from hash_test
        start with parentid is null
        connect by prior id=parentid
        order by id;

select id,parentid,text,prior (id || ' ' || text) as "prior_expr"
        from hash_test
        start with parentid is null
        connect by prior id=parentid
        order by id;

set system parameters 'compat_mode=mysql';
set system parameters 'ansi_quotes=yes';

select id,parentid,text,prior (concat(id, ' ', text)) as "prior_expr"
        from hash_test
        start with parentid is null
        connect by prior id=parentid
        order by id;

set system parameters 'ansi_quotes=no';
set system parameters 'compat_mode=cubrid';

drop table hash_test;
commit;
--+ holdcas off;
