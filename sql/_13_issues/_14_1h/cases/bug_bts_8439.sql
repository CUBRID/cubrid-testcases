drop table if exists aa;
create table aa(i int primary key, aa int);
insert into aa values(1,1);
insert into aa values(1,1) on duplicate key update aa=5;
drop table if exists aa;
