--test arithmetic operations with the result of logical operations



select (not 3<>0) + 1;
select (290823<>0 and null<>0) - 234234;
select (3432<>0 xor -2934<>0 or not true and -1823.12312<>0 xor 30293242342<>0) * 234 + (3323<>0 or 9098<>0 xor 2343<>0);
--[er]
select 3480293 / (123<>0 xor true xor not 333<>0 xor 0<>0 xor not 1<>0 xor false);
select 234 % ((2321<>0 and 0<>0 or 3434<>0 xor 111<>0 xor -23423.2342<>0 xor not false xor 0<>0 xor 10<>0) + 13); 
select ((3+5<>0 and 9<>0) <> false);


--server side
create table aoo(col1 int, col2 int, col3 float, col4 double);

insert into aoo values(1232, -24343, 234.23423423, -46.142892347894239);

select ((not col1<>0 or col2<>0 xor false) + 3) * 333 from aoo;
select * from aoo where (col3<>0 xor col4<>0 and false or not 0<>0) < 2;
select ((not col4<>0) >= -4) from aoo;


drop table if exists aoo;



select (234209384023423842384.238942938479238749238492834792384<>0 and 0<>0 or false);
select (not (not (not (not (not (1<>0 and 23423<>0 xor 444<>0 or not 3<>0))))));
--[er]
select (0<>0 or 90340923<>0 and 0<>0 xor '12312'<>0);
