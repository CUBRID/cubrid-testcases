create table foo (n int, n2 int, n3 int primary key, s string);

insert into foo values (0, 0, 0, 'abcdefghijklmnopqrstuvwxyz');
insert into foo select 0, n2+1, n3+1, s from foo;
insert into foo select 0, n2+2, n3+2, s from foo;
insert into foo select 0, n2+4, n3+4, s from foo;
insert into foo select 0, n2+8, n3+8, s from foo;
insert into foo select 0, n2+16, n3+16, s from foo;
insert into foo select 0, n2+32, n3+32, s from foo;
insert into foo select 0, n2+64, n3+64, s from foo;
insert into foo select 0, n2+128, n3+128, s from foo;
insert into foo select 0, n2+256, n3+256, s from foo;
insert into foo select 0, n2+512, n3+512, s from foo;

create index idx1 on foo (n, n2, n3);
update statistics on all classes;
--@queryplan
select /*+ RECOMPILE */ * from foo where n2 in (0, 1) order by 1,2;
--@queryplan
select /*+ RECOMPILE */ * from foo where n2 in (0, 1) using index idx1;
--@queryplan
select /*+ RECOMPILE NO_INDEX_SS */ * from foo where n2 in (0, 1) order by 1,2;
--@queryplan
select /*+ RECOMPILE INDEX_SS */ * from foo where n2 in (0, 1) using index idx1 order by 1,2; -- Q4: do index skip scan
--@queryplan
select /*+ RECOMPILE NO_INDEX_SS INDEX_SS */ * from foo where n2 in (0, 1) using index idx1 order by 1,2;
--@queryplan
select /*+ RECOMPILE INDEX_SS NO_INDEX_SS */ * from foo where n2 in (0, 1) using index idx1 order by 1,2;

--@queryplan
select /*+ RECOMPILE NO_INDEX_SS */ n,n2 from foo where n=0 and n2 in (0, 1) order by 1,2;

create view v1 as select /*+ RECOMPILE INDEX_SS */ * from foo where n2 in (0, 1) using index idx1;
--@queryplan
select /*+ recompile index_ss */ * from v1 order by 1,2;
--@queryplan
select /*+ recompile no_index_ss */ * from v1 order by 1,2;
drop view v1;

create view v1 as select /*+ RECOMPILE NO_INDEX_SS */ * from foo where n2 in (0, 1) using index idx1;
--@queryplan
select /*+ recompile index_ss */ * from v1 order by 1,2;
--@queryplan
select /*+ recompile no_index_ss */ * from v1 order by 1,2;
drop view v1;

create view v1 as select * from foo where n2 in (0, 1) using index idx1;
--@queryplan
select /*+ recompile index_ss */ * from v1 order by 1,2;
--@queryplan
select /*+ recompile no_index_ss */ * from v1 order by 1,2;
drop view v1;

$int,$0,$int,$1
select /*+ RECOMPILE INDEX_SS */ * from foo where n2 in (?+1,?+1) order by 1,2;

prepare stmt from 'select /*+ RECOMPILE INDEX_SS */ * from foo where n2 in (?+1,?+1) order by 1,2';
execute stmt using 0,1;
execute stmt using 1,2;
deallocate prepare stmt;

drop table foo;

