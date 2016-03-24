autocommit off;
create class bound (max_short short,
		    min_short short,
		    max_int int,
		    min_int int,
                    max_flt float,
		    max_dbl double,
		    numval numeric(15,2));
insert into bound values (32767,
			 -32768,
			  2147483647,
			 -2147483648,
			  3.402823e+38,
			  1.797693e+308,
			  9999999999999.99);
update bound set max_short = max_short + 1;
update bound set max_short = max_short + cast(1 as short);
update bound set min_short = min_short - cast(1 as short);
update bound set max_int = max_int * 2;
update bound set min_int = min_int - max_short;
update bound set max_flt = max_flt / cast(.1 as float);
update bound set max_dbl = max_dbl * 10;
update bound set numval = 1000000000000000;
evaluate 999999999 * 3;
evaluate cast(1.0e+38 as float) * 4;
evaluate cast(32767 as short) * cast(2 as short);
evaluate cast(2147483647 as integer) + 1;
evaluate cast(32768 as short);
rollback;
rollback;
