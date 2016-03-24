--+ holdcas on;
-- power
set system parameters 'compat_mode=cubrid';
select power(cast(1 as SHORT), cast(1 as SHORT)) from db_root;
select power(cast(1 as SHORT), cast(1 as INTEGER)) from db_root;
select power(cast(1 as SHORT), cast(1 as BIGINT)) from db_root;
select power(cast(1 as SHORT), cast(1 as FLOAT)) from db_root;
select power(cast(1 as SHORT), cast(1 as DOUBLE)) from db_root;
select power(cast(1 as SHORT), cast(1 as NUMERIC(15,5))) from db_root;
select power(cast(1 as SHORT), cast(1 as MONETARY)) from db_root;

select power(cast(-1 as SHORT), cast(1.5 as FLOAT)) from db_root;
select power(cast(-1 as SHORT), cast(1.5 as DOUBLE)) from db_root;
select power(cast(-1 as SHORT), cast(1.5 as NUMERIC(15,5))) from db_root;
select power(cast(-1 as SHORT), cast(1.5 as MONETARY)) from db_root;

select power(cast(1 as INTEGER), cast(1 as SHORT)) from db_root;
select power(cast(1 as INTEGER), cast(1 as INTEGER)) from db_root;
select power(cast(1 as INTEGER), cast(1 as BIGINT)) from db_root;
select power(cast(1 as INTEGER), cast(1 as FLOAT)) from db_root;
select power(cast(1 as INTEGER), cast(1 as DOUBLE)) from db_root;
select power(cast(1 as INTEGER), cast(1 as NUMERIC(15,5))) from db_root;
select power(cast(1 as INTEGER), cast(1 as MONETARY)) from db_root;

select power(cast(-1 as INTEGER), cast(1.5 as FLOAT)) from db_root;
select power(cast(-1 as INTEGER), cast(1.5 as DOUBLE)) from db_root;
select power(cast(-1 as INTEGER), cast(1.5 as NUMERIC(15,5))) from db_root;
select power(cast(-1 as INTEGER), cast(1.5 as MONETARY)) from db_root;

select power(cast(1 as BIGINT), cast(1 as SHORT)) from db_root;
select power(cast(1 as BIGINT), cast(1 as INTEGER)) from db_root;
select power(cast(1 as BIGINT), cast(1 as BIGINT)) from db_root;
select power(cast(1 as BIGINT), cast(1 as FLOAT)) from db_root;
select power(cast(1 as BIGINT), cast(1 as DOUBLE)) from db_root;
select power(cast(1 as BIGINT), cast(1 as NUMERIC(15,5))) from db_root;
select power(cast(1 as BIGINT), cast(1 as MONETARY)) from db_root;

select power(cast(-1 as BIGINT), cast(1.5 as FLOAT)) from db_root;
select power(cast(-1 as BIGINT), cast(1.5 as DOUBLE)) from db_root;
select power(cast(-1 as BIGINT), cast(1.5 as NUMERIC(15,5))) from db_root;
select power(cast(-1 as BIGINT), cast(1.5 as MONETARY)) from db_root;

select power(cast(1 as FLOAT), cast(1 as SHORT)) from db_root;
select power(cast(1 as FLOAT), cast(1 as INTEGER)) from db_root;
select power(cast(1 as FLOAT), cast(1 as BIGINT)) from db_root;
select power(cast(1 as FLOAT), cast(1 as FLOAT)) from db_root;
select power(cast(1 as FLOAT), cast(1 as DOUBLE)) from db_root;
select power(cast(1 as FLOAT), cast(1 as NUMERIC(15,5))) from db_root;
select power(cast(1 as FLOAT), cast(1 as MONETARY)) from db_root;

select power(cast(-1 as FLOAT), cast(1.5 as FLOAT)) from db_root;
select power(cast(-1 as FLOAT), cast(1.5 as DOUBLE)) from db_root;
select power(cast(-1 as FLOAT), cast(1.5 as NUMERIC(15,5))) from db_root;
select power(cast(-1 as FLOAT), cast(1.5 as MONETARY)) from db_root;

select power(cast(1 as DOUBLE), cast(1 as SHORT)) from db_root;
select power(cast(1 as DOUBLE), cast(1 as INTEGER)) from db_root;
select power(cast(1 as DOUBLE), cast(1 as BIGINT)) from db_root;
select power(cast(1 as DOUBLE), cast(1 as FLOAT)) from db_root;
select power(cast(1 as DOUBLE), cast(1 as DOUBLE)) from db_root;
select power(cast(1 as DOUBLE), cast(1 as NUMERIC(15,5))) from db_root;
select power(cast(1 as DOUBLE), cast(1 as MONETARY)) from db_root;

select power(cast(-1 as DOUBLE), cast(1.5 as FLOAT)) from db_root;
select power(cast(-1 as DOUBLE), cast(1.5 as DOUBLE)) from db_root;
select power(cast(-1 as DOUBLE), cast(1.5 as NUMERIC(15,5))) from db_root;
select power(cast(-1 as DOUBLE), cast(1.5 as MONETARY)) from db_root;

select power(cast(1 as NUMERIC(15,5)), cast(1 as SHORT)) from db_root;
select power(cast(1 as NUMERIC(15,5)), cast(1 as INTEGER)) from db_root;
select power(cast(1 as NUMERIC(15,5)), cast(1 as BIGINT)) from db_root;
select power(cast(1 as NUMERIC(15,5)), cast(1 as FLOAT)) from db_root;
select power(cast(1 as NUMERIC(15,5)), cast(1 as DOUBLE)) from db_root;
select power(cast(1 as NUMERIC(15,5)), cast(1 as NUMERIC(15,5))) from db_root;
select power(cast(1 as NUMERIC(15,5)), cast(1 as MONETARY)) from db_root;

select power(cast(-1 as NUMERIC(15,5)), cast(1.5 as FLOAT)) from db_root;
select power(cast(-1 as NUMERIC(15,5)), cast(1.5 as DOUBLE)) from db_root;
select power(cast(-1 as NUMERIC(15,5)), cast(1.9 as NUMERIC(15,5))) from db_root;
select power(cast(-1 as NUMERIC(15,5)), cast(1.5 as MONETARY)) from db_root;

select power(cast(1 as MONETARY), cast(1 as SHORT)) from db_root;
select power(cast(1 as MONETARY), cast(1 as INTEGER)) from db_root;
select power(cast(1 as MONETARY), cast(1 as BIGINT)) from db_root;
select power(cast(1 as MONETARY), cast(1 as FLOAT)) from db_root;
select power(cast(1 as MONETARY), cast(1 as DOUBLE)) from db_root;
select power(cast(1 as MONETARY), cast(1 as NUMERIC(15,5))) from db_root;
select power(cast(1 as MONETARY), cast(1 as MONETARY)) from db_root;

select power(cast(-1 as MONETARY), cast(1.5 as FLOAT)) from db_root;
select power(cast(-1 as MONETARY), cast(1.5 as DOUBLE)) from db_root;
select power(cast(-1 as MONETARY), cast(1.5 as NUMERIC(15,5))) from db_root;
select power(cast(-1 as MONETARY), cast(1.5 as MONETARY)) from db_root;

-- power (overflow case)
select power(cast(9999 as SHORT), cast(7777 as SHORT)) from db_root;
select power(cast(9999 as SHORT), cast(7777 as INTEGER)) from db_root;
select power(cast(9999 as SHORT), cast(7777 as BIGINT)) from db_root;
select power(cast(9999 as SHORT), cast(7777 as FLOAT)) from db_root;
select power(cast(9999 as SHORT), cast(7777 as DOUBLE)) from db_root;
select power(cast(9999 as SHORT), cast(7777 as NUMERIC(15,5))) from db_root;
select power(cast(9999 as SHORT), cast(7777 as MONETARY)) from db_root;

select power(cast(9999 as INTEGER), cast(7777 as SHORT)) from db_root;
select power(cast(9999 as INTEGER), cast(7777 as INTEGER)) from db_root;
select power(cast(9999 as INTEGER), cast(7777 as BIGINT)) from db_root;
select power(cast(9999 as INTEGER), cast(7777 as FLOAT)) from db_root;
select power(cast(9999 as INTEGER), cast(7777 as DOUBLE)) from db_root;
select power(cast(9999 as INTEGER), cast(7777 as NUMERIC(15,5))) from db_root;
select power(cast(9999 as INTEGER), cast(7777 as MONETARY)) from db_root;

select power(cast(9999 as BIGINT), cast(7777 as SHORT)) from db_root;
select power(cast(9999 as BIGINT), cast(7777 as INTEGER)) from db_root;
select power(cast(9999 as BIGINT), cast(7777 as BIGINT)) from db_root;
select power(cast(9999 as BIGINT), cast(7777 as FLOAT)) from db_root;
select power(cast(9999 as BIGINT), cast(7777 as DOUBLE)) from db_root;
select power(cast(9999 as BIGINT), cast(7777 as NUMERIC(15,5))) from db_root;
select power(cast(9999 as BIGINT), cast(7777 as MONETARY)) from db_root;

select power(cast(9999 as FLOAT), cast(7777 as SHORT)) from db_root;
select power(cast(9999 as FLOAT), cast(7777 as INTEGER)) from db_root;
select power(cast(9999 as FLOAT), cast(7777 as BIGINT)) from db_root;
select power(cast(9999 as FLOAT), cast(7777 as FLOAT)) from db_root;
select power(cast(9999 as FLOAT), cast(7777 as DOUBLE)) from db_root;
select power(cast(9999 as FLOAT), cast(7777 as NUMERIC(15,5))) from db_root;
select power(cast(9999 as FLOAT), cast(7777 as MONETARY)) from db_root;

select power(cast(9999 as DOUBLE), cast(7777 as SHORT)) from db_root;
select power(cast(9999 as DOUBLE), cast(7777 as INTEGER)) from db_root;
select power(cast(9999 as DOUBLE), cast(7777 as BIGINT)) from db_root;
select power(cast(9999 as DOUBLE), cast(7777 as FLOAT)) from db_root;
select power(cast(9999 as DOUBLE), cast(7777 as DOUBLE)) from db_root;
select power(cast(9999 as DOUBLE), cast(7777 as NUMERIC(15,5))) from db_root;
select power(cast(9999 as DOUBLE), cast(7777 as MONETARY)) from db_root;

select power(cast(9999 as NUMERIC(15,5)), cast(7777 as SHORT)) from db_root;
select power(cast(9999 as NUMERIC(15,5)), cast(7777 as INTEGER)) from db_root;
select power(cast(9999 as NUMERIC(15,5)), cast(7777 as BIGINT)) from db_root;
select power(cast(9999 as NUMERIC(15,5)), cast(7777 as FLOAT)) from db_root;
select power(cast(9999 as NUMERIC(15,5)), cast(7777 as DOUBLE)) from db_root;
select power(cast(9999 as NUMERIC(15,5)), cast(7777 as NUMERIC(15,5))) from db_root;
select power(cast(9999 as NUMERIC(15,5)), cast(7777 as MONETARY)) from db_root;

select power(cast(9999 as MONETARY), cast(7777 as SHORT)) from db_root;
select power(cast(9999 as MONETARY), cast(7777 as INTEGER)) from db_root;
select power(cast(9999 as MONETARY), cast(7777 as BIGINT)) from db_root;
select power(cast(9999 as MONETARY), cast(7777 as FLOAT)) from db_root;
select power(cast(9999 as MONETARY), cast(7777 as DOUBLE)) from db_root;
select power(cast(9999 as MONETARY), cast(7777 as NUMERIC(15,5))) from db_root;
select power(cast(9999 as MONETARY), cast(7777 as MONETARY)) from db_root;
commit;
--+ holdcas off;
