drop table if exists tmp;
create table tmp (col1 int);
insert into tmp value(1),(1),(2);
drop view if exists tmp_view;
create or replace view tmp_view as select * from (select 1 from tmp where col1 = 2);
select count(*) from tmp_view;

create or replace view tmp_view as select * from (select 1 from tmp where col1 in ('1','2'));
select count(*) from tmp_view;

drop table if exists tmp;
drop view if exists v1;
create table tmp (col1 int);
create or replace view v1 as select * from tmp;

INSERT INTO v1 SELECT * FROM v1 LIMIT 0;

drop table if exists tmp;
drop view if exists tmp_view;
drop view if exists v1;
