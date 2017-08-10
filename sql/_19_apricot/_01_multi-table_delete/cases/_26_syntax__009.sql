--SERVER
create class t(i int, seq_col sequence(int));

insert into t values (1, {0, 1});
insert into t values (2, {0, 2});

delete t1 from t, table(seq_col) as t1(a);

delete t from t, table(seq_col) as t1(a);
select * from t order by 1;

drop class t;