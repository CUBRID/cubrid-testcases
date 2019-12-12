create table dim(i int primary key);
create table fact(i int) partition by hash(i) partitions 4;
alter table fact add constraint foreign key fact(i) references dim(i);
insert into dim values(1);
insert into fact values(1);
select count(*) from fact;
select count(*) from fact where i=1;
drop fact,dim;

create table dim(i varchar(10) primary key);
create table fact(id int,i varchar(10)) partition by list(i) (
partition p0 values in ('a','bb'),
partition p1 values in ('bc'),
partition p2 values in ('de'));
alter table fact add constraint foreign key fact(i) references dim(i);
insert into dim values('bb'),('bc');
insert into fact values(1,'bb'),(2,'bc');
select count(*) from fact;
select count(*) from fact where i like '%b%';
alter table fact promote partition p1;
select count(*) from fact where i like '%b%';
drop fact,dim,fact__p__p1;

create table dim(i int primary key);
create table fact(id int,i int) partition by range(mod(i,9)) (
partition p0 values less than (3),
partition p1 values less than (6),
partition p2 values less than (9),
partition p3 values less than maxvalue);
alter table fact add constraint foreign key fact(i) references dim(i);
insert into dim values(4),(5),(6);
insert into fact values(1,4),(2,5);
select count(*) from fact;
select count(*) from fact where i=4;
select count(*) from fact where mod(i,9)=4;
select count(*) from fact where i is not null;
update fact set i=NULL where id=1;
select count(*) from fact where i is not null;
select count(*) from fact where i=4;
drop fact,dim;