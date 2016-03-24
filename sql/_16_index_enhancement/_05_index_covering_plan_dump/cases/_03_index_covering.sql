--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table d1(id int, text varchar(32));
create table d2(id int, text varchar(32));
create table d3(id int, text varchar(32));
create table tbl(id int, text varchar(32));
insert into tbl values(1,'AAABC');
insert into tbl values(2,'AABBC');
insert into tbl values(3,'ABABC');
insert into tbl values(3,'BABBC');
insert into tbl values(5,'AAABC');
insert into tbl values(6,'ABBBC');
insert into tbl values(7,'ACABC');
insert into tbl values(4,'CAABC');
insert into tbl values(7,'AACBC');
insert into tbl values(2,'AACCB');
create index idx_tbl1 on tbl(id, text);

create table tbl2(id int,prefix varchar(3));
insert into tbl2 select id,substring(text,1,3) from tbl;
create index idx_tbl2 on tbl2(id, prefix);

create table tbl3(id int,prefix varchar(2));
insert into tbl3 select id,substring(text,1,2) from tbl;
create index idx_tbl3 on tbl3(id, prefix);

select /*+ recompile */ t1.id, t2.id from tbl as t1, tbl2 as t2 where t1.id = t2.id and t1.id > 1
	and t1.text is not null and t2.prefix is not null;
select /*+ recompile */ t1.id, t2.id, t1.text from tbl as t1, tbl2 as t2 where t1.id = t2.id and t1.id > 1
	and t1.text is not null and t2.prefix is not null;
select /*+ recompile */ t1.id, t2.id, t2.prefix from tbl as t1, tbl2 as t2 where t1.id = t2.id and t1.id > 1
	and t1.text is not null and t2.prefix is not null order by t1.id, t2.id, t2.prefix;
select /*+ recompile */ t1.id, t2.id, t1.text, t2.prefix from tbl as t1, tbl2 as t2 where t1.id = t2.id and t1.id > 1
	and t1.text is not null and t2.prefix is not null order by t1.id, t2.id, t1.text, t2.prefix;

select /*+ recompile */ t1.id, t2.id, t3.id from tbl as t1, tbl2 as t2, tbl3 as t3 where t1.id = t2.id and t2.id = t3.id and t1.id > 1
	and t1.text is not null and t2.prefix is not null and t3.prefix is not null;
select /*+ recompile */ t1.id, t2.id, t3.prefix from tbl as t1, tbl2 as t2, tbl3 as t3 where t1.id = t2.id and t2.id = t3.id and t1.id > 1
	and t1.text is not null and t2.prefix is not null and t3.prefix is not null;

select /*+ recompile */ t1.id,t1.text from tbl as t1 right join tbl2 as t2 on t1.id = t2.id where t1.id > 1
	and t1.text is not null and t2.prefix is not null;
select /*+ recompile */ t1.id,t1.text from tbl as t1 left join tbl2 as t2 on t1.id = t2.id where t1.id > 1
	and t1.text is not null and t2.prefix is not null;
select /*+ recompile */ t1.id,t1.text from tbl as t1 join tbl2 as t2 on t1.id = t2.id where t1.id > 1
	and t1.text is not null and t2.prefix is not null;

select /*+ recompile */ t1.id from tbl as t1, (select t2.id, (select t3.id from tbl3 as t3 where t3.id = t2.id) from tbl2 as t2 where  t2.id = 1) as t4
	where t1.id is not null order by t1.id;
select /*+ recompile */ t1.id, t1.text, (select t2.id from tbl2 as t2 where t1.id = t2.id) from tbl as t1  where t1.id = 1;
select /*+ recompile */ t1.id, t1.text from tbl as t1 where t1.id IN ( select t2.id from tbl2 as t2 where t1.id = t2.id)  and t1.id > 1;

drop table tbl2;
drop table tbl3;
drop table tbl;
drop table d1;
drop table d2;
drop table d3;
set  system parameters 'dont_reuse_heap_file=no';commit;
--+ holdcas off;
