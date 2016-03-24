--Change the query specification in a virtual class
              
create class t1(c1 int,
                 c2 set int,
                 c3 set varchar(10));
insert into t1 values(101, {111,222}, {'xxx','yyy','xxx'});
insert into t1 values(102, {333,444}, {'aa','bb','cc'});


create vclass v_t1 
   as select c2,c3 from t1 where c1 = 101;
   
select * from v_t1;

alter vclass v_t1
  change query 1 select c2, c3 from t1 where c1=102;

select * from v_t1;

drop vclass v_t1;
drop class t1;
               