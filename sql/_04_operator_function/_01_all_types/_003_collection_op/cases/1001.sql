--[er]test operators seteq, subset, superset, superseteq with many select statements and cast function.
create class func_12 ( a set of int, b multiset of int , c list of int );
insert into func_12 values ( {},{},{});
insert into func_12 values ( null,null,null);
insert into func_12 values ( {1,1},{1,1},{1,1});
insert into func_12 values ( {1,2,3},{1,2,3},{1,2,3});
insert into func_12 values ( {-1,-2,-3},{-1,-2,-3},{-1,-2,-3});

select a, b from func_12 where a seteq b order by 1,2;
select a, b from func_12 where a superset b order by 1,2;
select a, b from func_12 where a subset b order by 1,2;
select a, b from func_12 where a setneq b order by 1,2;
select a, b from func_12 where a subseteq b order by 1,2;
select a, b from func_12 where a superseteq b order by 1,2;
select a, c from func_12 where a seteq c order by 1,2;
select a, c from func_12 where a superset c order by 1,2;
select a, c from func_12 where a subset c order by 1,2;
select a, c from func_12 where a setneq c order by 1,2;
select a, c from func_12 where a subseteq c order by 1,2;
select a, c from func_12 where a superseteq c order by 1,2;
select b, c from func_12 where b seteq c order by 1,2;
select b, c from func_12 where b superset c order by 1,2;
select b, c from func_12 where b subset c order by 1,2;
select b, c from func_12 where b setneq c order by 1,2;
select b, c from func_12 where b subseteq c order by 1,2;
select b, c from func_12 where b superseteq c order by 1,2;
select a, a from func_12 where a seteq a order by 1,2;
select b, b from func_12 where b seteq b order by 1,2;
select c, c from func_12 where c seteq c order by 1,2;
select a, a from func_12 where a setneq a order by 1,2;
select b, b from func_12 where b setneq b order by 1,2;
select c, c from func_12 where c setneq c order by 1,2;
select a, c from func_12 where a superseteq cast(c as set of int ) order by 1,2;
select a, b from func_12 where a superseteq {cast(1 as float)} order by 1,2;
select a , na from func_12 union all select na, a from func_12  order by 1,2;
select a, c from func_12 where cast(a as list of int) superseteq c order by 1,2;

drop class func_12;
