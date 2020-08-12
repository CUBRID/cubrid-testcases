--Test retrieve data using case function 

--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
set system parameters 'create_table_reuseoid=no';
create class tb ( id int);
insert into tb values(1);
select decode(1, 1, tb) from tb order by 1;
select decode(1, 1, class tb) from tb order by 1;
select case when 1=1 then db_user end from db_user order by 1;
select case 1 when 1 then db_user end from db_user order by 1;

select db_root to :x from db_root order by 1;

select nullif(null, db_user) from db_user order by 1;
select nullif(db_user, null) from db_user order by 1;
select nullif(null, :x) from db_user order by 1;
select nullif(:x, null) from db_user order by 1;
select nullif(db_user, :x) from db_user order by 1;
select nullif(:x, db_user) from db_user order by 1;

select coalesce(null, db_user) from db_user order by 1;
select coalesce(db_user, null) from db_user order by 1;
select coalesce(null, :x) from db_user order by 1;
select coalesce(:x, null) from db_user order by 1;
select coalesce(db_user, :x) from db_user order by 1;
select coalesce(:x, db_user) from db_user order by 1;

select nvl(null, db_user) from db_user order by 1;
select nvl(db_user, null) from db_user order by 1;
select nvl(null, :x) from db_user order by 1;
select nvl(:x, null) from db_user order by 1;
select nvl(db_user, :x) from db_user order by 1;
select nvl(:x, db_user) from db_user order by 1;

select nvl2(null, db_user, :x) from db_user order by 1;
select nvl2(null, :x, db_user) from db_user order by 1;
select nvl2(db_user, db_user, :x) from db_user order by 1;
select nvl2(db_user, :x, db_user) from db_user order by 1;
select nvl2(:x, db_user, null) from db_user order by 1;
select nvl2(:x, null, db_user) from db_user order by 1;

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
