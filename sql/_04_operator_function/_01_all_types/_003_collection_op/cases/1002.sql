--test seteq operator with a select statement
create class func_12 ( a set of int, b multiset of int , c list of int );
insert into func_12 values ( {},{},{});
insert into func_12 values ( null,null,null);
insert into func_12 values ( {1,1},{1,1},{1,1});
insert into func_12 values ( {1,2,3},{1,2,3},{1,2,3});
insert into func_12 values ( {-1,-2,-3},{-1,-2,-3},{-1,-2,-3});

select a, b from func_12 where a seteq {'1'} order by 1,2;

drop class func_12;
