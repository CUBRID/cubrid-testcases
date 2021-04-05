--Test retrieve data using case function 

--+ holdcas on;
create class dual ( id int);
insert into dual values(1);
select decode(1, 1, dual) from dual order by 1;
select decode(1, 1, class dual) from dual order by 1;
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

select nullif(null, dual) from dual order by 1;
select nullif(dual, null) from dual order by 1;
select nullif(null, (select dual from dual)) from dual order by 1;
select nullif((select dual from dual), null) from dual order by 1;
select nullif(dual, (select dual from dual)) from dual order by 1;
select nullif((select dual from dual), dual) from dual order by 1;

select coalesce(null, dual) from dual order by 1;
select coalesce(dual, null) from dual order by 1;
select coalesce(null, (select dual from dual)) from dual order by 1;
select coalesce((select dual from dual), null) from dual order by 1;
select coalesce(dual, (select dual from dual)) from dual order by 1;
select coalesce((select dual from dual), dual) from dual order by 1;

select nvl(null, dual) from dual order by 1;
select nvl(dual, null) from dual order by 1;
select nvl(null, (select dual from dual)) from dual order by 1;
select nvl((select dual from dual), null) from dual order by 1;
select nvl(dual, (select dual from dual)) from dual order by 1;
select nvl((select dual from dual), dual) from dual order by 1;

select nvl2(null, dual, (select dual from dual)) from dual order by 1;
select nvl2(null, (select dual from dual), dual) from dual order by 1;
select nvl2(dual, dual, (select dual from dual)) from dual order by 1;
select nvl2(dual, (select dual from dual), dual) from dual order by 1;
select nvl2((select dual from dual), dual, null) from dual order by 1;
select nvl2((select dual from dual), null, dual) from dual order by 1;

drop dual;
--+ holdcas off;
