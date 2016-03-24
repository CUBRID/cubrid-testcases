--To test incr error message.

create class t1 (a int);

select * from t1 with increment for incr(a);

drop class t1;