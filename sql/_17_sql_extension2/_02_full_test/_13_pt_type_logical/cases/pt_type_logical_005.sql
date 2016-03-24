--test arithmetic operations with the result of logical operations



select (not 3) + 1;
select (290823 and null) - 234234;
select (3432 xor -2934 or not true and -1823.12312 xor 30293242342) * 234 + (3323 or 9098 xor 2343);
--[er]
select 3480293 / (123 xor true xor not 333 xor 0 xor not 1 xor false);
select 234 % ((2321 and 0 or 3434 xor 111 xor -23423.2342 xor not false xor 0 xor 10) + 13); 
select ((3+5 and 9) <> false);


--server side
create table aoo(col1 int, col2 int, col3 float, col4 double);

insert into aoo values(1232, -24343, 234.23423423, -46.142892347894239);

select ((not col1 or col2 xor false) + 3) * 333 from aoo;
select * from aoo where (col3 xor col4 and false or not 0) < 2;
select ((not col4) >= -4) from aoo;


drop table if exists aoo;



select (234209384023423842384.238942938479238749238492834792384 and 0 or false);
select (not (not (not (not (not (1 and 23423 xor 444 or not 3))))));
--[er]
select (0 or 90340923 and 0 xor '12312');
