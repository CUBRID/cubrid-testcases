create class test_class (bigint_col bigint);

create index idx_bigint_col on test_class(bigint_col);

insert into test_class(bigint_col) values (-9223372036854775808);
insert into test_class(bigint_col) values (9223372036854775807);
insert into test_class(bigint_col) values (100);
insert into test_class(bigint_col) values (-100);
insert into test_class(bigint_col) values (0);

select a.*, b.* from test_class a, test_class b where a.bigint_col = b.bigint_col order by 1,2;
select a.*, b.* from test_class a left join test_class b on a.bigint_col = b.bigint_col order by 1,2;
select a.*, b.* from test_class a right join test_class b on a.bigint_col = b.bigint_col order by 1,2;
select a.*, b.* from test_class a inner join test_class b on a.bigint_col = b.bigint_col order by 1,2;

select a.*, b.* from test_class a, test_class b where a.bigint_col > b.bigint_col order by 1,2;
select a.*, b.* from test_class a left join test_class b on a.bigint_col > b.bigint_col order by 1,2;
select a.*, b.* from test_class a right join test_class b on a.bigint_col > b.bigint_col order by 1,2;
select a.*, b.* from test_class a inner join test_class b on a.bigint_col > b.bigint_col order by 1,2;


select a.*, b.* from test_class a, test_class b where a.bigint_col < b.bigint_col order by 1,2;
select a.*, b.* from test_class a left join test_class b on a.bigint_col < b.bigint_col order by 1,2;
select a.*, b.* from test_class a right join test_class b on a.bigint_col < b.bigint_col order by 1,2;
select a.*, b.* from test_class a inner join test_class b on a.bigint_col < b.bigint_col order by 1,2;

drop class test_class;
