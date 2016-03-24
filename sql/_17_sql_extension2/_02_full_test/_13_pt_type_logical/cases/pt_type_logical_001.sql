--test logical operators with integer operands


--and(&&) operator
select (15 and 89);
select (23 and 0);
select (-67888 and null);
select (34.5677 and 1);
select (23 and 0.000);
select (-11 and 0.00001232);
select (10002929292 and 2342342.79238402384023);
select (456 and true);
select (-20302 and false);


--or(||) operator
select (15 or 89);
select (23 or 0);
select (-67888 or null);
select (34.5677 or 1);
select (-23 or 0.000);
select (11 or 0.00001232);
select (-10002929292 or 2342342.79238402384023);
select (456 or true);
select (20302 or false);


--xor operator
select (1 xor 1);
select (1 xor 0);
select (0 xor 0);
select (1 xor 1 xor 1);
select (0 xor 1 xor 1);
select (1 xor 0 xor 0);
select (1 xor 0 xor 1 xor 1);
select (null xor 1);
select (null xor 0);
select (12321 xor 9094230);
select (234 xor 234);
select (111 xor true);
select (-902 xor false);


--not(!) operator
select (not 1);
select (not 2394209384);
select (not 34.23423423);
select (not -1232);
select (not 0);
select (not null);
select (! 234);
select (! 0.000000);
