drop table if exists x;
create table x(i int, a char(5), b varchar(5), c char(20), d string);
insert into x values (1, '1','2', '2013-10-1', '2013-10-1');
insert into x values (null, null, null, null, null);
insert into x values (2, '2','2', '2013-10-2', '2013-10-2');
insert into x values (5, '5','5', '2013-10-5', '2013-10-5');
insert into x values (10, '10','10', '2013-10-10', '2013-10-10');
insert into x values (null, null, null, null, null);
insert into x values (26, '26','26', '2013-10-26', '2013-10-26');

select median(i), median(a), median(b), median(c), median(c) from x;

insert into x values(7, '7','7', '2013-10-7', '2013-10-7');

select median(i), median(a), median(b), median(c), median(c) from x;

drop table if exists x;
