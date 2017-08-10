create table supt(i int);
create unique index idx on supt(mod(i,5));
create table subt under supt;
select * from supt where mod(i,5)=0;
select * from subt where mod(i,5)=0;
drop subt,supt;

create table supt(i int);
create index idx on supt(i);
create table subt under supt;
select * from supt where i = 0;
select * from subt where i = 0;
drop subt,supt;