--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table tbl (c varchar (22) not null);
create index i_tbl_c  on tbl (c);
insert tbl values ('%');
insert tbl values ('%');
insert tbl values ('\\');
insert tbl values ('\\');

set system parameters 'compat_mode=mysql';
select * from tbl where c like '\\%' using index i_tbl_c keylimit 1,2;
select * from tbl where c like '\\%' escape '\\' using index i_tbl_c keylimit 1,2;

set system parameters 'compat_mode=cubrid';
select * from tbl where c like '\\%' using index i_tbl_c keylimit 1,2;
select * from tbl where c like '\\%' escape '\\' using index i_tbl_c keylimit 1,2;

set system parameters 'require_like_escape_character=yes';
select * from tbl where c like '\\%' using index i_tbl_c keylimit 1,2;
select * from tbl where c like '\\%' escape '\\' using index i_tbl_c keylimit 1,2;

set system parameters 'require_like_escape_character=no';
select * from tbl where c like '\\%' using index i_tbl_c keylimit 1,2;
select * from tbl where c like '\\%' escape '\\' using index i_tbl_c keylimit 1,2;

set system parameters 'no_backslash_escapes=yes';
select * from tbl where c like '\\%' using index i_tbl_c keylimit 1,2;
select * from tbl where c like '\\%' escape '\\' using index i_tbl_c keylimit 1,2;

set system parameters 'no_backslash_escapes=no';
select * from tbl where c like '\\%' using index i_tbl_c keylimit 1,2;
select * from tbl where c like '\\%' escape '\\' using index i_tbl_c keylimit 1,2;

set system parameters 'require_like_escape_character=yes';
set system parameters 'no_backslash_escapes=yes';
select * from tbl where c like '\\%' using index i_tbl_c keylimit 1,2;
select * from tbl where c like '\\%' escape '\\' using index i_tbl_c keylimit 1,2;

set system parameters 'require_like_escape_character=no';
set system parameters 'no_backslash_escapes=no';
select * from tbl where c like '\\%' using index i_tbl_c keylimit 1,2;
select * from tbl where c like '\\%' escape '\\' using index i_tbl_c keylimit 1,2;


set system parameters 'require_like_escape_character=no';
set system parameters 'no_backslash_escapes=yes';
select * from tbl where c like '\\%' using index i_tbl_c keylimit 1,2;
select * from tbl where c like '\\%' escape '\\' using index i_tbl_c keylimit 1,2;

set system parameters 'no_backslash_escapes=no';
set system parameters 'require_like_escape_character=yes';
select * from tbl where c like '\\%' using index i_tbl_c keylimit 1,2;
select * from tbl where c like '\\%' escape '\\' using index i_tbl_c keylimit 1,2;

set system parameters 'require_like_escape_character=no';
set system parameters 'no_backslash_escapes=y';
set system parameters 'compat_mode=cubrid';

drop table tbl;



set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
