autocommit off;
create class qparith (dummy short,
		    max_short short,
		    min_short short,
		    max_int int,
		    min_int int,
                    max_flt float,
		    min_flt float,
		    max_dbl double,
		    min_dbl double,
		    numval numeric(15,2));
insert into qparith values (1, 
			  32767,
			 -32768,
			  2147483647,
			 -2147483648,
			  3.402823e+38,
			  1.175494e-38,
			  1.79769313e+308,
                          2.23507385e-308,
			  9999999999999.99);
evaluate TIME'12:00:01 am' into :TIME1;
evaluate TIMESTAMP'1/1/1970 09:00:01 am' into :TIMESTAMP1;
evaluate DATE'12/12/9999' into :DATE1;
evaluate cast(99999999999999999999999999999999999999 as numeric(38,0)) into :NUM;
update qparith set dummy = max_short + max_short;
update qparith set dummy = max_short + max_int;
update qparith set dummy = max_short + max_flt;
update qparith set dummy = max_short + max_dbl;
update qparith set dummy = max_short + :NUM;
update qparith set dummy = max_short + cast(max_dbl as monetary);
update qparith set dummy = max_short + :TIME1;
update qparith set dummy = max_short + :TIMESTAMPx;
update qparith set dummy = min_short + :TIMESTAMP1;
update qparith set dummy = max_short + :DATE1;
update qparith set dummy = min_short + :DATE1;
update qparith set dummy = cast(max_dbl as monetary) + max_short;
update qparith set dummy = :TIME1 + max_short;
update qparith set dummy = :TIMESTAMP1 + min_short;
update qparith set dummy = :DATE1 + max_short;
update qparith set dummy = :DATE1 + min_short;
update qparith set dummy = max_int + max_short;
update qparith set dummy = max_int + max_int;
update qparith set dummy = max_int + max_flt;
update qparith set dummy = max_int + max_dbl;
update qparith set dummy = max_int + :NUM;
update qparith set dummy = max_int + cast(max_dbl as monetary);
update qparith set dummy = max_int + :TIME1;
update qparith set dummy = min_int + :TIMESTAMP1;
update qparith set dummy = max_int + :DATE1;
update qparith set dummy = min_int + :DATE1;
update qparith set dummy = cast(max_dbl as monetary) + max_int;
update qparith set dummy = :TIME1 + max_int;
update qparith set dummy = :TIMESTAMPx + max_int;
update qparith set dummy = :TIMESTAMP1 + min_int;
update qparith set dummy = :DATE1 + max_int;
update qparith set dummy = :DATE1 + min_int;
update qparith set dummy = max_flt + max_short;
update qparith set dummy = max_flt + max_int;
update qparith set dummy = max_flt + max_flt;
update qparith set dummy = max_flt + max_dbl;
update qparith set dummy = max_flt + :NUM;
update qparith set dummy = max_flt + cast(max_dbl as monetary);
update qparith set dummy = cast(max_dbl as monetary) + max_flt;
update qparith set dummy = max_dbl + max_short;
update qparith set dummy = max_dbl + max_int;
update qparith set dummy = max_dbl + max_flt;
update qparith set dummy = max_dbl + max_dbl;
update qparith set dummy = max_dbl + :NUM;
update qparith set dummy = max_dbl + cast(max_dbl as monetary);
update qparith set dummy = cast(max_dbl as monetary) + max_dbl;
update qparith set dummy = cast(max_dbl as monetary) + cast(max_dbl as monetary);
update qparith set dummy = numval + max_short;
update qparith set dummy = numval + max_int;
update qparith set dummy = numval + max_flt;
update qparith set dummy = numval + max_dbl;
update qparith set dummy = numval + :NUM;
update qparith set dummy = numval + cast(max_dbl as monetary);
update qparith set dummy = cast(max_dbl as monetary) + numval;
update qparith set dummy = min_short - max_short;
update qparith set dummy = min_short - max_int;
update qparith set dummy = min_short - max_flt;
update qparith set dummy = min_short - max_dbl;
update qparith set dummy = min_short - :NUM;
update qparith set dummy = min_short - cast(max_dbl as monetary);
update qparith set dummy = min_short - :TIME1;
update qparith set dummy = min_short - :TIMESTAMPx;
update qparith set dummy = min_short - :DATE1;
update qparith set dummy = cast(max_dbl as monetary) - max_short;
update qparith set dummy = :TIME1 - min_short;
update qparith set dummy = :TIMESTAMP1 - max_short;
update qparith set dummy = :TIMESTAMPx - min_short;
update qparith set dummy = :DATE1 - max_short;
update qparith set dummy = :DATE1 - min_short;
update qparith set dummy = min_int - max_short;
update qparith set dummy = min_int - max_int;
update qparith set dummy = min_int - max_flt;
update qparith set dummy = min_int - max_dbl;
update qparith set dummy = min_int - :NUM;
update qparith set dummy = min_int - cast(max_dbl as monetary);
update qparith set dummy = min_int - :TIME1;
update qparith set dummy = min_int - :TIMESTAMPx;
update qparith set dummy = min_int - :DATE1;
update qparith set dummy = cast(max_dbl as monetary) - min_int;
update qparith set dummy = :TIME1 - min_int;
update qparith set dummy = :TIMESTAMP1 - max_int;
update qparith set dummy = :TIMESTAMPx - min_int;
update qparith set dummy = :DATE1 - max_int;
update qparith set dummy = :DATE1 - min_int;
update qparith set dummy = -(max_flt) - max_short;
update qparith set dummy = -(max_flt) - max_int;
update qparith set dummy = -(max_flt) - max_flt;
update qparith set dummy = -(max_flt) - max_dbl;
update qparith set dummy = -(max_flt) - :NUM;
update qparith set dummy = -(max_flt) - cast(max_dbl as monetary);
update qparith set dummy = cast(max_dbl as monetary) - max_flt;
update qparith set dummy = -(max_dbl) - max_short;
update qparith set dummy = -(max_dbl) - max_int;
update qparith set dummy = -(max_dbl) - max_flt;
update qparith set dummy = -(max_dbl) - max_dbl;
update qparith set dummy = -(max_dbl) - :NUM;
update qparith set dummy = -(max_dbl) - cast(max_dbl as monetary);
update qparith set dummy = cast(-(max_dbl) as monetary) - max_dbl;
update qparith set dummy = cast(-(max_dbl) as monetary) - cast(max_dbl as monetary);
update qparith set dummy = numval - max_short;
update qparith set dummy = numval - max_int;
update qparith set dummy = numval - max_flt;
update qparith set dummy = numval - max_dbl;
update qparith set dummy = numval - :NUM;
update qparith set dummy = numval - cast(max_dbl as monetary);
update qparith set dummy = cast(max_dbl as monetary) - numval;
update qparith set dummy = max_short * max_short;
update qparith set dummy = max_short * max_int;
update qparith set dummy = max_short * max_flt;
update qparith set dummy = max_short * max_dbl;
update qparith set dummy = max_short * :NUM;
update qparith set dummy = max_short * cast(max_dbl as monetary);
update qparith set dummy = cast(max_dbl as monetary) * max_short;
update qparith set dummy = max_int * max_short;
update qparith set dummy = max_int * max_int;
update qparith set dummy = max_int * max_flt;
update qparith set dummy = max_int * max_dbl;
update qparith set dummy = max_int * :NUM;
update qparith set dummy = max_int * cast(max_dbl as monetary);
update qparith set dummy = cast(max_dbl as monetary) * max_int;
update qparith set dummy = max_flt * max_short;
update qparith set dummy = max_flt * max_int;
update qparith set dummy = max_flt * max_flt;
update qparith set dummy = max_flt * max_dbl;
update qparith set dummy = max_flt * :NUM;
update qparith set dummy = max_flt * cast(max_dbl as monetary);
update qparith set dummy = cast(max_dbl as monetary) * max_flt;
update qparith set dummy = max_dbl * max_short;
update qparith set dummy = max_dbl * max_int;
update qparith set dummy = max_dbl * max_flt;
update qparith set dummy = max_dbl * max_dbl;
update qparith set dummy = max_dbl * :NUM;
update qparith set dummy = max_dbl * cast(max_dbl as monetary);
update qparith set dummy = cast(max_dbl as monetary) * max_dbl;
update qparith set dummy = cast(max_dbl as monetary) * cast(max_dbl as monetary);
update qparith set dummy = numval * max_short;
update qparith set dummy = numval * max_int;
update qparith set dummy = numval * max_flt;
update qparith set dummy = numval * max_dbl;
update qparith set dummy = numval * :NUM;
update qparith set dummy = numval * cast(max_dbl as monetary);
update qparith set dummy = cast(max_dbl as monetary) * numval;
update qparith set dummy = max_short / min_short;
update qparith set dummy = max_short / min_int;
update qparith set dummy = max_short / cast(.01 as float);
update qparith set dummy = max_short / cast(.01 as double);
update qparith set dummy = max_short / cast(.01 as numeric(3,2));
update qparith set dummy = max_short / cast(.01 as monetary);
update qparith set dummy = cast(min_dbl as monetary) / max_short; -- result is 0
update qparith set dummy = max_int / min_short;
update qparith set dummy = max_int / min_int;
update qparith set dummy = max_int / cast(.01 as float);
update qparith set dummy = max_int / cast(.01 as double);
update qparith set dummy = max_int / cast(.01 as numeric(3,2));
update qparith set dummy = max_int / cast(.01 as monetary);
update qparith set dummy = cast(min_dbl as monetary) / max_int;
update qparith set dummy = min_flt / max_short;
update qparith set dummy = min_flt / max_int;
update qparith set dummy = max_flt / cast(.01 as float);  -- an overflow!
update qparith set dummy = max_flt / cast(.01 as double);
update qparith set dummy = max_flt / cast(.01 as numeric(3,2));
update qparith set dummy = max_flt / cast(.01 as monetary);
update qparith set dummy = cast(max_dbl as monetary) / cast(.01 as float); -- another one!
update qparith set dummy = min_dbl / max_short;
update qparith set dummy = min_dbl / max_int;
update qparith set dummy = max_dbl / cast(.01 as float);
update qparith set dummy = max_dbl / cast(.01 as double);
update qparith set dummy = max_dbl / cast(.01 as numeric(3,2));
update qparith set dummy = max_dbl / cast(.01 as monetary);
update qparith set dummy = cast(max_dbl as monetary) / cast(.01 as double);
update qparith set dummy = cast(max_dbl as monetary) / cast(.01 as monetary);
update qparith set dummy = numval / min_short;
update qparith set dummy = numval / min_int;
update qparith set dummy = numval / cast(.01 as float);
update qparith set dummy = numval / cast(.01 as double);
update qparith set dummy = numval / cast(.01 as numeric(3,2));
update qparith set dummy = numval / cast(.01 as monetary);
update qparith set dummy = cast(min_dbl as monetary) / :NUM;
rollback;
