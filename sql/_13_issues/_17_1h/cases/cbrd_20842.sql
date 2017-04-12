drop table if exists tree2;
create table tree2(id int not null,treeid int, age int, text varchar(32));

insert into tree2 values(3,1,0, 'BAA');

insert into tree2 values(8,null,0, 'C');

insert into tree2 values(5,2,0, 'CBA');

insert into tree2 values(2,null,null, 'A');

insert into tree2 values(1,null,0, null);

insert into tree2 values(4,1,0,'AB');

insert into tree2 values(7,6,0, 'CBBA');

insert into tree2 values(6,2,0, 'DBB');

create index idx1 on tree2(id);

create index idx2 on tree2(id, treeid);

create index idx3 on tree2(treeid);

create index idx4 on tree2(treeid, id);

create index idx5 on tree2(text);

create index idx6 on tree2(id, text);

create index idx7 on tree2(id, treeid, text);

WITH cte_ZaMkLl AS
(
select -id as id2 from tree2 where text > 'A' group by treeid, id2 order by 1
)
select * from cte_ZaMkLl order by 1;

WITH cte_HbRjqa AS
(
select t.id, t.treeid, t.text from (select * from tree2 where treeid = 1 group by id, text) as t order by 1
)
select * from cte_HbRjqa order by 1;

WITH cte_XLVNN1 AS
(
select t.id, t.treeid, t.text from (select * from tree2 where id = 4 and text = 'AB' group by treeid) as t order by 1
)
select * from cte_XLVNN1;

drop table if exists tree2;

