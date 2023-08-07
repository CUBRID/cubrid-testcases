-- This testcase verifies CBRD-24906, RND-1894 issue.
-- Query plan should be made as inner join not cross join.

drop table if exists tbl_a, tbl_b;

create table tbl_a (id int primary key, sn varchar(6));
insert into tbl_a values(1, 'words');

create table tbl_b (id int primary key, com varchar(6));
insert into tbl_b values(1, 'cubrid');
insert into tbl_b values(2, 'oracle');

update statistics on all classes with fullscan;

set trace on;

select /*+ RECOMPILE*/ *
from (
    select /*+ RECOMPILE*/ a.id,com
    from tbl_a a
    join tbl_b b on a.id = b.id
    where b.com = 'cubrid'
    union all
    select /*+ RECOMPILE*/ a.id,com
    from tbl_a a
    join tbl_b b on a.id = b.id
    where b.com = 'oracle'
) as t 
where t.com='tibero';
show trace;

select /*+ RECOMPILE*/ *
from (
    select /*+ RECOMPILE*/ a.id,com
    from tbl_a a
    join tbl_b b on a.id = b.id
    where b.com = 'cubrid'
    union all
    select /*+ RECOMPILE*/ a.id,com
    from tbl_a a
    join tbl_b b on a.id = b.id
    where b.com = 'oracle'
) as t 
where 1=1
and t.com='cubrid';
show trace;

drop table if exists tbl_a, tbl_b;
