create table test1 (col_set set);
insert into test1 values({1,22,3});
insert into test1 values({2,22,3});
select * from test1 order by col_set;
select * from test1 where col_set < col_set;
select * from test1 where col_set <= col_set;
select * from test1 where col_set >= col_set;
select * from test1 where col_set > col_set;
select * from test1 where col_set = col_set;
select * from test1 where col_set in ({1, 22, 3}, {2, 22, 3}, NULL);

create table test2 (col_set set, col_list list, col_mset multiset, col_seq sequence);
insert into test2 values({2,22,3}, {2, 3}, {2, 3}, {1, 2, 3});
insert into test2 values({2,22,3}, {2, 3, 3}, {2, 3, 3}, {1, 2, 3, 4});
insert into test2 values({2,22,3}, {2, 3, 3}, {2, 3, 3}, {2, 3, 4, 5});

select * from test2 order by col_list;
select * from test2 order by col_mset;
select * from test2 order by col_seq;
select * from test2 where col_set > col_list;
select * from test2 where col_set >= col_list;
select * from test2 where col_set < col_list;
select * from test2 where col_set <= col_list;
select * from test2 where col_set = col_list;

select * from test2 where col_set > col_mset;
select * from test2 where col_set >= col_mset;
select * from test2 where col_set < col_mset;
select * from test2 where col_set <= col_mset;
select * from test2 where col_set = col_mset;

select * from test2 where col_mset > col_list;
select * from test2 where col_mset >= col_list;
select * from test2 where col_mset < col_list;
select * from test2 where col_mset <= col_list;
select * from test2 where col_mset = col_list;

select * from test2 where col_set > col_seq;
select * from test2 where col_set >= col_seq;
select * from test2 where col_set < col_seq;
select * from test2 where col_set <= col_seq;
select * from test2 where col_set = col_seq;

select * from test2 where col_seq > col_mset;
select * from test2 where col_seq >= col_mset;
select * from test2 where col_seq < col_mset;
select * from test2 where col_seq <= col_mset;
select * from test2 where col_seq = col_mset;

select * from test2 where col_seq > col_list;
select * from test2 where col_seq >= col_list;
select * from test2 where col_seq < col_list;
select * from test2 where col_seq <= col_list;
select * from test2 where col_seq = col_list;

drop test1;
drop test2;
