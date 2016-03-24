autocommit off;
create class set_attr
(
        se_instance     integer,
        se_small_int    set_of(smallint),
        se_int          set_of(int),
        se_float        set_of(float),
        se_double       set_of(double),
        se_char_10      set_of(char(10)),
        se_string       set_of(string),
        se_time         set_of(time),
        se_timestamp        set_of(timestamp),
        se_date         set_of(date),
        se_monetary     set_of(monetary),
        se_set_attr     set_of(set_attr),
        se_object       set_of(object),
        se_all          set_of()
        );
insert into set_attr values(20000,{},{},{},{},{},{},{},{},{},{},{},{},{}) 
	to s2;
select * from set_attr;
/* remove an element ( not supported for sequences)*/
update set_attr
set
se_small_int = se_small_int + {3},
se_int = se_int + {3},
se_float = se_float + {3.3},
se_double = se_double + {3.3},
se_char_10 = se_char_10 + {'*** 03 ***'},
se_string = se_string + {'new string 3'},
se_time = se_time + {TIME '3:03:03'},
se_timestamp = se_timestamp + {TIMESTAMP '03:33:33 10/7/1992'},
se_date = se_date + {DATE '03/03/92'},
se_monetary = se_monetary + {$300},
se_object = se_object + {s2},
se_set_attr = se_set_attr + {s2},
se_all = se_all + {'new stuff 3',s2}
where se_instance = 20000;
select * from set_attr;
select se_instance, 
	sequence(select t2.stuff from
		table(se_set_attr) as t1(r1), 
		table(r1.se_object) as t2(stuff))
from set_attr;
rollback;
