
autocommit off;
create class foo (n int, n2 int, n3 int, s string);

insert into foo values (0, 0, 0, 'abcdefghijklmnopqrstuvwxyz');
insert into foo values (1, 1, 1, 'abcdefghijklmnopqrstuvwxyz');
insert into foo values (2, 2, 2, 'abcdefghijklmnopqrstuvwxyz');
insert into foo values (3, 3, 3, 'abcdefghijklmnopqrstuvwxyz');

insert into foo select n+4, n+4, n+4, s from foo;
insert into foo select n+8, n+8, n+8, s from foo;
insert into foo select n+16, n+16, n+16, s from foo;
insert into foo select n+32, n+32, n+32, s from foo;
insert into foo select n+64, n+64, n+64, s from foo;
insert into foo select n+128, n+128, n+128, s from foo;
insert into foo select n+256, n+256, n+256, s from foo;
insert into foo select n+512, n+512, n+512, s from foo;

update foo set n = mod(n,10), n2 = mod(n2,1);
insert into foo select * from foo;

create index idx1 on foo(n, n2, n3);

--@queryplan
select /*+ RECOMPILE */ n, min(n2) from all foo where n2 = 0 group by n;
--@queryplan
select /*+ RECOMPILE */ n, min(n2) from all foo where n2 = 0 group by n using index idx1;

--@queryplan
select /*+ RECOMPILE NO_INDEX_LS */ n, min(n2) from all foo where n2 = 0 group by n;
--@queryplan
select /*+ RECOMPILE INDEX_LS */ n, min(n2) from all foo where n2 = 0 group by n;
--@queryplan
select /*+ RECOMPILE NO_INDEX_LS INDEX_LS */ n, min(n2) from all foo where n2 = 0 group by n;
--@queryplan
select /*+ RECOMPILE INDEX_LS NO_INDEX_LS */ n, min(n2) from all foo where n2 = 0 group by n;

create view v1 as select /*+ RECOMPILE INDEX_LS */ n, min(n2) min_n2 from all foo where n2 = 0 group by n;
--@queryplan
select /*+ recompile index_ls */ * from v1;
--@queryplan
select /*+ recompile no_index_ls */ * from v1;
drop view v1;

create view v1 as select /*+ RECOMPILE NO_INDEX_LS */ n, min(n2) min_n2 from all foo where n2 = 0 group by n;
--@queryplan
select /*+ recompile index_ls */ * from v1;
--@queryplan
select /*+ recompile no_index_ls */ * from v1;
drop view v1;

create view v1 as select n, min(n2) min_n2 from all foo where n2 = 0 group by n;
--@queryplan
select /*+ recompile index_ls */ * from v1;
--@queryplan
select /*+ recompile no_index_ls */ * from v1;
drop view v1;

$int,$0,$int,$1
select /*+ RECOMPILE INDEX_LS */ n, min(n2) from all foo where n2 between ? and ? group by n;

--@queryplan
prepare stmt from 'select /*+ RECOMPILE INDEX_LS */ n, min(n2) min_n2 from all foo where n2 between ? and ? group by n';
--@queryplan
execute stmt using 0,1;
--@queryplan
execute stmt using 1,2;
deallocate prepare stmt;


drop table foo;
autocommit on;