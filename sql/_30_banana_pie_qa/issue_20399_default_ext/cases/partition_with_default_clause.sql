drop table if exists src4;
create table src4(name char(20) default to_char(SYS_DATE, 'DD.MM.YYYY')) partition by range(name) (partition p0 values less than ('abc'), partition p1 values less than maxvalue) ;
show create table src4;
insert into src4 default;
update src4 set name = default;

select (name regexp '^[0-9]{2}.[0-9]{2}.[0-9]{4}') as date_default_val from src4;

insert into src4 values ('abc');
select (name regexp '^[0-9]{2}.[0-9]{2}.[0-9]{4}') as date_default_val from src4__p__p0;
select * from src4__p__p1;
alter table src4 add column cc varchar(10) default to_char(sys_date, 'YYYY-MM-DD');
update src4 set cc = default;
alter src4 alter column cc  set default to_char(systime, 'HH:MI:SS AM');
update src4 set cc=default;
select (cc regexp '^[0-9]{4}-[0-9]{2}-[0-9]{2}$') as date_default_val from src4;
drop table if exists src4


