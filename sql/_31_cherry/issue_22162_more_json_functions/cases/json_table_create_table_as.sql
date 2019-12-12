-- CBRD-22405  memory leak
select jt.* from json_table( '{"date1":"2018-10-18"}', '$' columns (
    date1 varchar(50) path '$.date' default '"9999-99-99"'  ON EMPTY DEFAULT '"0000-00-00"' ON ERROR 
)) as jt;

-- CBRD-22406 expected to get "2018-99-99"
select jt.* from json_table( '{"date1":"2018-10-18"}', '$' columns (
    date1 varchar(50) path '$.date' default '"2018-99-99"'  ON EMPTY DEFAULT '"2018-00-00"' ON ERROR
)) as jt;

-- CBRD-23556 different order of "ON EMPTY" and "ON ERROR" clause.
select jt.* from json_table( '{"date1":"2018-10-18"}', '$' columns (
    date1 varchar(50) path '$.date' DEFAULT '"0000-00-00"' ON ERROR default '"9999-99-99"'  ON EMPTY
)) as jt;

select jt.* from json_table( '{"date1":"2018-10-18"}', '$' columns (
    date1 varchar(50) path '$.date' DEFAULT '"2018-00-00"' ON ERROR default '"2018-99-99"'  ON EMPTY
)) as jt;

--expect error
select jt.* from json_table( '{"date1":"2018-10-18"}', '$' columns (
    "date" datetime path '$.date' DEFAULT SYS_DATETIME ON ERROR
)) as jt;

drop table if exists tt1, tt2;

--CBRD-22412
create table tt1 as select jt.* from 
json_table( '{"date1":"2018-10-18"}', '$' columns (
    date1 varchar(50) path '$.date' default '1000-01-01' ON EMPTY DEFAULT  '1111-11-11' ON ERROR
)) as jt;

--expect error 
create table tt2 as select jt.* from 
json_table( '{"date1":"2018-10-18"}', '$'  columns (
    date1 date path '$.date' default '"2018-99-99"'  ON EMPTY DEFAULT  '"2018-00-00"'  ON ERROR
)) as jt;

--expect error
create table tt2 as select str_to_date(jt.date1, '%Y-%m-%d') from 
json_table( '{"date1":"2018-10-18"}', '$'  columns (
    date1 varchar(50) path '$.date' default '2018-99-99'  ON EMPTY DEFAULT '2018-00-00'  ON ERROR
)) as jt;

create table tt2 as select str_to_date(jt.date1, '%Y-%m-%d') as date2 from 
json_table( '{"date1":"2018-10-18"}', '$'  columns (
    date1 varchar(50) path '$.date1' default '2000-01-01'  ON EMPTY DEFAULT '1112-12-12' ON ERROR 
)) as jt;

insert into tt1 values (select jt.* from json_table('{"date1":"2018-10-18"}', '$'
    columns (date1 json path '$.date1' default '"2018-99-99"'  ON EMPTY DEFAULT  '"2018-00-00"'  ON ERROR
)) as jt );

insert into tt1 values (select jt.* from json_table('{"date1":"2018-10-18"}', '$'
    columns (date1 varchar(50) path '$.date1' default '2018-99-99'  ON EMPTY DEFAULT  '"2018-00-00"'  ON ERROR
)) as jt );

show create table tt1;
show create table tt2;
select * from tt1 order by 1;
select * from tt2;

select /*+ recompile ordered */ * from tt1, tt2, json_table( '[{"date1":"2018-10-18"}, {"date1":"2018-10-17"}]', '$[*]'
    columns ( date3 varchar(20) path '$.date1' )) as jt
where str_to_date(date3,'%Y-%m-%d') < date2 and str_to_date(date1,'%Y-%m-%d') = date2
order by 1,2,3;

select /*+ recompile ordered */ count(*) from tt1, tt2, json_table( '[{"date1":"2018-10-18"}, {"date1":"2018-10-17"}]', '$[*]' 
    columns ( date3 varchar(20) path '$.date1' )) as jt
where str_to_date(date3,'%Y-%m-%d') < date2 and str_to_date(date1,'%Y-%m-%d') = date2;

select /*+ recompile ordered */ count(1), date3 from tt1, tt2, json_table( '[{"date1":"2018-10-18"}, {"date1":"2018-10-17"}]', '$[*]'
    columns ( date3 varchar(20) path '$.date1' )) as jt
group by date3 order by 2;

drop table if exists tt1, tt2;

