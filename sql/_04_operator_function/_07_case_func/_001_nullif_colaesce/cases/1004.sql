--+ holdcas on;
--Test retrieve data using case function with rownum


select _db_user into :x from _db_user where rownum = 1 order by 1;
select db_class into :y from db_class where rownum = 1 order by 1;

select nullif(_db_user, :x), _db_user from _db_user order by 1;
select coalesce(_db_user, :x) from _db_user order by 1;
select nvl(_db_user, :x) from _db_user order by 1;
select nvl(:x, _db_user) from _db_user order by 1;
select nullif(_db_user, (select db_root from db_root)) from _db_user order by 1;
select nullif(_db_user, (select _db_user from _db_user where rownum = 1)) from _db_user order by 1;

--+ holdcas off;
