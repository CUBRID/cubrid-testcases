drop table if exists t1;

create table t1 (
c1_int         int, 
c2_bigint      BIGINT, 
c3_tinyint     TINYINT, 
c4_smallint    SMALLINT, 
c5_mediumint   MEDIUMINT,
c6_numeric     numeric(38,10),
c7_float       float,
c8_real        real,
c9_doublepre   double precision
);

insert into t1 values (1, 1, 1, 1, 1, 1, 1, 1, 1);

select json_object('a', c1_int)       from t1;
select json_object('a', c2_bigint)    from t1;
select json_object('a', c3_tinyint)   from t1;
select json_object('a', c4_smallint)  from t1;
select json_object('a', c5_mediumint) from t1;
select json_object('a', c6_numeric) from t1;
--http://jira.cubrid.org/browse/CBRD-22646
--select json_object('a', c7_float) from t1;
--select json_object('a', c8_real) from t1;
select json_object('a', c9_doublepre) from t1;

select json_array('a', c1_int)       from t1;
select json_array('a', c2_bigint)    from t1;
select json_array('a', c3_tinyint)   from t1;
select json_array('a', c4_smallint)  from t1;
select json_array('a', c5_mediumint) from t1;
select json_array('a', c6_numeric) from t1;
--http://jira.cubrid.org/browse/CBRD-22646
--select json_array('a', c7_float) from t1;
--select json_array('a', c8_real) from t1;
select json_array('a', c9_doublepre) from t1;

drop table if exists t1;
