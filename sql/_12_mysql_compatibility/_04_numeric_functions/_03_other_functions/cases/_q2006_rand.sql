select STRCMP(to_char(rand(3)),to_char(rand(3.0))) ;
select STRCMP(to_char(rand(3.0)),to_char(rand(1|2))) ;
select rand(0) ;
select rand(-1) ;
select rand(1) ;
select rand(rand(1));
select rand(-2147483648);
select rand(rand(2147483647));