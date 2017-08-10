-- negetive cases
drop table if exists x;
create table x(a int, b int);

create index a_x_index on x(a desc);
create index b_x_index on x(b desc);

insert into x values(1,1);
insert into x values(2,1);
insert into x values(3,1);
insert into x values(4,1);
insert into x values(5,1);
insert into x values(6,1);
insert into x values(7,1);
insert into x values(8,1);
insert into x values(9,1);
insert into x values(10,1);
insert into x values(11,2);
insert into x values(12,2);
insert into x values(13,2);
insert into x values(14,2);
insert into x values(15,2);
insert into x values(16,2);
insert into x values(17,2);
insert into x values(18,2);

select median(1) from x order by 1;
select median(2) from x order by 1;
select median('2013-10-9') from x order by 1;  
select median('2013/10/9') from x order by 1;
select median('2013-10-9 15:26:30.123') from x order by 1;
select median('2013-10-9 15:26:30') from x order by 1;


select median() from x order by 1;
select median(NULL) from x order by 1;
select median(avg(a)) from x order by 1;

select median(select a from x) from x order by 1;

insert into x values(19,NULL);
insert into x values(NULL,3);
insert into x values(NULL,NULL);
select median(a) from x order by 1;
select median(a), median(b) from x order by 1,2; 

drop table if exists x;

-- custom variable
select median(1);
set @ma=1;
select @ma;
--CUBRIDSUS-11738
select median(@ma);

drop variable @ma;
