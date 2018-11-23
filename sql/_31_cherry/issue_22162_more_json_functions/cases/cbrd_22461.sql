-- a part of _13_issues/_14_1h/cases/bug_bts_12463.sql
drop table if exists aa;
drop table if exists bb;
drop table if exists cc;
create table aa(a int primary key, b int);
create table bb(a int primary key, b int);
create table cc(a int primary key, b int);
insert into aa values(1,1)
insert into aa select a+(select count(*) from aa), 1 from aa;
insert into aa select a+(select count(*) from aa), 1 from aa;
insert into aa select a+(select count(*) from aa), 1 from aa;
insert into aa select a+(select count(*) from aa), 1 from aa;
insert into aa select a+(select count(*) from aa), 1 from aa;
insert into aa select a+(select count(*) from aa), 1 from aa;
insert into aa select a+(select count(*) from aa), 1 from aa;
insert into aa select a+(select count(*) from aa), 1 from aa;
insert into aa select a+(select count(*) from aa), 1 from aa;
insert into bb select * from aa;
insert into cc select a, 1 from aa where a <= 5;
update statistics on all classes;
select /*+ recompile orderd */ bb.* from aa inner join bb on bb.a = aa.a inner join cc on cc.a = aa.a and cc.b=1 where bb.a in (1,2) order by bb.b,bb.a;
select /*+ recompile orderd */ bb.* from aa inner join bb on bb.a = aa.a and bb.a in (1,2) inner join cc on cc.a = aa.a and cc.b=1 order by bb.b,bb.a;
drop table if exists aa;
drop table if exists bb;
drop table if exists cc;

-- _31_cherry/issue_22162_more_json_functions/cases/json_table_create_table_as.sql
drop table if exists tt1, tt2;
create table tt1 as select jt.* from
json_table( '{"date1":"2018-10-18"}', '$' columns (
date1 varchar(50) path '$.date' DEFAULT  '1111-11-11'  ON ERROR default '1000-01-01'  ON EMPTY
)) as jt;
create table tt2 as select str_to_date(jt.date1, '%Y-%m-%d') as date2 from
json_table( '{"date1":"2018-10-18"}', '$'  columns (
date1 varchar(50) path '$.date1' DEFAULT  '1112-12-12'  ON ERROR default '2000-01-01'  ON EMPTY
)) as jt;

insert into tt1 values (select jt.* from json_table('{"date1":"2018-10-18"}', '$'
columns (date1 json path '$.date1' DEFAULT  '"2018-00-00"'  ON ERROR default '"2018-99-99"'  ON EMPTY
)) as jt );
insert into tt1 values (select jt.* from json_table('{"date1":"2018-10-18"}', '$'
columns (date1 varchar(50) path '$.date1' DEFAULT  '"2018-00-00"'  ON ERROR default '2018-99-99'  ON EMPTY
)) as jt );

select /*+ recompile orderd */ count(*) from tt1, tt2, json_table( '[{"date1":"2018-10-18"}, {"date1":"2018-10-17"}]', '$[*]'
columns ( date3 varchar(20) path '$.date1' )) as jt
where str_to_date(date3,'%Y-%m-%d') < date2 and str_to_date(date1,'%Y-%m-%d') = date2;


drop table if exists tt1, tt2;
