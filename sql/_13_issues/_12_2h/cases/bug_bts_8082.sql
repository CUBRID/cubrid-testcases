create table dp(i int primary key);
insert into dp select rownum from db_class limit 40;
create table f(i int not null,j int not null) partition by range(i) (partition p0 values less than (200),partition p1 values less than (400),
partition p2 values less than(600),partition p3 values less than maxvalue);
alter table f add constraint foreign key f(i) references dp(i);
insert into f select rownum,rownum from db_class limit 40;
select * from f order by i limit 10 offset 6;
drop f,dp;

create table dp(i int primary key);
insert into dp select rownum from db_class limit 40;
create table f(i int,j int) partition by range(i) (partition p0 values less than (20),partition p1 values less than (40),
partition p2 values less than(600),partition p3 values less than maxvalue);
alter table f add constraint foreign key f(i) references dp(i);
insert into f select rownum,rownum from db_class limit 40;
select * from f order by i desc limit 10 offset 6;
drop f,dp;

create table dp(v string primary key);
insert into dp select cast(rownum as varchar) from db_class limit 40;
create table f(v string not null,j int not null) partition by range(v) (partition p0 values less than ('20'),partition p1 values less than ('40'),
partition p2 values less than('60'),partition p3 values less than maxvalue);
alter table f add constraint foreign key f(v) references dp(v);
insert into f select cast(rownum as string),rownum from db_class limit 40;
select * from f order by v limit 10 offset 6;
drop f,dp;