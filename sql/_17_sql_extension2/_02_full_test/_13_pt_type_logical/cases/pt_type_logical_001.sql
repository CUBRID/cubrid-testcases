--test logical operators with integer operands


--and(&&) operator
select (15<>0 and 89<>0);
select (23<>0 and 0<>0);
select (-67888<>0 and null<>0);
select (34.5677<>0 and 1<>0);
select (23<>0 and 0.000<>0);
select (-11<>0 and 0.00001232<>0);
select (10002929292<>0 and 2342342.79238402384023<>0);
select (456<>0 and true);
select (-20302<>0 and false);


--or(||) operator
select (15<>0 or 89<>0);
select (23<>0 or 0<>0);
select (-67888<>0 or null<>0);
select (34.5677<>0 or 1<>0);
select (-23<>0 or 0.000<>0);
select (11<>0 or 0.00001232<>0);
select (-10002929292<>0 or 2342342.79238402384023<>0);
select (456<>0 or true);
select (20302<>0 or false);


--xor operator
select (1<>0 xor 1<>0);
select (1<>0 xor 0<>0);
select (0<>0 xor 0<>0);
select (1<>0 xor 1<>0 xor 1<>0);
select (0<>0 xor 1<>0 xor 1<>0);
select (1<>0 xor 0<>0 xor 0<>0);
select (1<>0 xor 0<>0 xor 1<>0 xor 1<>0);
select (null<>0 xor 1<>0);
select (null<>0 xor 0<>0);
select (12321<>0 xor 9094230<>0);
select (234<>0 xor 234<>0);
select (111<>0 xor true);
select (-902<>0 xor false);


--not(!) operator
select (not 1<>0);
select (not 2394209384<>0);
select (not 34.23423423<>0);
select (not -1232<>0);
select (not 0<>0);
select (not null<>0);
select (! 234<>0);
select (! 0.000000<>0);
