autocommit off;
     create class boo (a int);
     
     create vclass test5(test5_set set(int)) as
      select set(select a from boo where a > 99) 
      from boo;
insert into test5(test5_set) values ({1,2});
rollback;
