--Test update with set-valued attributes
create class t1 ( col1 integer, col2 set integer);
insert into t1 values( 101, {1001, 1002, 1003});
insert into t1 values( 102, {2001, 2002, 2003});
insert into t1 values( 103, {3001, 3002, 3003});
insert into t1 values( 104, {4001, 4002, 4003});

update t1 set col2 = col2 + {1004}
where col1 = 101;

update t1 set col2 = col2 + {2004}
where col1 = 102;

update t1 set col2 = col2 + {3004}
where col1 = 103;

select * from t1 order by 1;

drop class t1;