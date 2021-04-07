--+ holdcas on;
create table t(
     col_smallint         SMALLINT NOT NULL,
     col_integer          INTEGER,
     col_bigint           BIGINT,
     col_float            FLOAT,
     col_double           DOUBLE,
     col_monetary         MONETARY,
     col_numeric_9_2      NUMERIC(9,2),
     col_char_9           CHARACTER(9),
     col_varchar_92       CHARACTER VARYING(92),
     col_string           CHARACTER VARYING(1073741823),
     col_nchar_9          NATIONAL CHARACTER(9),
     col_nvarnchar_92     NATIONAL CHARACTER VARYING(92),
     col_date             DATE,
     col_time             TIME,
     col_timestamp        TIMESTAMP,
     col_datetime         DATETIME,
     col_bit              BIT(4),
     col_varbit           BIT VARYING(40),
     col_set              SET,
     col_set_int          SET,
     col_seq              SEQUENCE,
     col_multiset         MULTISET);

create index i_t_all on t(col_smallint,col_integer,col_bigint,col_float,col_double,col_monetary,col_numeric_9_2,col_char_9,col_varchar_92,col_string,col_nchar_9,col_nvarnchar_92,col_date,col_time,col_timestamp,col_datetime,col_bit,col_varbit);

insert into t(col_smallint) values (-1);
select /*+ recompile */ * from t where col_smallint=-1 order by  col_integer,col_bigint,col_float,col_double,col_monetary,col_numeric_9_2,col_char_9,col_varchar_92,col_string,col_nchar_9,col_nvarnchar_92,col_date,col_time,col_timestamp,col_datetime,col_bit,col_varbit;
select /*+ recompile */ * from t where col_smallint=-1 order by  col_integer;

truncate table t;
insert into t(col_smallint, col_float) values (0, 0-0.0000000001);
select /*+ recompile */ * from t where col_float=-1.000000e-10 order by col_smallint,col_integer,col_bigint,col_double,col_monetary,col_numeric_9_2,col_char_9,col_varchar_92,col_string,col_nchar_9,col_nvarnchar_92,col_date,col_time,col_timestamp,col_datetime,col_bit,col_varbit;

truncate table t;
insert into t(col_smallint, col_double) values (0, 0-0.0000000001);
select /*+ recompile */ * from t where col_double=-1.000000e-10 order by col_smallint,col_integer,col_bigint,col_float,col_monetary,col_numeric_9_2,col_char_9,col_varchar_92,col_string,col_nchar_9,col_nvarnchar_92,col_date,col_time,col_timestamp,col_datetime,col_bit,col_varbit;

truncate table t;
insert into t(col_smallint, col_monetary) values (0, -100);
select /*+ recompile */ * from t where col_monetary=-100 order by col_smallint,col_integer,col_bigint,col_float,col_double,col_numeric_9_2,col_char_9,col_varchar_92,col_string,col_nchar_9,col_nvarnchar_92,col_date,col_time,col_timestamp,col_datetime,col_bit,col_varbit;

truncate table t;
insert into t(col_smallint, col_timestamp) values (0, timestamp '2011-02-23 19:35:00');
select /*+ recompile */ * from t where col_timestamp=timestamp '2011-02-23 19:35:00' order by col_smallint,col_integer,col_bigint,col_float,col_double,col_monetary,col_numeric_9_2,col_char_9,col_varchar_92,col_string,col_nchar_9,col_nvarnchar_92,col_date,col_time,col_timestamp,col_datetime,col_bit,col_varbit;


truncate table t;
insert into t(col_smallint, col_char_9) values (0, '');
select /*+ recompile */ * from t where col_char_9='' order by col_smallint,col_integer,col_bigint,col_float,col_double,col_monetary,col_numeric_9_2,col_varchar_92,col_string,col_nchar_9,col_nvarnchar_92,col_date,col_time,col_timestamp,col_datetime,col_bit,col_varbit;

drop table t;

commit;
--+ holdcas off;
