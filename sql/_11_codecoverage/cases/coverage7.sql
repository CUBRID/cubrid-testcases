-- order by, index


create table t1(
col_char CHAR(20),
col_vchar VARCHAR(20),
col_nchar NCHAR(20),
col_vnchar NCHAR VARYING(20),
col_bit BIT(20),
col_vbit BIT VARYING(20),
col_numeric NUMERIC ,
col_decimal DECIMAL,
col_int INTEGER,
col_sint SMALLINT,
col_monetary MONETARY,
col_float FLOAT,
col_double DOUBLE,
col_real REAL,
col_date DATE,
col_time TIME,
col_timestamp TIMESTAMP,
col_set SET char(20),
col_multiset MULTISET varchar(20),
col_list LIST char(20),
col_sequence SEQUENCE,
col_datetime datetime,
col_bigint bigint
);

insert into t1(
col_char,
col_vchar,
col_nchar,
col_vnchar,
col_bit,
col_vbit,
col_numeric,
col_decimal,
col_int,
col_sint,
col_monetary,
col_float,
col_double,
col_real,
col_date,
col_time,
col_timestamp,
col_set,
col_multiset,
col_list,
col_sequence,
col_datetime,
col_bigint
)
values
('nhn', 'v nhn', N'n nhn', N'v nhn', B'1011', X'101', 90.99, 91.99, 92, 93,
94.99, 95.99, 96.99, 97.99, '2010-01-31', TIME '16:08:33 pm' , 
'2010-01-31 13:49:50', {'a', 'b', 'a'}, {'a', 'b', 'a'}, {'a', 'b', 'a'},
{'a', 'b', 'a', 'd'}, DATETIME '2010-01-31 13:49:50', 9999 );


insert into t1(
col_char,
col_vchar,
col_nchar,
col_vnchar,
col_bit,
col_vbit,
col_numeric,
col_decimal,
col_int,
col_sint,
col_monetary,
col_float,
col_double,
col_real,
col_date,
col_time,
col_timestamp,
col_set,
col_multiset,
col_list,
col_sequence,
col_datetime,
col_bigint
)
values
('aha', 'v aha', N'n aha', N'v aha', B'10011', X'10101', 190.99, 191.99, 192, 193,
194.99, 195.99, 196.99, 197.99, '2020-01-31', TIME '18:08:33 pm' , 
'2020-01-31 13:49:50', {'d', 'b', 'a'}, {'d', 'b', 'a'}, {'d', 'b', 'a'},
{'d', 'b', 'a', 'd'}, DATETIME '2020-01-31 13:49:50', 19999 );

select * from t1 order by col_char;
select * from t1 order by col_vchar;
select * from t1 order by col_nchar;
select * from t1 order by col_vnchar;
select * from t1 order by col_bit;
select * from t1 order by col_vbit;
select * from t1 order by col_numeric;
select * from t1 order by col_decimal;
select * from t1 order by col_int;
select * from t1 order by col_sint;
select * from t1 order by col_monetary;
select * from t1 order by col_float;
select * from t1 order by col_double;
select * from t1 order by col_real;
select * from t1 order by col_date;
select * from t1 order by col_time;
select * from t1 order by col_timestamp;
select * from t1 order by col_set;
select * from t1 order by col_multiset;
select * from t1 order by col_list;
select * from t1 order by col_sequence;
select * from t1 order by col_datetime;
select * from t1 order by col_bigint;


select * from t1 order by col_char asc;
select * from t1 order by col_vchar asc;
select * from t1 order by col_nchar asc;
select * from t1 order by col_vnchar asc;
select * from t1 order by col_bit asc;
select * from t1 order by col_vbit asc;
select * from t1 order by col_numeric asc;
select * from t1 order by col_decimal asc;
select * from t1 order by col_int asc;
select * from t1 order by col_sint asc;
select * from t1 order by col_monetary asc;
select * from t1 order by col_float asc;
select * from t1 order by col_double asc;
select * from t1 order by col_real asc;
select * from t1 order by col_date asc;
select * from t1 order by col_time asc;
select * from t1 order by col_timestamp asc;
select * from t1 order by col_set asc;
select * from t1 order by col_multiset asc;
select * from t1 order by col_list asc;
select * from t1 order by col_sequence asc;
select * from t1 order by col_datetime asc;
select * from t1 order by col_bigint asc;


select * from t1 order by col_char desc;
select * from t1 order by col_vchar desc;
select * from t1 order by col_nchar desc;
select * from t1 order by col_vnchar desc;
select * from t1 order by col_bit desc;
select * from t1 order by col_vbit desc;
select * from t1 order by col_numeric desc;
select * from t1 order by col_decimal desc;
select * from t1 order by col_int desc;
select * from t1 order by col_sint desc;
select * from t1 order by col_monetary desc;
select * from t1 order by col_float desc;
select * from t1 order by col_double desc;
select * from t1 order by col_real desc;
select * from t1 order by col_date desc;
select * from t1 order by col_time desc;
select * from t1 order by col_timestamp desc;
select * from t1 order by col_set desc;
select * from t1 order by col_multiset desc;
select * from t1 order by col_list desc;
select * from t1 order by col_sequence desc;
select * from t1 order by col_datetime desc;
select * from t1 order by col_bigint desc;



create index idx_col_char on t1(col_char);
create index idx_col_vchar on t1(col_vchar);
create index idx_col_nchar on t1(col_nchar);
create index idx_col_vnchar on t1(col_vnchar);
create index idx_col_bit on t1(col_bit);
create index idx_col_vbit on t1(col_vbit);
create index idx_col_numeric on t1(col_numeric);
create index idx_col_int on t1(col_int);
create index idx_col_sint on t1(col_sint);
create index idx_col_monetary on t1(col_monetary);
create index idx_col_float on t1(col_float);
create index idx_col_double on t1(col_double);
create index idx_col_real on t1(col_real);
create index idx_col_date on t1(col_date);
create index idx_col_time on t1(col_time);
create index idx_col_timestamp on t1(col_timestamp);
create index idx_col_datetime on t1(col_datetime);
create index idx_col_bigint on t1(col_bigint);

create index idx_col_set on t1(col_set);
create index idx_col_multiset on t1(col_multiset);
create index idx_col_list on t1(col_list);
create index idx_col_sequence on t1(col_sequence);
create index idx_col_sequence1 on t1(col_sequence1);


select * from t1 order by col_char;
select * from t1 order by col_vchar;
select * from t1 order by col_nchar;
select * from t1 order by col_vnchar;
select * from t1 order by col_bit;
select * from t1 order by col_vbit;
select * from t1 order by col_numeric;
select * from t1 order by col_decimal;
select * from t1 order by col_int;
select * from t1 order by col_sint;
select * from t1 order by col_monetary;
select * from t1 order by col_float;
select * from t1 order by col_double;
select * from t1 order by col_real;
select * from t1 order by col_date;
select * from t1 order by col_time;
select * from t1 order by col_timestamp;
select * from t1 order by col_set;
select * from t1 order by col_multiset;
select * from t1 order by col_list;
select * from t1 order by col_sequence;
select * from t1 order by col_datetime;
select * from t1 order by col_bigint;


select * from t1 order by col_char asc;
select * from t1 order by col_vchar asc;
select * from t1 order by col_nchar asc;
select * from t1 order by col_vnchar asc;
select * from t1 order by col_bit asc;
select * from t1 order by col_vbit asc;
select * from t1 order by col_numeric asc;
select * from t1 order by col_decimal asc;
select * from t1 order by col_int asc;
select * from t1 order by col_sint asc;
select * from t1 order by col_monetary asc;
select * from t1 order by col_float asc;
select * from t1 order by col_double asc;
select * from t1 order by col_real asc;
select * from t1 order by col_date asc;
select * from t1 order by col_time asc;
select * from t1 order by col_timestamp asc;
select * from t1 order by col_set asc;
select * from t1 order by col_multiset asc;
select * from t1 order by col_list asc;
select * from t1 order by col_sequence asc;
select * from t1 order by col_datetime asc;
select * from t1 order by col_bigint asc;


select * from t1 order by col_char desc;
select * from t1 order by col_vchar desc;
select * from t1 order by col_nchar desc;
select * from t1 order by col_vnchar desc;
select * from t1 order by col_bit desc;
select * from t1 order by col_vbit desc;
select * from t1 order by col_numeric desc;
select * from t1 order by col_decimal desc;
select * from t1 order by col_int desc;
select * from t1 order by col_sint desc;
select * from t1 order by col_monetary desc;
select * from t1 order by col_float desc;
select * from t1 order by col_double desc;
select * from t1 order by col_real desc;
select * from t1 order by col_date desc;
select * from t1 order by col_time desc;
select * from t1 order by col_timestamp desc;
select * from t1 order by col_set desc;
select * from t1 order by col_multiset desc;
select * from t1 order by col_list desc;
select * from t1 order by col_sequence desc;
select * from t1 order by col_datetime desc;
select * from t1 order by col_bigint desc;



drop table t1;



