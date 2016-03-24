autocommit off;
create class mt_multi_class1 (
       se_timestmp multiset(timestamp),
       se_small_int multiset(smallint)
);
create class multi_class1 (
       se_timestmp multiset(timestamp),
       se_small_int multiset(smallint)
);
insert into mt_multi_class1 values ( {}, {} );
insert into multi_class1 values ( {'10:12:18 PM 06/12/1970', '10:12:19 PM 06/12/1970', '10:12:20 PM 06/12/1970', '10:12:21 PM 06/12/1970', '10:12:22 PM 06/12/1970'}, {1, 2, 3, 4, 5} );
select se_timestmp +
(select se_small_int from multi_class1) -
(select se_small_int from mt_multi_class1)
from multi_class1;
rollback;
