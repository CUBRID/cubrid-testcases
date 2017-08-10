--test upper,lower function using select queries.
create class hanupper ( a varchar(50) );
insert into hanupper values('Hello ???');
insert into hanupper values('Hello world');
insert into hanupper values('hi~~ ???');
insert into hanupper values('????? ?? kcom');
insert into hanupper values('1234567890abcdefghijklmnopqrstuvwxyz');
insert into hanupper values('1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ');
insert into hanupper values('??????????????');
insert into hanupper values('!@#$%^&*()_+|');
insert into hanupper values('??????????????');
select * from hanupper order by 1;
select upper(a) from hanupper order by 1;
select lower(a) from hanupper order by 1;


drop class hanupper;
