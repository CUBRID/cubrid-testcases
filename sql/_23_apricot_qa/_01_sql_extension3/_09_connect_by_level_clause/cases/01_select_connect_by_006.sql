select count(*), max(lv) from (select *,level lv from db_root connect by level < 4  order by 1) tt;

select count(*) from (select *,level from db_root connect by level < sqrt(4) order by 1) tt;

select count(*) from (select *,level from db_root connect by level < cos(4) order by 1) tt;

select count(*) from (select *,level from db_root connect by level < sin(4) order by 1) tt;


