create table t (a int, b bit(128), primary key (a, b));
create index i_t_b_a on t (b, a);
create index i_t_b on t (b);
insert into t values (1, X'000001b7f16a34cbb604657a98aadbbf');
insert into t values (2, X'000001b7f16a34cbb604657a98aadbbe');
insert into t values (3, X'000001b7f16a34cbb604657a98aadbbc');
insert into t values (4, X'000001b7f16a34cbb604657a98aadbbb');
insert into t values (5, X'000001b7f16a34cbb604657a98aadbba');
insert into t values (6, X'000001b7f16a34cbb604657a98aadbb9');
insert into t values (7, X'000001b7f16a34cbb604657a98aadbb8');
insert into t values (8, X'000001b7f16a34cbb604657a98aadbb7');
insert into t values (9, X'000001b7f16a34cbb604657a98aadbb6');
insert into t values (10, X'000001b7f16a34cbb604657a98aadbb5');

select * from t where b=X'000001b7f16a34cbb604657a98aadbbf' using index i_t_b_a(+);

select * from t where b=X'000001b7f16a34cbb604657a98aadbbf';
select * from t where b=X'000001b7f16a34cbb604657a98aadbbf' using index i_t_b(+);
select * from t where b=X'000001b7f16a34cbb604657a98aadbbf' and a=1; 

drop table t;
