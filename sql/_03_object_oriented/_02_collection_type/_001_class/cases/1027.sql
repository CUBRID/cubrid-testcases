--[er]Insert into class with collection type by variable,dropped variable
create class t1 (c1 set of int, c2 multiset varchar(10));
create class t2 (c1 int, c2 t1);
insert into t2 values(1001, (insert into t1 
                            values ({101,102}, {'aaa','bbb','aaa'}) 
                            into arg_t1)
                     );
insert into t2 values(1002, arg_t1);
drop variable art_t1;
insert into t2 values(1003, arg_t1);

select * from t2 order by 1,2;


drop class t1;
drop class t2;
