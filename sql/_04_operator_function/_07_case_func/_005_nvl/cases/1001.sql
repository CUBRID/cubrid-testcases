--Test retrieve data using case function 

--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
set system parameters 'create_table_reuseoid=no';
create class tb ( id int);
insert into tb values(1);
select decode(1, 1, tb) from tb order by 1;
select decode(1, 1, class tb) from tb order by 1;
select case when 1=1 then _db_user end from _db_user order by 1;
select case 1 when 1 then _db_user end from _db_user order by 1;

select db_root to :x from db_root order by 1;

select nullif(null, _db_user) from _db_user order by 1;
select nullif(_db_user, null) from _db_user order by 1;
select nullif(null, :x) from _db_user order by 1;
select nullif(:x, null) from _db_user order by 1;
select nullif(_db_user, :x) from _db_user order by 1;
select nullif(:x, _db_user) from _db_user order by 1;

select coalesce(null, _db_user) from _db_user order by 1;
select coalesce(_db_user, null) from _db_user order by 1;
select coalesce(null, :x) from _db_user order by 1;
select coalesce(:x, null) from _db_user order by 1;
select coalesce(_db_user, :x) from _db_user order by 1;
select coalesce(:x, _db_user) from _db_user order by 1;

select nvl(null, _db_user) from _db_user order by 1;
select nvl(_db_user, null) from _db_user order by 1;
select nvl(null, :x) from _db_user order by 1;
select nvl(:x, null) from _db_user order by 1;
select nvl(_db_user, :x) from _db_user order by 1;
select nvl(:x, _db_user) from _db_user order by 1;

select nvl2(null, _db_user, :x) from _db_user order by 1;
select nvl2(null, :x, _db_user) from _db_user order by 1;
select nvl2(_db_user, _db_user, :x) from _db_user order by 1;
select nvl2(_db_user, :x, _db_user) from _db_user order by 1;
select nvl2(:x, _db_user, null) from _db_user order by 1;
select nvl2(:x, null, _db_user) from _db_user order by 1;

select nullif(null, tb) from tb order by 1;
select nullif(tb, null) from tb order by 1;
select nullif(null, (select tb from tb)) from tb order by 1;
select nullif((select tb from tb), null) from tb order by 1;
select nullif(tb, (select tb from tb)) from tb order by 1;
select nullif((select tb from tb), tb) from tb order by 1;

select coalesce(null, tb) from tb order by 1;
select coalesce(tb, null) from tb order by 1;
select coalesce(null, (select tb from tb)) from tb order by 1;
select coalesce((select tb from tb), null) from tb order by 1;
select coalesce(tb, (select tb from tb)) from tb order by 1;
select coalesce((select tb from tb), tb) from tb order by 1;

select nvl(null, tb) from tb order by 1;
select nvl(tb, null) from tb order by 1;
select nvl(null, (select tb from tb)) from tb order by 1;
select nvl((select tb from tb), null) from tb order by 1;
select nvl(tb, (select tb from tb)) from tb order by 1;
select nvl((select tb from tb), tb) from tb order by 1;

select nvl2(null, tb, (select tb from tb)) from tb order by 1;
select nvl2(null, (select tb from tb), tb) from tb order by 1;
select nvl2(tb, tb, (select tb from tb)) from tb order by 1;
select nvl2(tb, (select tb from tb), tb) from tb order by 1;
select nvl2((select tb from tb), tb, null) from tb order by 1;
select nvl2((select tb from tb), null, tb) from tb order by 1;

drop tb;
set system parameters 'dont_reuse_heap_file=no';
set system parameters 'create_table_reuseoid=yes';
--+ holdcas off;
