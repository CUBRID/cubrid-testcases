--+ holdcas on;

create table tbl_v (c varchar (22));

insert into tbl_v values (NULL);
insert into tbl_v values (NULL);
insert into tbl_v values ('');
insert into tbl_v values ('a');
insert into tbl_v values ('aa');
insert into tbl_v values ('aaa');
insert into tbl_v values ('aaaa');
insert into tbl_v values ('aaaaa');
insert into tbl_v values (' a');
insert into tbl_v values (' aa');
insert into tbl_v values (' aaa');
insert into tbl_v values (' aaaa');
insert into tbl_v values (' aaaaa');
insert into tbl_v values ('aabb');
insert into tbl_v values ('aabbx');
insert into tbl_v values ('c');
insert into tbl_v values ('ac');
insert into tbl_v values ('aac');
insert into tbl_v values ('aaac');
insert into tbl_v values ('aaaac');
insert into tbl_v values ('aaaaac');
insert into tbl_v values ('aabbc');
insert into tbl_v values ('aabbxc');
insert into tbl_v values ('x');
insert into tbl_v values ('xa');
insert into tbl_v values ('xx');
insert into tbl_v values ('xxa');
insert into tbl_v values ('xxx');
insert into tbl_v values ('xxxa');
insert into tbl_v values ('xxxx');
insert into tbl_v values ('_');
insert into tbl_v values ('__');
insert into tbl_v values ('___');
insert into tbl_v values ('____');
insert into tbl_v values ('%');
insert into tbl_v values ('%%');
insert into tbl_v values ('%%%');
insert into tbl_v values ('%%%%');
insert into tbl_v values ('%x');
insert into tbl_v values ('%%x');
insert into tbl_v values ('%%%x');
insert into tbl_v values ('%%%%x');
insert into tbl_v values ('_%');
insert into tbl_v values ('%_');
insert into tbl_v values ('%_%');
insert into tbl_v values ('_%_');
insert into tbl_v values ('__%__');
insert into tbl_v values ('%_%_%');
insert into tbl_v values ('%%_%%');
insert into tbl_v values ('%__%');
insert into tbl_v values ('_%%_');

create index i_tbl_v_c on tbl_v (c);

create table tbl_c (c char (10));
insert into tbl_c select * from tbl_v;
create index i_tbl_c_c on tbl_c (c);

set system parameters 'no_backslash_escapes = false';

set system parameters 'require_like_escape_character = true';
select * from tbl_v where c like NULL order by 1;
select * from tbl_c where c like NULL order by 1;
set system parameters 'require_like_escape_character = false';
select * from tbl_v where c like NULL order by 1;
select * from tbl_c where c like NULL order by 1;
set system parameters 'require_like_escape_character = true';
select * from tbl_v where c like NULL escape 'x' order by 1;
select * from tbl_c where c like NULL escape 'x' order by 1;
set system parameters 'require_like_escape_character = false';
select * from tbl_v where c like NULL escape 'x' order by 1;
select * from tbl_c where c like NULL escape 'x' order by 1;

select 'next' from db_root;

set system parameters 'require_like_escape_character = true';
select * from tbl_v where c like '' order by 1;
select * from tbl_c where c like '' order by 1;
set system parameters 'require_like_escape_character = false';
select * from tbl_v where c like '' order by 1;
select * from tbl_c where c like '' order by 1;
set system parameters 'require_like_escape_character = true';
select * from tbl_v where c like '' escape 'x' order by 1;
select * from tbl_c where c like '' escape 'x' order by 1;
set system parameters 'require_like_escape_character = false';
select * from tbl_v where c like '' escape 'x' order by 1;
select * from tbl_c where c like '' escape 'x' order by 1;

select 'next' from db_root;

set system parameters 'require_like_escape_character = true';
select * from tbl_v where c like '%' order by 1;
select * from tbl_c where c like '%' order by 1;
set system parameters 'require_like_escape_character = false';
select * from tbl_v where c like '%' order by 1;
select * from tbl_c where c like '%' order by 1;
set system parameters 'require_like_escape_character = true';
select * from tbl_v where c like '%' escape 'x' order by 1;
select * from tbl_c where c like '%' escape 'x' order by 1;
set system parameters 'require_like_escape_character = false';
select * from tbl_v where c like '%' escape 'x' order by 1;
select * from tbl_c where c like '%' escape 'x' order by 1;

select 'next' from db_root;

set system parameters 'require_like_escape_character = true';
select * from tbl_v where c like '_' order by 1;
select * from tbl_c where c like '_' order by 1;
set system parameters 'require_like_escape_character = false';
select * from tbl_v where c like '_' order by 1;
select * from tbl_c where c like '_' order by 1;
set system parameters 'require_like_escape_character = true';
select * from tbl_v where c like '_' escape 'x' order by 1;
select * from tbl_c where c like '_' escape 'x' order by 1;
set system parameters 'require_like_escape_character = false';
select * from tbl_v where c like '_' escape 'x' order by 1;
select * from tbl_c where c like '_' escape 'x' order by 1;

select 'next' from db_root;

set system parameters 'require_like_escape_character = true';
select * from tbl_v where c like '\%' order by 1;
select * from tbl_c where c like '\%' order by 1;
set system parameters 'require_like_escape_character = false';
select * from tbl_v where c like '\%' order by 1;
select * from tbl_c where c like '\%' order by 1;
set system parameters 'require_like_escape_character = true';
select * from tbl_v where c like 'x%' escape 'x' order by 1;
select * from tbl_c where c like 'x%' escape 'x' order by 1;
set system parameters 'require_like_escape_character = false';
select * from tbl_v where c like 'x%' escape 'x' order by 1;
select * from tbl_c where c like 'x%' escape 'x' order by 1;

select 'next' from db_root;

set system parameters 'require_like_escape_character = true';
select * from tbl_v where c like '\_' order by 1;
select * from tbl_c where c like '\_' order by 1;
set system parameters 'require_like_escape_character = false';
select * from tbl_v where c like '\_' order by 1;
select * from tbl_c where c like '\_' order by 1;
set system parameters 'require_like_escape_character = true';
select * from tbl_v where c like 'x_' escape 'x' order by 1;
select * from tbl_c where c like 'x_' escape 'x' order by 1;
set system parameters 'require_like_escape_character = false';
select * from tbl_v where c like 'x_' escape 'x' order by 1;
select * from tbl_c where c like 'x_' escape 'x' order by 1;

select 'next' from db_root;

set system parameters 'require_like_escape_character = true';
select * from tbl_v where c like 'aa%bz' order by 1;
select * from tbl_c where c like 'aa%bz' order by 1;
set system parameters 'require_like_escape_character = false';
select * from tbl_v where c like 'aa%bz' order by 1;
select * from tbl_c where c like 'aa%bz' order by 1;
set system parameters 'require_like_escape_character = true';
select * from tbl_v where c like 'aa%bz' escape 'x' order by 1;
select * from tbl_c where c like 'aa%bz' escape 'x' order by 1;
set system parameters 'require_like_escape_character = false';
select * from tbl_v where c like 'aa%bz' escape 'x' order by 1;
select * from tbl_c where c like 'aa%bz' escape 'x' order by 1;

select 'next' from db_root;

set system parameters 'require_like_escape_character = true';
select * from tbl_v where c like 'aa%' order by 1;
select * from tbl_c where c like 'aa%' order by 1;
set system parameters 'require_like_escape_character = false';
select * from tbl_v where c like 'aa%' order by 1;
select * from tbl_c where c like 'aa%' order by 1;
set system parameters 'require_like_escape_character = true';
select * from tbl_v where c like 'aa%' escape 'x' order by 1;
select * from tbl_c where c like 'aa%' escape 'x' order by 1;
set system parameters 'require_like_escape_character = false';
select * from tbl_v where c like 'aa%' escape 'x' order by 1;
select * from tbl_c where c like 'aa%' escape 'x' order by 1;

select 'next' from db_root;

set system parameters 'require_like_escape_character = true';
select * from tbl_v where c like 'aa %' order by 1;
select * from tbl_c where c like 'aa %' order by 1;
set system parameters 'require_like_escape_character = false';
select * from tbl_v where c like 'aa %' order by 1;
select * from tbl_c where c like 'aa %' order by 1;
set system parameters 'require_like_escape_character = true';
select * from tbl_v where c like 'aa %' escape 'x' order by 1;
select * from tbl_c where c like 'aa %' escape 'x' order by 1;
set system parameters 'require_like_escape_character = false';
select * from tbl_v where c like 'aa %' escape 'x' order by 1;
select * from tbl_c where c like 'aa %' escape 'x' order by 1;

select 'next' from db_root;

set system parameters 'require_like_escape_character = true';
select * from tbl_v where c like 'aab%' order by 1;
select * from tbl_c where c like 'aab%' order by 1;
set system parameters 'require_like_escape_character = false';
select * from tbl_v where c like 'aab%' order by 1;
select * from tbl_c where c like 'aab%' order by 1;
set system parameters 'require_like_escape_character = true';
select * from tbl_v where c like 'aab%' escape 'x' order by 1;
select * from tbl_c where c like 'aab%' escape 'x' order by 1;
set system parameters 'require_like_escape_character = false';
select * from tbl_v where c like 'aab%' escape 'x' order by 1;
select * from tbl_c where c like 'aab%' escape 'x' order by 1;

select 'next' from db_root;

set system parameters 'require_like_escape_character = true';
set system parameters 'no_backslash_escapes = false';
select * from tbl_v where c like '\%x' order by 1;
select * from tbl_v where c like '\%%x' order by 1;
select * from tbl_v where c like '%%\%x' order by 1;
select * from tbl_v where c like '%%\%%x' order by 1;
select * from tbl_v where c like '%%\%%%x' order by 1;
select * from tbl_v where c like '%%%%x' order by 1;

set system parameters 'no_backslash_escapes = true';
select * from tbl_v where c like '\%x' escape '\' order by 1;
select * from tbl_v where c like '\%%x' escape '\' order by 1;
select * from tbl_v where c like '%%\%x' escape '\' order by 1;
select * from tbl_v where c like '%%\%%x' escape '\' order by 1;
select * from tbl_v where c like '%%\%%%x' escape '\' order by 1;
select * from tbl_v where c like '%%%%x' escape '\' order by 1;

set system parameters 'require_like_escape_character = false';
set system parameters 'no_backslash_escapes = false';
select * from tbl_v where c like '\%x' order by 1;
select * from tbl_v where c like '\%%x' order by 1;
select * from tbl_v where c like '%%\%x' order by 1;
select * from tbl_v where c like '%%\%%x' order by 1;
select * from tbl_v where c like '%%\%%%x' order by 1;
select * from tbl_v where c like '%%%%x' order by 1;

set system parameters 'no_backslash_escapes = true';
select * from tbl_v where c like '\%x' escape '\' order by 1;
select * from tbl_v where c like '\%%x' escape '\' order by 1;
select * from tbl_v where c like '%%\%x' escape '\' order by 1;
select * from tbl_v where c like '%%\%%x' escape '\' order by 1;
select * from tbl_v where c like '%%\%%%x' escape '\' order by 1;
select * from tbl_v where c like '%%%%x' escape '\' order by 1;

select 'next' from db_root;

set system parameters 'no_backslash_escapes = false';
set system parameters 'require_like_escape_character = true';

select * from tbl_v where c like '\%' order by 1;
select * from tbl_v where c like '\%\%' order by 1;
select * from tbl_v where c like '\%\%\%' order by 1;
select * from tbl_v where c like '\%\%\%\%' order by 1;
select * from tbl_v where c like '\%x' order by 1;
select * from tbl_v where c like '\%\%x' order by 1;
select * from tbl_v where c like '\%\%\%x' order by 1;
select * from tbl_v where c like '\%\%\%\%x' order by 1;
select * from tbl_v where c like '\_\%' order by 1;
select * from tbl_v where c like '\%\_' order by 1;
select * from tbl_v where c like '\%\_\%' order by 1;
select * from tbl_v where c like '\_\%\_' order by 1;
select * from tbl_v where c like '\_\_\%\_\_' order by 1;
select * from tbl_v where c like '\%\_\%\_\%' order by 1;
select * from tbl_v where c like '\%\%\_\%\%' order by 1;
select * from tbl_v where c like '\%\_\_\%' order by 1;
select * from tbl_v where c like '\_\%\%\_' order by 1;
set system parameters 'require_like_escape_character = false';

select 'next' from db_root;

select * from tbl_v where c like 'x' escape 'x' order by 1;
select * from tbl_v where c like 'xx' escape 'x' order by 1;
select * from tbl_v where c like 'xxx' escape 'x' order by 1;
select * from tbl_v where c like '%x' escape 'x' order by 1;
select * from tbl_v where c like '_x' escape 'x' order by 1;
select * from tbl_v where c like '%xx' escape 'x' order by 1;
select * from tbl_v where c like '%xxx' escape 'x' order by 1;

drop table tbl_c;
drop table tbl_v;

set system parameters 'require_like_escape_character = true';
set system parameters 'no_backslash_escapes = true';

create table tbl (c varchar (22) not null);
create index i_tbl_c  on tbl (c);

insert into tbl values ('%');
insert into tbl values ('\');

set system parameters 'no_backslash_escapes = false';
select * from tbl where c like '\%' order by 1;

set system parameters 'no_backslash_escapes = true';
select * from tbl where c like '\%' escape '\' order by 1;

drop table tbl;

set system parameters 'require_like_escape_character = false';
set system parameters 'no_backslash_escapes = true';

create table tbl (c varchar (22) not null);
create index i_tbl_c  on tbl (c);

insert into tbl values ('%');
insert into tbl values ('\');

set system parameters 'no_backslash_escapes = false';
select * from tbl where c like '\%' order by 1;

set system parameters 'no_backslash_escapes = true';
select * from tbl where c like '\%' escape '\' order by 1;

drop table tbl;

set system parameters 'require_like_escape_character = false';
set system parameters 'no_backslash_escapes = true';
commit;
--+ holdcas off;
