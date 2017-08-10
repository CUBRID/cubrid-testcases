create class ddl_0001 ( col1 decimal(6,5), col2 integer , col3 smallint , col4 decimal(8,7), col5 integer);
insert into ddl_0001 values(1.0011, 1001, 101, 1.00011, 1001);
insert into ddl_0001 values(1.0021, 1002, 102, 1.00021, 1001);
insert into ddl_0001 values(1.0031, 1003, 103, 1.00031, 1001);
insert into ddl_0001 values(1.0041, 1004, 104, 1.00041, 1001);
insert into ddl_0001 values(1.0051, 1005, 105, 1.00051, 1001);
insert into ddl_0001 values(1.0061, 1006, 106, 1.00061, 1001);
insert into ddl_0001 values(1.0071, 1007, 107, 1.00071, 1001);
insert into ddl_0001 values(1.0081, 1008, 108, 1.00081, 1001);
insert into ddl_0001 values(1.0091, 1009, 109, 1.00091, 1001);
create reverse index ddl_0001_idx0 on ddl_0001(col1 asc);
create reverse index ddl_0001_idx1 on ddl_0001(col2 asc);
create reverse index ddl_0001_idx2 on ddl_0001(col3 asc);
create reverse index ddl_0001_idx3 on ddl_0001(col4 desc);
create reverse index ddl_0001_idx4 on ddl_0001(col5 desc);
create reverse index ddl_0001_idx5 on ddl_0001(col1 asc,col2 desc);
create reverse index ddl_0001_idx6 on ddl_0001(col1 desc, col2 asc, col3 desc, col4 asc, col5 asc);
create reverse index ddl_0001_idx7 on ddl_0001(col3 desc, col4 asc, col5 desc);
create reverse index ddl_0001_idx8 on ddl_0001(col1 desc, col2 asc, col4 desc);
create reverse index ddl_0001_idx9 on ddl_0001(col5 desc, col3 asc, col1 desc);
create reverse index ddl_0001_idx10 on ddl_0001(col5 desc, col2 asc, col4 desc);
select * from db_index where class_name='ddl_0001' order by 1,2,3;
select * from db_index_key where class_name='ddl_0001' order by 1,2,3;
select * from ddl_0001 where col1 < 1.005 order by 1,2,3;
delete from ddl_0001 where col2 = 1002;
update ddl_0001 set col1=1.001;
drop class ddl_0001;


create class ddl_0001 ( col1 decimal(6,5), col2 integer , col3 smallint , col4 decimal(8,7), col5 integer);

insert into ddl_0001 values(1.0011, 1001, 101, 1.00011, 1001);
insert into ddl_0001 values(1.0021, 1002, 102, 1.00021, 1001);
insert into ddl_0001 values(1.0031, 1003, 103, 1.00031, 1001);
insert into ddl_0001 values(1.0041, 1004, 104, 1.00041, 1001);
insert into ddl_0001 values(1.0051, 1005, 105, 1.00051, 1001);
insert into ddl_0001 values(1.0061, 1006, 106, 1.00061, 1001);
insert into ddl_0001 values(1.0071, 1007, 107, 1.00071, 1001);
insert into ddl_0001 values(1.0081, 1008, 108, 1.00081, 1001);
insert into ddl_0001 values(1.0091, 1009, 109, 1.00091, 1001);

create index ddl_0001_idx6 on ddl_0001(col1 asc, col2 asc, col3 asc, col4 asc, col5 asc);

select * from ddl_0001 where col1 < 1.5 using index ddl_0001_idx6;
select * from ddl_0001 where col1 < 1.005 using index ddl_0001_idx6;

drop table ddl_0001;



CREATE TABLE "tpgtest"(
"seqno" integer AUTO_INCREMENT,
"pgcode" character varying(20) NOT NULL,
"currency" character varying(5) DEFAULT 'USD' NOT NULL,
"payamt" numeric(15,0) NOT NULL,
"cashreal" numeric(15,0) DEFAULT 0 NOT NULL,
"cashbonus" numeric(15,0) DEFAULT 0 NOT NULL,
CONSTRAINT pk_tpgtest_seqno PRIMARY KEY("seqno")
);
CREATE INDEX "cidx_tpgtest_pgcode" ON "tpgtest"("pgcode","currency","payamt");

insert into tpgtest(pgcode, currency, payamt, cashreal, cashbonus) values('PAYPAL', 'C', 5, 50, 0);
insert into tpgtest(pgcode, currency, payamt, cashreal, cashbonus) values('PAYPAL', 'C', 50, 500, 0);

select pgcode, currency, payamt from tpgtest
where payamt = 5.0 and currency = 'C' and pgcode = 'PAYPAL';

select pgcode, currency, payamt from tpgtest
where payamt = 5 and currency = 'C' and pgcode = 'PAYPAL'; 

select pgcode, currency, payamt from tpgtest
where payamt > 5.000000001 and currency = 'C' and pgcode = 'PAYPAL';

drop table tpgtest;
