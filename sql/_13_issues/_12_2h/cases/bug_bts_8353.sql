drop table if exists f;
drop table if exists dp;

create table dp(i int primary key);
insert into dp select rownum from db_class limit 40;

create table f(i INTEGER , orderdatekey  INTEGER NOT NULL) partition by range(i) (partition p0 values less than (200),partition p1 values less than (400),partition p2 values less than(600),partition p3 values less than maxvalue);

alter table f add constraint foreign key f(i) references dp(i) on delete cascade;
insert into f select rownum,rownum from db_class limit 40;

delete from dp where i=4;

drop table if exists f;
drop table if exists dp;
