--Wrong results of ORDERBY_NUM() and INST_NUM() function

create table test(a int, b int);
insert into test values(1,4), (2,3), (3,2), (4,1);

-- inst_num()
select inst_num(), rank() over(order by a), a from test;
select inst_num(), rank() over(order by a), a from test where inst_num() mod 2 = 0;

select 1+inst_num(), rank() over(order by a), a from test;
select 1+inst_num(), rank() over(order by a), a from test where inst_num() mod 2 = 0;

select 1+2*inst_num(), rank() over(order by a), a from test;
select 1+2*inst_num(), rank() over(order by a), a from test where inst_num() mod 2 = 0;

select 1+2*(select inst_num() from db_root), rank() over(order by a), a from test;
select 1+2*(select inst_num() from db_root), rank() over(order by a), a from test where inst_num() mod 2 = 0;



select inst_num(), rank() over(order by a), dense_rank() over (order by b), a from test;
select inst_num(), rank() over(order by a), dense_rank() over (order by b), a from test where inst_num() mod 2 = 0;

select 1+inst_num(), rank() over(order by a), dense_rank() over (order by b), a from test;
select 1+inst_num(), rank() over(order by a), dense_rank() over (order by b), a from test where inst_num() mod 2 = 0;

select 1+2*inst_num(), rank() over(order by a), dense_rank() over (order by b), a from test;
select 1+2*inst_num(), rank() over(order by a), dense_rank() over (order by b), a from test where inst_num() mod 2 = 0;

select 1+2*(select inst_num() from db_root), rank() over(order by a), dense_rank() over (order by b), a from test;
select 1+2*(select inst_num() from db_root), rank() over(order by a), dense_rank() over (order by b), a from test where inst_num() mod 2 = 0;

-- orderby_num()
select orderby_num(), rank() over(order by a), a from test order by a;
select (select orderby_num() from db_root order by charset), rank() over(order by a), a from test order by a;

select orderby_num(), rank() over(order by a), dense_rank() over (order by b), a from test order by a;
select (select orderby_num() from db_root order by charset), rank() over(order by a), dense_rank() over (order by b), a from test order by a;

drop table test;
