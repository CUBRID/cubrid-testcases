--Create a class which domain_list is a combination of data type and user-defined class
--+ holdcas on;
create class t1(c1 int, c2 char(10));
create class t2(c1 char(10), c2 t1);

create class t3(c1 multiset (int, t1), c2 multiset (char(10), t1),
                 c3 multiset (t1, t2), c4 multiset (t2, t1));
                 
insert into t3 values ({10001,10001,insert into t1 values(101,'Jerry'),
                         insert into t1 values(101,'Jerry')
                         },
                        {'xxx', 
                          insert into t1 values(102, 'Nancy'),
                          insert into t1 values(102, 'Nancy')
                         },
                         {insert into t1 values(103,'Dennis'),
                          insert into t1 values(103,'Dennis'),
                          insert into t2 values('t201', insert into t1 values(104, 'Sun')),
                          insert into t2 values('t201', insert into t1 values(104, 'Sun'))
                         },
                         {insert into t2 values('t202', insert into t1 values(105, 'Lucency')),
                          insert into t1 values(106, 'Livana'),
                          insert into t1 values(106, 'Livana')}                        
                        );

select * from t1 order by 1,2;
select c1, c2 from t3 order by 1,2;
select * from t2 order by 1,2;
drop class t1;
drop class t2;
drop class t3;
commit;
--+ holdcas off;
