--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t(col_smallint         SMALLINT DEFAULT 123 NOT NULL,
     col_integer          INTEGER DEFAULT 1234 NOT NULL,
     col_bigint           BIGINT DEFAULT 12345 NOT NULL,
     col_float            FLOAT DEFAULT 1.234 NOT NULL,
     col_double           DOUBLE DEFAULT 1.23457,
     col_monetary         MONETARY DEFAULT $1.23 NOT NULL,
     col_numeric_9_2      NUMERIC(9,2) DEFAULT 1.23,
     col_char_9           CHARACTER(9) DEFAULT 'abcd     ' NOT NULL,
     col_varchar_92       CHARACTER VARYING(92) DEFAULT 'abcdefg',
     col_string           CHARACTER VARYING(1073741823) DEFAULT 'abcdefghijklmn' NOT NULL,
     col_nchar_9          NATIONAL CHARACTER(9) DEFAULT N'abcd     ',
     col_nvarnchar_92     NATIONAL CHARACTER VARYING(92) DEFAULT N'abcdefg',
     col_date             DATE DEFAULT date '05/03/2010' NOT NULL,
     col_time             TIME DEFAULT time '06:59:12 PM' NOT NULL,
     col_timestamp        TIMESTAMP DEFAULT timestamp '06:59:12 PM 05/03/2000',
     col_datetime         DATETIME DEFAULT datetime '06:59:12.203 PM 05/03/2010 ',
     col_bit              BIT(4) DEFAULT X'8' NOT NULL,
     col_varbit           BIT VARYING(40) DEFAULT X'8',
     col_set              SET OF  DEFAULT {1} NOT NULL,
     col_set_int          SET OF INTEGER DEFAULT {1},
     col_seq              SEQUENCE OF  DEFAULT {1} NOT NULL,
     col_multiset         MULTISET OF  NATIONAL CHARACTER VARYING(92) DEFAULT {N'1', N'2', N'3333333333333333333333'});



create index i_t_smallint on t(col_smallint);
create index i_t_integer on t(col_integer);
create index i_t_bigint on t(col_bigint);
create index i_t_float on t(col_float);
create index i_t_double on t(col_double);
create index i_t_monetary on t(col_monetary);
create index i_t_numeric_9_2 on t(col_numeric_9_2);
create index i_t_char_9 on t(col_char_9);
create index i_t_varchar_92 on t(col_varchar_92);
create index i_t_string on t(col_string);
create index i_t_nchar_9 on t(col_nchar_9);
create index i_t_nvarnchar_92 on t(col_nvarnchar_92);
create index i_t_date on t(col_date);
create index i_t_time on t(col_time);
create index i_t_timestamp on t(col_timestamp);
create index i_t_datetime on t(col_datetime);
create index i_t_bit on t(col_bit);
create index i_t_varbit on t(col_varbit);

select /*+ recompile */ *  from t where col_smallint is not null order by col_smallint;
select /*+ recompile */ *  from t where col_integer is not null order by col_integer;
select /*+ recompile */ *  from t where  col_bigint is not null order by col_bigint;
--t.col_float>=1.17549e-38
select /*+ recompile */ *  from t where  col_float is not null order by col_float;

select /*+ recompile */ *  from t where  col_double is not null order by col_double;
--plus value?
select /*+ recompile */ *  from t where  col_monetary is not null order by col_monetary;
select /*+ recompile */ *  from t where  col_numeric_9_2 is not null order by col_numeric_9_2;
--t.col_char_9>=cast(' ' as char(9)))
select /*+ recompile */ *  from t where  col_char_9 is not null order by col_char_9;
select /*+ recompile */ *  from t where  col_varchar_92 is not null order by col_varchar_92;
--t.col_string>=' ')
select /*+ recompile */ *  from t where  col_string is not null order by col_string;
select /*+ recompile */ *  from t where  col_nchar_9 is not null order by col_nchar_9;
select /*+ recompile */ *  from t where  col_nvarnchar_92 is not null order by col_nvarnchar_92;
--(t.col_date>=date '01/01/0001')
select /*+ recompile */ *  from t where  col_date is not null order by col_date;
--(t.col_time>=time '12:00:00 AM')
select /*+ recompile */ *  from t where  col_time is not null order by col_time;
select /*+ recompile */ *  from t where  col_timestamp is not null order by col_timestamp;
select /*+ recompile */ *  from t where  col_datetime is not null order by col_datetime;
--((t.col_bit>=cast(X'0' as bit(4))))
select /*+ recompile */ *  from t where  col_bit is not null order by col_bit;
select /*+ recompile */ *  from t where  col_varbit is not null order by col_varbit;
drop table t;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
