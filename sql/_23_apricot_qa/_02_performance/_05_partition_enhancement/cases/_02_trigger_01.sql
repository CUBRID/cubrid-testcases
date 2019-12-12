drop table if exists f;
drop table if exists dp;
drop table if exists f__p__p2;

create table f(productkey int);
create table dp(productkey int);

alter table dp add constraint primary key dp(productkey);
alter table f add constraint foreign key f(productkey) references dp(productkey);
alter table f partition by range(productkey) (partition p0 values less than (10),partition p1 values less than (20),partition p2 values less than(30),partition p3 values less than maxvalue);
insert into dp select rownum from db_class limit 40;
insert into dp select rownum+40 from db_class limit 40;
insert into f select * from dp;

create trigger tr1
before update on f
execute reject;
alter table f promote partition p2;

alter trigger tr1 status inactive;
alter table f promote partition p2;
alter trigger tr1 status active;

update f set productkey=productkey+1 where productkey=10;
update f__p__p2 set productkey=productkey+1 where productkey=24;

drop f;
drop dp;
drop f__p__p2;
