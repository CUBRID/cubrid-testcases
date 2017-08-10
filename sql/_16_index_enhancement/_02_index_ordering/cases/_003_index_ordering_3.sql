create table test_table(col_smallint         SMALLINT DEFAULT 123 NOT NULL,
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
     col_varnchar_92      NATIONAL CHARACTER VARYING(92) DEFAULT N'abcdefg',
     col_date             DATE DEFAULT date '05/03/2010' NOT NULL,
     col_time             TIME DEFAULT time '06:59:12 PM' NOT NULL,
     col_timestamp        TIMESTAMP DEFAULT timestamp '06:59:12 PM 05/03/2000',
     col_datetime         DATETIME DEFAULT datetime '06:59:12.203 PM 05/03/2010 ',
     col_bit              BIT(4) DEFAULT X'8' NOT NULL,
     col_varbit           BIT VARYING(40) DEFAULT X'8',
     col_set              SET OF  DEFAULT {1} NOT NULL,
     col_set_int          SET OF INTEGER DEFAULT {1},
     col_seq              SEQUENCE OF  DEFAULT {1} NOT NULL,
     col_multiset         MULTISET OF  NATIONAL CHARACTER VARYING(92) DEFAULT {N'1', N'2', N'3333333333333333333333'})

insert into test_table(col_smallint) values (1);
insert into test_table(col_integer) values (2);
insert into test_table(col_bigint) values (3);
insert into test_table(col_monetary) values (4);
insert into test_table(col_float) values (5);
insert into test_table(col_double) values (6);
insert into test_table(col_numeric_9_2) values (7);
insert into test_table(col_integer) values (8);
insert into test_table(col_monetary) values (9);
insert into test_table(col_bigint) values (10);
insert into test_table(col_double) values (11);
insert into test_table(col_numeric_9_2) values (12);
insert into test_table(col_timestamp) values ('06:59:12 PM 05/03/2001');
insert into test_table(col_timestamp) values ('06:59:12 PM 05/03/2002');
insert into test_table(col_timestamp) values ('06:59:12 PM 05/03/2003');
insert into test_table(col_timestamp) values ('06:59:12 PM 05/03/2004');
insert into test_table(col_timestamp) values ('06:59:12 PM 05/03/2005');
insert into test_table(col_timestamp) values ('06:59:12 PM 05/03/2006');
insert into test_table(col_timestamp) values ('06:59:12 PM 05/03/2007');
insert into test_table(col_timestamp) values ('06:59:12 PM 05/03/2008');
insert into test_table(col_timestamp) values ('06:59:12 PM 05/03/2009');
insert into test_table(col_timestamp) values ('06:59:12 PM 05/03/2010');
insert into test_table(col_timestamp) values ('06:59:12 PM 05/03/2020');

create index idx1 on test_table(col_smallint);
create index idx2 on test_table(col_smallint, col_float, col_string);
create index idx3 on test_table(col_timestamp, col_datetime);

select col_timestamp from test_table where col_timestamp > '06:59:12 PM 05/03/2008' order by col_timestamp;
select col_datetime from test_table where col_timestamp = '06:59:12 PM 05/03/2008' order by col_datetime;
select col_timestamp from test_table where cast(date_format(col_timestamp, '%Y') as int) > 2005 order by col_timestamp;
select col_smallint, col_float, col_string from test_table where col_string like('%ab%') order by col_smallint, col_float, col_string;
select col_smallint, col_float from test_table where col_varchar_92 like('%ab%') order by col_smallint, col_float;



drop table test_table;
