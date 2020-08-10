drop table if exists tmp_null;

create table tmp_null (col1 int);
insert into tmp_null values(null);

select count(col1) from tmp_null;
select COUNT(CASE WHEN col1 = 0 THEN 1 END) as cnt from tmp_null;

select COUNT(null) as cnt from db_root;
select COUNT(CASE WHEN null = 0 THEN 1 END) as cnt from db_root;

drop table tmp_null;
