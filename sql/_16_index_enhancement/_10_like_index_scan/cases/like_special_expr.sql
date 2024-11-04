set system parameters 'create_table_reuseoid=no';
--+ holdcas on;
create table tbl (c varchar (22) not null);
create index i_tbl_c   on tbl (c);
insert into tbl values ('a');
insert into tbl values ('aa');
insert into tbl values ('aaa');
insert into tbl values ('aaz');
insert into tbl values ('aaabb');
insert into tbl values ('abbb');
insert into tbl values ('bc');
insert into tbl values ('cb');
insert into tbl values ('cc');
insert into tbl values ('b');
insert into tbl values ('c');
insert into tbl values ('%%');
insert into tbl values ('%');
insert into tbl values ('_');
insert into tbl values ('__');
insert into tbl values ('_%');
insert into tbl values (' b');
insert into tbl values ('zzz');
insert into tbl values ('\');

create table reff (r tbl);
insert into reff select tbl from tbl;

set system parameters 'require_like_escape_character = true';

set system parameters 'no_backslash_escapes = true';

select * from tbl where c like '%' order by 1;

set system parameters 'require_like_escape_character = false';

set system parameters 'no_backslash_escapes = true';


prepare stmt from 'select * from tbl where c like ? order by 1'; execute stmt using '%';
$varchar, $%
select * from tbl where c like ? order by 1;
deallocate prepare stmt;

prepare stmt from 'select * from tbl where c like ? escape c order by 1'; execute stmt using '%';
$varchar, $%
select * from tbl where c like ? escape c order by 1;
deallocate prepare stmt;

prepare stmt from 'select r.c from reff where reff.r.c like ? order by 1'; execute stmt using '%';
$varchar, $%
select r.c from reff where reff.r.c like ? order by 1;
deallocate prepare stmt;

prepare stmt from 'select c from tbl where c like ? + c order by 1'; execute stmt using '%';
$varchar, $%
select c from tbl where c like ? + c order by 1;
deallocate prepare stmt;

prepare stmt from 'select c from tbl, reff where c like ? + r.c order by 1'; execute stmt using '%';
$varchar, $%
select c from tbl, reff where c like ? + r.c order by 1;
deallocate prepare stmt;

prepare stmt from 'select c from tbl where c like (select * from tbl where c = ''\'') + ? escape ? order by 1'; execute stmt using '%', '\';
$varchar, $%, $varchar, $\
select c from tbl where c like (select * from tbl where c = '\') + ? escape ? order by 1;

drop prepare stmt;
drop table reff;
drop table tbl;
commit;
--+ holdcas off;
set system parameters 'create_table_reuseoid=yes';
