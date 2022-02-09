--test mixed logical operators with integer operands


select (1<>0 and 1<>0 and 1<>0);
select (1<>0 and 0<>0 or 1<>0 or 0<>0);
select (1<>0 and null<>0 or 0<>0);
select (0<>0 or 1<>0 and null<>0 or 1<>0 xor 0<>0);
select (0<>0 or 1<>0 and null<>0 or 1<>0 xor 1<>0);
select (1<>0 and not 1<>0 or not 0<>0 xor not 0<>0 xor 0<>0 xor not 1<>0); 
select (1<>0 and not 1<>0 or not 0<>0 xor not 0<>0 xor 0<>0 xor not 0<>0);
select (null<>0 or 1<>0 and (0<>0 or not 0<>0 xor 0<>0) and not 1<>0 or not (1<>0 xor 1<>0 xor 0<>0));
select (not 1<>0 xor not 0<>0 xor (1<>0 and 1<>0) xor (0<>0 or not 0<>0 and not 0<>0));
select (1<>0 and true or 0<>0 xor null<>0 or false and not null<>0 xor not 1<>0 or 0<>0);


select (3234<>0 and -3232<>0 or not 0<>0 xor -1848.2323<>0 xor not 123.12323432<>0 xor not 399020395792<>0);
select (-2312<>0 xor 8003<>0 or 234239<>0 or (1<>0 and null<>0 or null<>0) xor 23804<>0 and false or not true);


 
