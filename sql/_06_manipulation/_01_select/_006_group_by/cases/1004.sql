--test functions groupby_num(), orderby_num() with many select queries.
create class func_11 ( a int );
insert into func_11 values (1);
insert into func_11 values (2);
insert into func_11 values (2);
insert into func_11 values (3);
insert into func_11 values (3);
insert into func_11 values (3);
insert into func_11 values (4);
insert into func_11 values (4);
insert into func_11 values (4);
insert into func_11 values (4);
insert into func_11 values (5);
insert into func_11 values (5);
insert into func_11 values (5);
insert into func_11 values (5);
insert into func_11 values (5);

select orderby_num(), a  from func_11 order by a;
select orderby_num(), a  from func_11 order by a for orderby_num() <= 5;
select ORDERBY_NUM(), a  from func_11 order by a for ORDERBY_num() = 3;
select groupby_num(), a, count(*) from func_11 group by a order by 1;
select groupby_num(), a, count(*) from func_11 group by a having groupby_num() = 3 order by 1;
select groupby_num(), orderby_num(), a, count(*) from func_11 group by a order by a;
select groupby_num(), orderby_num(), a, count(*) from func_11 group by a order by a for orderby_num() = 3;
select groupby_num(), orderby_num(), a, count(*) from func_11 group by a having groupby_num() = 3 order by a for orderby_num() = 1;
select GROUPBY_NUM(), orderby_num(), a, count(*) from func_11 group by a having groupby_num() = 3 order by a for orderby_num() = 1;
select GROUPBY_NUM(), orderby_num(), a, count(*) from func_11 group by a having groupby_num() = 3 order by a for orderby_num() = 0;
select GROUPBY_NUM(), orderby_num(), a, count(*) from func_11 group by a having groupby_num() = 0 order by a for orderby_num() = 0;
select orderby_num(), a from func_11 order by a for orderby_num() = 1 or orderby_num() = 2 or orderby_num() = 3 or orderby_num() = 4 or orderby_num() = 5;
select orderby_num(), a from func_11 order by a for (orderby_num() >=1 and orderby_num() <= 2) or (orderby_num() >=3 and orderby_num() <= 4 ) or (orderby_num() >=5 and orderby_num() <= 6 ) or (orderby_num() >=7 and orderby_num() <= 8 ) or (orderby_num() >=9 and orderby_num() <= 10 );

drop class func_11;
