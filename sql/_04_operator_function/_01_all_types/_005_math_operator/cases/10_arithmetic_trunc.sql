-- trunc
select trunc(cast(15.456 as SHORT), cast(1 as SHORT)) from db_root;
select trunc(cast(15.456 as SHORT), cast(1 as INTEGER)) from db_root;
select trunc(cast(15.456 as SHORT), cast(1 as BIGINT)) from db_root;
select trunc(cast(15.456 as SHORT), cast(1 as FLOAT)) from db_root;

select trunc(cast(15.456 as INTEGER), cast(1 as SHORT)) from db_root;
select trunc(cast(15.456 as INTEGER), cast(1 as INTEGER)) from db_root;
select trunc(cast(15.456 as INTEGER), cast(1 as BIGINT)) from db_root;
select trunc(cast(15.456 as INTEGER), cast(1 as FLOAT)) from db_root;

select trunc(cast(15.456 as BIGINT), cast(1 as SHORT)) from db_root;
select trunc(cast(15.456 as BIGINT), cast(1 as INTEGER)) from db_root;
select trunc(cast(15.456 as BIGINT), cast(1 as BIGINT)) from db_root;
select trunc(cast(15.456 as BIGINT), cast(1 as FLOAT)) from db_root;

select trunc(cast(15.456 as FLOAT), cast(1 as SHORT)) from db_root;
select trunc(cast(15.456 as FLOAT), cast(1 as INTEGER)) from db_root;
select trunc(cast(15.456 as FLOAT), cast(1 as BIGINT)) from db_root;
select trunc(cast(15.456 as FLOAT), cast(1 as FLOAT)) from db_root;

select trunc(cast(15.456 as DOUBLE), cast(1 as SHORT)) from db_root;
select trunc(cast(15.456 as DOUBLE), cast(1 as INTEGER)) from db_root;
select trunc(cast(15.456 as DOUBLE), cast(1 as BIGINT)) from db_root;
select trunc(cast(15.456 as DOUBLE), cast(1 as FLOAT)) from db_root;

select trunc(cast(15.456 as MONETARY), cast(1 as SHORT)) from db_root;
select trunc(cast(15.456 as MONETARY), cast(1 as INTEGER)) from db_root;
select trunc(cast(15.456 as MONETARY), cast(1 as BIGINT)) from db_root;
select trunc(cast(15.456 as MONETARY), cast(1 as FLOAT)) from db_root;

select trunc(cast(15.456 as NUMERIC(15,5)), cast(1 as SHORT)) from db_root;
select trunc(cast(15.456 as NUMERIC(15,5)), cast(1 as INTEGER)) from db_root;
select trunc(cast(15.456 as NUMERIC(15,5)), cast(1 as BIGINT)) from db_root;
select trunc(cast(15.456 as NUMERIC(15,5)), cast(1 as FLOAT)) from db_root;

select trunc(cast(15.456 as NUMERIC(15,5)), cast(2 as INTEGER)) from db_root;
select trunc(cast(15.456 as NUMERIC(15,5)), cast(3 as INTEGER)) from db_root;
select trunc(cast(15.456 as NUMERIC(15,5)), cast(4 as INTEGER)) from db_root;
select trunc(cast(15.456 as NUMERIC(15,5)), cast(-1 as INTEGER)) from db_root;
select trunc(cast(15.456 as NUMERIC(15,5)), cast(-2 as INTEGER)) from db_root;
select trunc(cast(15.456 as NUMERIC(15,5)), cast(-3 as INTEGER)) from db_root;
select trunc(cast(15.456 as NUMERIC(15,5)), cast(-100 as INTEGER)) from db_root;

select trunc(cast(15.456 as BIGINT), cast(-1 as BIGINT)) from db_root;
select trunc(cast(15.456 as BIGINT), cast(0 as BIGINT)) from db_root;
select trunc(cast(15.456 as DOUBLE), cast(-1 as BIGINT)) from db_root;
select trunc(cast(15.456 as DOUBLE), cast(0 as BIGINT)) from db_root;

select trunc(cast(-15.456 as SHORT), cast(1 as INTEGER)) from db_root;
select trunc(cast(-15.456 as INTEGER), cast(1 as INTEGER)) from db_root;
select trunc(cast(-15.456 as FLOAT), cast(1 as INTEGER)) from db_root;
select trunc(cast(-15.456 as DOUBLE), cast(1 as INTEGER)) from db_root;
select trunc(cast(-15.456 as MONETARY), cast(1 as INTEGER)) from db_root;

select trunc(cast(0 as SHORT), cast(1 as INTEGER)) from db_root;
select trunc(cast(0 as INTEGER), cast(1 as INTEGER)) from db_root;
select trunc(cast(0 as FLOAT), cast(1 as INTEGER)) from db_root;
select trunc(cast(0 as DOUBLE), cast(1 as INTEGER)) from db_root;
select trunc(cast(0 as MONETARY), cast(1 as INTEGER)) from db_root;




