--Add a query specification to a virtual class with collection type
create vclass v_t1(c1 set int,
                    c2 set varchar(10));
                
create class t1(c1 int,
                 c2 set int,
                 c3 set varchar(10));
insert into t1 values(101, {111,222}, {'xxx','yyy','xxx'});
insert into t1 values(102, {333,444}, {'aa','bb','cc'});


alter vclass v_t1 
   add query select c2,c3 from t1 where c1 = 101;
   
select * from v_t1;

drop vclass v_t1;
drop class t1;
               