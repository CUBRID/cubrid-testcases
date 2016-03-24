--Test retrieve data using case function with rownum


select db_user into :x from db_user where rownum = 1 order by 1;
select db_class into :y from db_class where rownum = 1 order by 1;

select nullif(db_user, :x), db_user from db_user order by 1;
select coalesce(db_user, :x) from db_user order by 1;
select nvl(db_user, :x) from db_user order by 1;
select nvl(:x, db_user) from db_user order by 1;
select nullif(db_user, (select db_root from db_root)) from db_user order by 1;
select nullif(db_user, (select db_user from db_user where rownum = 1)) from db_user order by 1;
