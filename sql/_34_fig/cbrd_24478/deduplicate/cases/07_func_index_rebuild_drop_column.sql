set system parameters 'deduplicate_key_level=3';
set system parameters 'print_index_detail=y';

drop table if exists dk_tbl;
create table dk_tbl(pid int primary key, uid int unique key, s varchar, v1 int, v2 int);
insert into dk_tbl values(1, 1, 'AA', 10, 1000), (2, 2, 'AB', 20, 2000), (3, 3, 'AC', 30, 3000);
create index idx01 on dk_tbl(ln(v1));
create index idx02 on dk_tbl(v1, ln(v1));
create index idx03 on dk_tbl(ln(v1), v1);
create index idx04 on dk_tbl(v2, ln(v1));
create index idx05 on dk_tbl(ln(v1), v2);
create index idx06 on dk_tbl(left(s, 3));
create index idx07 on dk_tbl(left(s, v2));
create index idx08 on dk_tbl(s, left(s, 3));
create index idx09 on dk_tbl(left(s, 3), s);
create index idx10 on dk_tbl(s, left(s, v2));
create index idx11 on dk_tbl(left(s, v2), s);
create index idx12 on dk_tbl(v2, left(s, v2));
create index idx13 on dk_tbl(left(s, v2), v2);
create index idx14 on dk_tbl(uid, ln(v1));  -- uid
create index idx15 on dk_tbl(ln(v1), pid);  -- pid
create index idx16 on dk_tbl(ln(uid));      -- uid: unique, ln(uid) can not guarantee unique
delete from dk_tbl;
insert into dk_tbl values(1, 1, 'AA', 10, 1000), (2, 2, 'AB', 20, 2000), (3, 3, 'AC', 30, 3000);

-- level 0 (idx14, idx15) and others level 3
show create table dk_tbl;
select index_of.index_name, group_concat( trim(coalesce(func, key_attr_name)) ) idx_cols
from _db_index_key 
where index_of.class_of.class_name = 'dk_tbl' and index_of.index_name not in ('pk_dk_tbl_pid','u_dk_tbl_uid')
group by index_of.index_name 
order by index_of.index_name, key_order;

alter index idx01 on dk_tbl rebuild;
alter index idx02 on dk_tbl rebuild;
alter index idx03 on dk_tbl rebuild;
alter index idx04 on dk_tbl rebuild;
alter index idx05 on dk_tbl rebuild;
alter index idx06 on dk_tbl rebuild;
alter index idx07 on dk_tbl rebuild;
alter index idx08 on dk_tbl rebuild;
alter index idx09 on dk_tbl rebuild;
alter index idx10 on dk_tbl rebuild;
alter index idx11 on dk_tbl rebuild;
alter index idx12 on dk_tbl rebuild;
alter index idx13 on dk_tbl rebuild;
alter index idx14 on dk_tbl rebuild;
alter index idx15 on dk_tbl rebuild;
alter index idx16 on dk_tbl rebuild;

-- after rebuild check
show create table dk_tbl;
select index_of.index_name, group_concat( trim(coalesce(func, key_attr_name)) ) idx_cols
from _db_index_key 
where index_of.class_of.class_name = 'dk_tbl' and index_of.index_name not in ('pk_dk_tbl_pid','u_dk_tbl_uid')
group by index_of.index_name 
order by index_of.index_name, key_order;

-- after drop v1 column index included v1 column
alter table dk_tbl drop column v1;
select index_of.index_name, group_concat( trim(coalesce(func, key_attr_name)) ) idx_cols
from _db_index_key 
where index_of.class_of.class_name = 'dk_tbl' and index_of.index_name not in ('pk_dk_tbl_pid','u_dk_tbl_uid')
group by index_of.index_name 
order by index_of.index_name, key_order;

drop table if exists dk_tbl;
set system parameters 'deduplicate_key_level=-1';
set system parameters 'print_index_detail=n';
