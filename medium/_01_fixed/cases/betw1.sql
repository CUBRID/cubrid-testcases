autocommit off;
create table phonex
(number int, name string, low int, high int);
insert into phonex values (2660000, 'Who', 0, 200);
select * from phonex where 2 between low and high;
rollback;
