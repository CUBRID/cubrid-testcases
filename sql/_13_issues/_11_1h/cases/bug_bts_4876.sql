create table pk (a int, b int, primary key (a, b desc));
insert into pk values (1,1), (1,4), (1,2), (1,3), (1,5);
select * from pk where a = 1;
drop table pk;

create table pk (a int, b int);
alter table pk add primary key (a asc, b desc);
insert into pk values (1,1), (1,4), (1,2), (1,3), (1,5);
select * from pk where a = 1;

drop table pk;
