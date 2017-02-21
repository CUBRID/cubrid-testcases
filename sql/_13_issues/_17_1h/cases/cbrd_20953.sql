-- [CBRD-20953] Bug in 'show create view' when the system parameter 'plus_as_concat=no'
-- The default value of 'plus_as_concat' is 'yes'.

set system parameters 'plus_as_concat=no';

SHOW CREATE VIEW db_index;

drop table if exists x;
create table x (a int primary key, b int);
create view v1 as select /*+ recompile NO_DESC_IDX */ * from x where a > 5 order by a desc;
SHOW CREATE VIEW v1;
drop table x;
drop view v1;


set system parameters 'plus_as_concat=yes';

SHOW CREATE VIEW db_index;

drop table if exists x;
create table x (a int primary key, b int);
create view v1 as select /*+ recompile NO_DESC_IDX */ * from x where a > 5 order by a desc;
SHOW CREATE VIEW v1;

drop table x;
drop view v1;

