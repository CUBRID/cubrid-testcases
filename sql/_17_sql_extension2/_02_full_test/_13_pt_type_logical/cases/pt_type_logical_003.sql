--test mixed logical operators with integer operands


select (1 and 1 and 1);
select (1 and 0 or 1 or 0);
select (1 and null or 0);
select (0 or 1 and null or 1 xor 0);
select (0 or 1 and null or 1 xor 1);
select (1 and not 1 or not 0 xor not 0 xor 0 xor not 1); 
select (1 and not 1 or not 0 xor not 0 xor 0 xor not 0);
select (null or 1 and (0 or not 0 xor 0) and not 1 or not (1 xor 1 xor 0));
select (not 1 xor not 0 xor (1 and 1) xor (0 or not 0 and not 0));
select (1 and true or 0 xor null or false and not null xor not 1 or 0);


select (3234 and -3232 or not 0 xor -1848.2323 xor not 123.12323432 xor not 399020395792);
select (-2312 xor 8003 or 234239 or (1 and null or null) xor 23804 and false or not true);


 
