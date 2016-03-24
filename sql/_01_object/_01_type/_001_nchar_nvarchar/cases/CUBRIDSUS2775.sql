--test case for CUBRIDSUS2775

select 1 + 2 as a from db_root;
select 10 + 20 as a from db_root;

select 1.1 from db_root;
select 1.1f from db_root;

select 1.1 as a from db_root;
select 1.1f as a from db_root;

-- unary expr, unary expr with alias
select -1.1 from db_root;
select -1.1f from db_root;

select -1.1 as a from db_root;

-- expr, expr with alias
select 1+2 from db_root;
select 10+20 from db_root;

select 1+2 as a , 3+5 b from db_root;
select 10+20 as a , 30+50 b from db_root;
