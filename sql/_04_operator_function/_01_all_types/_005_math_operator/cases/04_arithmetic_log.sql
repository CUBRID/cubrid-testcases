-- log(10, 1) no error 
select log(cast(10 as SHORT), cast(1 as SHORT)) from db_root;
select log(cast(10 as SHORT), cast(1 as INTEGER)) from db_root;
select log(cast(10 as SHORT), cast(1 as BIGINT)) from db_root;
select log(cast(10 as SHORT), cast(1 as FLOAT)) from db_root;
select log(cast(10 as SHORT), cast(1 as DOUBLE)) from db_root;
select log(cast(10 as SHORT), cast(1 as NUMERIC(15,5))) from db_root;
select log(cast(10 as SHORT), cast(1 as MONETARY)) from db_root;

select log(cast(10 as INTEGER), cast(1 as SHORT)) from db_root;
select log(cast(10 as INTEGER), cast(1 as INTEGER)) from db_root;
select log(cast(10 as INTEGER), cast(1 as BIGINT)) from db_root;
select log(cast(10 as INTEGER), cast(1 as FLOAT)) from db_root;
select log(cast(10 as INTEGER), cast(1 as DOUBLE)) from db_root;
select log(cast(10 as INTEGER), cast(1 as NUMERIC(15,5))) from db_root;
select log(cast(10 as INTEGER), cast(1 as MONETARY)) from db_root;

select log(cast(10 as BIGINT), cast(1 as SHORT)) from db_root;
select log(cast(10 as BIGINT), cast(1 as INTEGER)) from db_root;
select log(cast(10 as BIGINT), cast(1 as BIGINT)) from db_root;
select log(cast(10 as BIGINT), cast(1 as FLOAT)) from db_root;
select log(cast(10 as BIGINT), cast(1 as DOUBLE)) from db_root;
select log(cast(10 as BIGINT), cast(1 as NUMERIC(15,5))) from db_root;
select log(cast(10 as BIGINT), cast(1 as MONETARY)) from db_root;

select log(cast(10 as FLOAT), cast(1 as SHORT)) from db_root;
select log(cast(10 as FLOAT), cast(1 as INTEGER)) from db_root;
select log(cast(10 as FLOAT), cast(1 as BIGINT)) from db_root;
select log(cast(10 as FLOAT), cast(1 as FLOAT)) from db_root;
select log(cast(10 as FLOAT), cast(1 as DOUBLE)) from db_root;
select log(cast(10 as FLOAT), cast(1 as NUMERIC(15,5))) from db_root;
select log(cast(10 as FLOAT), cast(1 as MONETARY)) from db_root;

select log(cast(10 as DOUBLE), cast(1 as SHORT)) from db_root;
select log(cast(10 as DOUBLE), cast(1 as INTEGER)) from db_root;
select log(cast(10 as DOUBLE), cast(1 as BIGINT)) from db_root;
select log(cast(10 as DOUBLE), cast(1 as FLOAT)) from db_root;
select log(cast(10 as DOUBLE), cast(1 as DOUBLE)) from db_root;
select log(cast(10 as DOUBLE), cast(1 as NUMERIC(15,5))) from db_root;
select log(cast(10 as DOUBLE), cast(1 as MONETARY)) from db_root;

select log(cast(10 as NUMERIC(15,5)), cast(1 as SHORT)) from db_root;
select log(cast(10 as NUMERIC(15,5)), cast(1 as INTEGER)) from db_root;
select log(cast(10 as NUMERIC(15,5)), cast(1 as BIGINT)) from db_root;
select log(cast(10 as NUMERIC(15,5)), cast(1 as FLOAT)) from db_root;
select log(cast(10 as NUMERIC(15,5)), cast(1 as DOUBLE)) from db_root;
select log(cast(10 as NUMERIC(15,5)), cast(1 as NUMERIC(15,5))) from db_root;
select log(cast(10 as NUMERIC(15,5)), cast(1 as MONETARY)) from db_root;

select log(cast(10 as MONETARY), cast(1 as SHORT)) from db_root;
select log(cast(10 as MONETARY), cast(1 as INTEGER)) from db_root;
select log(cast(10 as MONETARY), cast(1 as BIGINT)) from db_root;
select log(cast(10 as MONETARY), cast(1 as FLOAT)) from db_root;
select log(cast(10 as MONETARY), cast(1 as DOUBLE)) from db_root;
select log(cast(10 as MONETARY), cast(1 as NUMERIC(15,5))) from db_root;
select log(cast(10 as MONETARY), cast(1 as MONETARY)) from db_root;


-- log(10, 0) error 
select log(cast(10 as SHORT), cast(0 as SHORT)) from db_root;
select log(cast(10 as SHORT), cast(0 as INTEGER)) from db_root;
select log(cast(10 as SHORT), cast(0 as BIGINT)) from db_root;
select log(cast(10 as SHORT), cast(0 as FLOAT)) from db_root;
select log(cast(10 as SHORT), cast(0 as DOUBLE)) from db_root;
select log(cast(10 as SHORT), cast(0 as NUMERIC(15,5))) from db_root;
select log(cast(10 as SHORT), cast(0 as MONETARY)) from db_root;

select log(cast(10 as INTEGER), cast(0 as SHORT)) from db_root;
select log(cast(10 as INTEGER), cast(0 as INTEGER)) from db_root;
select log(cast(10 as INTEGER), cast(0 as BIGINT)) from db_root;
select log(cast(10 as INTEGER), cast(0 as FLOAT)) from db_root;
select log(cast(10 as INTEGER), cast(0 as DOUBLE)) from db_root;
select log(cast(10 as INTEGER), cast(0 as NUMERIC(15,5))) from db_root;
select log(cast(10 as INTEGER), cast(0 as MONETARY)) from db_root;

select log(cast(10 as BIGINT), cast(0 as SHORT)) from db_root;
select log(cast(10 as BIGINT), cast(0 as INTEGER)) from db_root;
select log(cast(10 as BIGINT), cast(0 as BIGINT)) from db_root;
select log(cast(10 as BIGINT), cast(0 as FLOAT)) from db_root;
select log(cast(10 as BIGINT), cast(0 as DOUBLE)) from db_root;
select log(cast(10 as BIGINT), cast(0 as NUMERIC(15,5))) from db_root;
select log(cast(10 as BIGINT), cast(0 as MONETARY)) from db_root;

select log(cast(10 as FLOAT), cast(0 as SHORT)) from db_root;
select log(cast(10 as FLOAT), cast(0 as INTEGER)) from db_root;
select log(cast(10 as FLOAT), cast(0 as BIGINT)) from db_root;
select log(cast(10 as FLOAT), cast(0 as FLOAT)) from db_root;
select log(cast(10 as FLOAT), cast(0 as DOUBLE)) from db_root;
select log(cast(10 as FLOAT), cast(0 as NUMERIC(15,5))) from db_root;
select log(cast(10 as FLOAT), cast(0 as MONETARY)) from db_root;

select log(cast(10 as DOUBLE), cast(0 as SHORT)) from db_root;
select log(cast(10 as DOUBLE), cast(0 as INTEGER)) from db_root;
select log(cast(10 as DOUBLE), cast(0 as BIGINT)) from db_root;
select log(cast(10 as DOUBLE), cast(0 as FLOAT)) from db_root;
select log(cast(10 as DOUBLE), cast(0 as DOUBLE)) from db_root;
select log(cast(10 as DOUBLE), cast(0 as NUMERIC(15,5))) from db_root;
select log(cast(10 as DOUBLE), cast(0 as MONETARY)) from db_root;

select log(cast(10 as NUMERIC(15,5)), cast(0 as SHORT)) from db_root;
select log(cast(10 as NUMERIC(15,5)), cast(0 as INTEGER)) from db_root;
select log(cast(10 as NUMERIC(15,5)), cast(0 as BIGINT)) from db_root;
select log(cast(10 as NUMERIC(15,5)), cast(0 as FLOAT)) from db_root;
select log(cast(10 as NUMERIC(15,5)), cast(0 as DOUBLE)) from db_root;
select log(cast(10 as NUMERIC(15,5)), cast(0 as NUMERIC(15,5))) from db_root;
select log(cast(10 as NUMERIC(15,5)), cast(0 as MONETARY)) from db_root;

select log(cast(10 as MONETARY), cast(0 as SHORT)) from db_root;
select log(cast(10 as MONETARY), cast(0 as INTEGER)) from db_root;
select log(cast(10 as MONETARY), cast(0 as BIGINT)) from db_root;
select log(cast(10 as MONETARY), cast(0 as FLOAT)) from db_root;
select log(cast(10 as MONETARY), cast(0 as DOUBLE)) from db_root;
select log(cast(10 as MONETARY), cast(0 as NUMERIC(15,5))) from db_root;
select log(cast(10 as MONETARY), cast(0 as MONETARY)) from db_root;

-- log(1, 1) error
select log(cast(1 as SHORT), cast(1 as SHORT)) from db_root;
select log(cast(1 as SHORT), cast(1 as INTEGER)) from db_root;
select log(cast(1 as SHORT), cast(1 as BIGINT)) from db_root;
select log(cast(1 as SHORT), cast(1 as FLOAT)) from db_root;
select log(cast(1 as SHORT), cast(1 as DOUBLE)) from db_root;
select log(cast(1 as SHORT), cast(1 as NUMERIC(15,5))) from db_root;
select log(cast(1 as SHORT), cast(1 as MONETARY)) from db_root;

select log(cast(1 as INTEGER), cast(1 as SHORT)) from db_root;
select log(cast(1 as INTEGER), cast(1 as INTEGER)) from db_root;
select log(cast(1 as INTEGER), cast(1 as BIGINT)) from db_root;
select log(cast(1 as INTEGER), cast(1 as FLOAT)) from db_root;
select log(cast(1 as INTEGER), cast(1 as DOUBLE)) from db_root;
select log(cast(1 as INTEGER), cast(1 as NUMERIC(15,5))) from db_root;
select log(cast(1 as INTEGER), cast(1 as MONETARY)) from db_root;

select log(cast(1 as BIGINT), cast(1 as SHORT)) from db_root;
select log(cast(1 as BIGINT), cast(1 as INTEGER)) from db_root;
select log(cast(1 as BIGINT), cast(1 as BIGINT)) from db_root;
select log(cast(1 as BIGINT), cast(1 as FLOAT)) from db_root;
select log(cast(1 as BIGINT), cast(1 as DOUBLE)) from db_root;
select log(cast(1 as BIGINT), cast(1 as NUMERIC(15,5))) from db_root;
select log(cast(1 as BIGINT), cast(1 as MONETARY)) from db_root;

select log(cast(1 as FLOAT), cast(1 as SHORT)) from db_root;
select log(cast(1 as FLOAT), cast(1 as INTEGER)) from db_root;
select log(cast(1 as FLOAT), cast(1 as BIGINT)) from db_root;
select log(cast(1 as FLOAT), cast(1 as FLOAT)) from db_root;
select log(cast(1 as FLOAT), cast(1 as DOUBLE)) from db_root;
select log(cast(1 as FLOAT), cast(1 as NUMERIC(15,5))) from db_root;
select log(cast(1 as FLOAT), cast(1 as MONETARY)) from db_root;

select log(cast(1 as DOUBLE), cast(1 as SHORT)) from db_root;
select log(cast(1 as DOUBLE), cast(1 as INTEGER)) from db_root;
select log(cast(1 as DOUBLE), cast(1 as BIGINT)) from db_root;
select log(cast(1 as DOUBLE), cast(1 as FLOAT)) from db_root;
select log(cast(1 as DOUBLE), cast(1 as DOUBLE)) from db_root;
select log(cast(1 as DOUBLE), cast(1 as NUMERIC(15,5))) from db_root;
select log(cast(1 as DOUBLE), cast(1 as MONETARY)) from db_root;

select log(cast(1 as NUMERIC(15,5)), cast(1 as SHORT)) from db_root;
select log(cast(1 as NUMERIC(15,5)), cast(1 as INTEGER)) from db_root;
select log(cast(1 as NUMERIC(15,5)), cast(1 as BIGINT)) from db_root;
select log(cast(1 as NUMERIC(15,5)), cast(1 as FLOAT)) from db_root;
select log(cast(1 as NUMERIC(15,5)), cast(1 as DOUBLE)) from db_root;
select log(cast(1 as NUMERIC(15,5)), cast(1 as NUMERIC(15,5))) from db_root;
select log(cast(1 as NUMERIC(15,5)), cast(1 as MONETARY)) from db_root;

select log(cast(1 as MONETARY), cast(1 as SHORT)) from db_root;
select log(cast(1 as MONETARY), cast(1 as INTEGER)) from db_root;
select log(cast(1 as MONETARY), cast(1 as BIGINT)) from db_root;
select log(cast(1 as MONETARY), cast(1 as FLOAT)) from db_root;
select log(cast(1 as MONETARY), cast(1 as DOUBLE)) from db_root;
select log(cast(1 as MONETARY), cast(1 as NUMERIC(15,5))) from db_root;
select log(cast(1 as MONETARY), cast(1 as MONETARY)) from db_root;


