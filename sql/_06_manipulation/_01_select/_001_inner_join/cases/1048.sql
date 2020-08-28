set system parameters 'create_table_reuseoid=no';
-- tests complex select with 32 indexes.

create class xoo ( ABS int, AUDIT int, AUTHORIZATION int, CEIL int, CHAR_LENGTH int, CHR int, DECODE int, DECRYPT int, ENCRYPT int, FLOOR int, GE_INF int, GE_LE int, GE_LT int, GREATEST int, GROUPBY_NUM int, GT_INF int, GT_LE int, GT_LT int, INCREMENT int, INF_LE int, INF_LT int, INSTR int, INSTRB int, INST_NUM int, LAST_DAY int, LEAST int, LENGTH int, LENGTHB int, LPAD int, LTRIM int, MAXVALUE int, MINVALUE int, MONTHS_BETWEEN int, "NOCYCLE" int, NOMAXVALUE int, NOMINVALUE int, NVL int, NVL2 int, ORDERBY_NUM int, POWER int, ROUND int, RPAD int, RTRIM int, SERIAL int, SIGN int, START int, STDDEV int, SUBSTR int, SUBSTRB int, SWITCH int, SYSTEM int, TO_CHAR int, TO_DATE int, TO_NUMBER int, TO_TIME int, TO_TIMESTAMP int, TRUNC int, VARIANCE int); 
create class yoo ( ABS string, AUDIT int, AUTHORIZATION string, CEIL int, CHAR_LENGTH string, CHR int, DECODE string, DECRYPT int, ENCRYPT string, FLOOR int, GE_INF string, GE_LE int, GE_LT string, GREATEST int, GROUPBY_NUM string, GT_INF int, GT_LE string, GT_LT int, INCREMENT string, INF_LE int, INF_LT string, INSTR int, INSTRB string, INST_NUM int, LAST_DAY string, LEAST int, LENGTH string, LENGTHB int, LPAD string, LTRIM int, MAXVALUE string, MINVALUE int, MONTHS_BETWEEN string, "NOCYCLE" int, NOMAXVALUE string, NOMINVALUE int, NVL string, NVL2 int, ORDERBY_NUM string, POWER int, ROUND string, RPAD int, RTRIM string, SERIAL int, SIGN string, START int, STDDEV string, SUBSTR int, SUBSTRB string, SWITCH int, SYSTEM string, TO_CHAR int, TO_DATE string, TO_NUMBER int, TO_TIME string, TO_TIMESTAMP int, TRUNC string, VARIANCE int); 
create class zoo ( ABS string, AUDIT string, AUTHORIZATION string, CEIL string, CHAR_LENGTH string, CHR string, DECODE string, DECRYPT string, ENCRYPT string, FLOOR string, GE_INF string, GE_LE string, GE_LT string, GREATEST string, GROUPBY_NUM string, GT_INF string, GT_LE string, GT_LT string, INCREMENT string, INF_LE string, INF_LT string, INSTR string, INSTRB string, INST_NUM string, LAST_DAY string, LEAST string, LENGTH string, LENGTHB string, LPAD string, LTRIM string, MAXVALUE string, MINVALUE string, MONTHS_BETWEEN string, "NOCYCLE" string, NOMAXVALUE string, NOMINVALUE string, NVL string, NVL2 string, ORDERBY_NUM string, POWER string, ROUND string, RPAD string, RTRIM string, SERIAL string, SIGN string, START string, STDDEV string, SUBSTR string, SUBSTRB string, SWITCH string, SYSTEM string, TO_CHAR string, TO_DATE string, TO_NUMBER string, TO_TIME string, TO_TIMESTAMP string, TRUNC string, VARIANCE string); 

create index idx1 on xoo (ABS,AUDIT,AUTHORIZATION,CEIL,CHAR_LENGTH,CHR,DECODE,DECRYPT,ENCRYPT,FLOOR,GE_INF,GE_LE,GE_LT,GREATEST,GROUPBY_NUM,GT_INF,GT_LE,GT_LT,INCREMENT,INF_LE,INF_LT,INSTR,INSTRB,INST_NUM,LAST_DAY,LEAST,LENGTH,LENGTHB,LPAD,LTRIM,MAXVALUE,MINVALUE,MONTHS_BETWEEN,"NOCYCLE",NOMAXVALUE,NOMINVALUE,NVL,NVL2,ORDERBY_NUM,POWER,ROUND,RPAD,RTRIM,SERIAL,SIGN,START,STDDEV,SUBSTR,SUBSTRB,SWITCH,SYSTEM,TO_CHAR,TO_DATE,TO_NUMBER,TO_TIME,TO_TIMESTAMP,TRUNC,VARIANCE) ;
create index idx2 on yoo (ABS,AUDIT,AUTHORIZATION,CEIL,CHAR_LENGTH,CHR,DECODE,DECRYPT,ENCRYPT,FLOOR,GE_INF,GE_LE,GE_LT,GREATEST,GROUPBY_NUM,GT_INF,GT_LE,GT_LT,INCREMENT,INF_LE,INF_LT,INSTR,INSTRB,INST_NUM,LAST_DAY,LEAST,LENGTH,LENGTHB,LPAD,LTRIM,MAXVALUE,MINVALUE,MONTHS_BETWEEN,"NOCYCLE",NOMAXVALUE,NOMINVALUE,NVL,NVL2,ORDERBY_NUM,POWER,ROUND,RPAD,RTRIM,SERIAL,SIGN,START,STDDEV,SUBSTR,SUBSTRB,SWITCH,SYSTEM,TO_CHAR,TO_DATE,TO_NUMBER,TO_TIME,TO_TIMESTAMP,TRUNC,VARIANCE) ;
create index idx3 on zoo (ABS,AUDIT,AUTHORIZATION,CEIL,CHAR_LENGTH,CHR,DECODE,DECRYPT,ENCRYPT,FLOOR,GE_INF,GE_LE,GE_LT,GREATEST,GROUPBY_NUM,GT_INF,GT_LE,GT_LT,INCREMENT,INF_LE,INF_LT,INSTR,INSTRB,INST_NUM,LAST_DAY,LEAST,LENGTH,LENGTHB,LPAD,LTRIM,MAXVALUE,MINVALUE,MONTHS_BETWEEN,"NOCYCLE",NOMAXVALUE,NOMINVALUE,NVL,NVL2,ORDERBY_NUM,POWER,ROUND,RPAD,RTRIM,SERIAL,SIGN,START,STDDEV,SUBSTR,SUBSTRB,SWITCH,SYSTEM,TO_CHAR,TO_DATE,TO_NUMBER,TO_TIME,TO_TIMESTAMP,TRUNC,VARIANCE) ;

create reverse index ridx1 on xoo (ABS,AUDIT,AUTHORIZATION,CEIL,CHAR_LENGTH,CHR,DECODE,DECRYPT,ENCRYPT,FLOOR,GE_INF,GE_LE,GE_LT,GREATEST,GROUPBY_NUM,GT_INF,GT_LE,GT_LT,INCREMENT,INF_LE,INF_LT,INSTR,INSTRB,INST_NUM,LAST_DAY,LEAST,LENGTH,LENGTHB,LPAD,LTRIM,MAXVALUE,MINVALUE,MONTHS_BETWEEN,"NOCYCLE",NOMAXVALUE,NOMINVALUE,NVL,NVL2,ORDERBY_NUM,POWER,ROUND,RPAD,RTRIM,SERIAL,SIGN,START,STDDEV,SUBSTR,SUBSTRB,SWITCH,SYSTEM,TO_CHAR,TO_DATE,TO_NUMBER,TO_TIME,TO_TIMESTAMP,TRUNC,VARIANCE) ;
create reverse index ridx2 on yoo (ABS,AUDIT,AUTHORIZATION,CEIL,CHAR_LENGTH,CHR,DECODE,DECRYPT,ENCRYPT,FLOOR,GE_INF,GE_LE,GE_LT,GREATEST,GROUPBY_NUM,GT_INF,GT_LE,GT_LT,INCREMENT,INF_LE,INF_LT,INSTR,INSTRB,INST_NUM,LAST_DAY,LEAST,LENGTH,LENGTHB,LPAD,LTRIM,MAXVALUE,MINVALUE,MONTHS_BETWEEN,"NOCYCLE",NOMAXVALUE,NOMINVALUE,NVL,NVL2,ORDERBY_NUM,POWER,ROUND,RPAD,RTRIM,SERIAL,SIGN,START,STDDEV,SUBSTR,SUBSTRB,SWITCH,SYSTEM,TO_CHAR,TO_DATE,TO_NUMBER,TO_TIME,TO_TIMESTAMP,TRUNC,VARIANCE) ;
create reverse index ridx3 on zoo (ABS,AUDIT,AUTHORIZATION,CEIL,CHAR_LENGTH,CHR,DECODE,DECRYPT,ENCRYPT,FLOOR,GE_INF,GE_LE,GE_LT,GREATEST,GROUPBY_NUM,GT_INF,GT_LE,GT_LT,INCREMENT,INF_LE,INF_LT,INSTR,INSTRB,INST_NUM,LAST_DAY,LEAST,LENGTH,LENGTHB,LPAD,LTRIM,MAXVALUE,MINVALUE,MONTHS_BETWEEN,"NOCYCLE",NOMAXVALUE,NOMINVALUE,NVL,NVL2,ORDERBY_NUM,POWER,ROUND,RPAD,RTRIM,SERIAL,SIGN,START,STDDEV,SUBSTR,SUBSTRB,SWITCH,SYSTEM,TO_CHAR,TO_DATE,TO_NUMBER,TO_TIME,TO_TIMESTAMP,TRUNC,VARIANCE) ;


insert into xoo values(
1,1,1,1,1,1,1,1,1,1,
1,1,1,1,1,1,1,1,1,1,
1,1,1,1,1,1,1,1,1,1,
1,1,1,1,1,1,1,1,1,1,
1,1,1,1,1,1,1,1,1,1,
1,1,1,1,1,1,1,1 );

insert into xoo values(
2,2,2,2,2,2,2,2,2,2,
2,2,2,2,2,2,2,2,2,2,
2,2,2,2,2,2,2,2,2,2,
2,2,2,2,2,2,2,2,2,2,
2,2,2,2,2,2,2,2,2,2,
2,2,2,2,2,2,2,2 );

insert into yoo values(
'1',1,'1',1,'1',1,'1',1,'1',1,
'1',1,'1',1,'1',1,'1',1,'1',1,
'1',1,'1',1,'1',1,'1',1,'1',1,
'1',1,'1',1,'1',1,'1',1,'1',1,
'1',1,'1',1,'1',1,'1',1,'1',1,
'1',1,'1',1,'1',1,'1',1 ); 

insert into yoo values(
'2',2,'2',2,'2',2,'2',2,'2',2,
'2',2,'2',2,'2',2,'2',2,'2',2,
'2',2,'2',2,'2',2,'2',2,'2',2,
'2',2,'2',2,'2',2,'2',2,'2',2,
'2',2,'2',2,'2',2,'2',2,'2',2,
'2',2,'2',2,'2',2,'2',2 );  

insert into zoo values(            
'1','1','1','1','1','1','1','1','1','1', 
'1','1','1','1','1','1','1','1','1','1',  
'1','1','1','1','1','1','1','1','1','1', 
'1','1','1','1','1','1','1','1','1','1', 
'1','1','1','1','1','1','1','1','1','1', 
'1','1','1','1','1','1','1','1');        

insert into zoo values(                          
'2','2','2','2','2','2','2','2','2','2',
'2','2','2','2','2','2','2','2','2','2',
'2','2','2','2','2','2','2','2','2','2',
'2','2','2','2','2','2','2','2','2','2',
'2','2','2','2','2','2','2','2','2','2',
'2','2','2','2','2','2','2','2');    

select * from xoo where ABS  = 1 and AUDIT  = 1 and AUTHORIZATION  = 1 and CEIL  = 1 and CHAR_LENGTH  = 1 and CHR  = 1 and DECODE  = 1 and DECRYPT  = 1 and ENCRYPT  = 1 and FLOOR  = 1 and GE_INF  = 1 and GE_LE  = 1 and GE_LT  = 1 and GREATEST  = 1 and GROUPBY_NUM  = 1 and GT_INF  = 1 and GT_LE  = 1 and GT_LT  = 1 and INCREMENT  = 1 and INF_LE  = 1 and INF_LT  = 1 and INSTR  = 1 and INSTRB  = 1 and INST_NUM  = 1 and LAST_DAY  = 1 and LEAST  = 1 and LENGTH  = 1 and LENGTHB  = 1 and LPAD  = 1 and LTRIM  = 1 and MAXVALUE  = 1 and MINVALUE  = 1 and MONTHS_BETWEEN  = 1 and "NOCYCLE"  = 1 and NOMAXVALUE  = 1 and NOMINVALUE  = 1 and NVL  = 1 and NVL2  = 1 and ORDERBY_NUM  = 1 and POWER  = 1 and ROUND  = 1 and RPAD  = 1 and RTRIM  = 1 and SERIAL  = 1 and SIGN  = 1 and START  = 1 and STDDEV  = 1 and SUBSTR  = 1 and SUBSTRB  = 1 and SWITCH  = 1 and SYSTEM  = 1 and TO_CHAR  = 1 and TO_DATE  = 1 and TO_NUMBER  = 1 and TO_TIME  = 1 and TO_TIMESTAMP  = 1 and TRUNC  = 1 and VARIANCE  = 1 using index idx1;
select * from yoo where ABS  = '1' and AUDIT  = 1 and AUTHORIZATION  = '1' and CEIL  = 1 and CHAR_LENGTH  = '1' and CHR  = 1 and DECODE  = '1'  and DECRYPT  = 1 and ENCRYPT  = '1' and FLOOR  = 1 and GE_INF  = '1' and GE_LE  = 1 and GE_LT  = '1' and GREATEST  = 1 and GROUPBY_NUM  = '1' and GT_INF  = 1 and GT_LE  = '1' and GT_LT  = 1 and INCREMENT  = '1' and INF_LE  = 1 and INF_LT  = '1' and INSTR  = 1 and INSTRB  = '1' and INST_NUM  = 1 and LAST_DAY  = '1' and LEAST  = 1 and LENGTH  = '1' and LENGTHB  = 1 and LPAD  = '1' and LTRIM  = 1 and MAXVALUE  = '1' and MINVALUE  = 1 and MONTHS_BETWEEN  = '1' and "NOCYCLE"  = 1 and NOMAXVALUE  = '1' and NOMINVALUE  = 1 and NVL  = '1' and NVL2  = 1 and ORDERBY_NUM  = '1' and POWER  = 1 and ROUND  = '1' and RPAD  = 1 and RTRIM  = '1' and SERIAL  = 1 and SIGN  = '1' and START  = 1 and STDDEV  = '1' and SUBSTR  = 1 and SUBSTRB  = '1' and SWITCH  = 1 and SYSTEM  = '1' and TO_CHAR  = 1 and TO_DATE  = '1' and TO_NUMBER  = 1 and TO_TIME  = '1' and TO_TIMESTAMP  = 1 and TRUNC  = '1' and VARIANCE  = 1 using index idx2;
select * from zoo where ABS  = '1' and AUDIT  = '1' and AUTHORIZATION  = '1' and CEIL  = '1' and CHAR_LENGTH  = '1' and CHR  = '1' and DECODE  = '1' and DECRYPT  = '1' and ENCRYPT  = '1' and FLOOR  = '1' and GE_INF  = '1' and GE_LE  = '1' and GE_LT  = '1' and GREATEST  = '1' and GROUPBY_NUM  = '1' and GT_INF  = '1' and GT_LE  = '1' and GT_LT  = '1' and INCREMENT  = '1' and INF_LE  = '1' and INF_LT  = '1' and INSTR  = '1' and INSTRB  = '1' and INST_NUM  = '1' and LAST_DAY  = '1' and LEAST  = '1' and LENGTH  = '1' and LENGTHB  = '1' and LPAD  = '1' and LTRIM  = '1' and MAXVALUE  = '1' and MINVALUE  = '1' and MONTHS_BETWEEN  = '1' and "NOCYCLE"  = '1' and NOMAXVALUE  = '1' and NOMINVALUE  = '1' and NVL  = '1' and NVL2  = '1' and ORDERBY_NUM  = '1' and POWER  = '1' and ROUND  = '1' and RPAD  = '1' and RTRIM  = '1' and SERIAL  = '1' and SIGN  = '1' and START  = '1' and STDDEV  = '1' and SUBSTR  = '1' and SUBSTRB  = '1' and SWITCH  = '1' and SYSTEM  = '1' and TO_CHAR  = '1' and TO_DATE  = '1' and TO_NUMBER  = '1' and TO_TIME  = '1' and TO_TIMESTAMP  = '1' and TRUNC  = '1' and VARIANCE  = '1' using index idx3;

select * from xoo where ABS  = 1 and AUDIT  = 1 and AUTHORIZATION  = 1 and CEIL  = 1 and CHAR_LENGTH  = 1 and CHR  = 1 and DECODE  = 1 and DECRYPT  = 1 and ENCRYPT  = 1 and FLOOR  = 1 and GE_INF  = 1 and GE_LE  = 1 and GE_LT  = 1 and GREATEST  = 1 and GROUPBY_NUM  = 1 and GT_INF  = 1 and GT_LE  = 1 and GT_LT  = 1 and INCREMENT  = 1 and INF_LE  = 1 and INF_LT  = 1 and INSTR  = 1 and INSTRB  = 1 and INST_NUM  = 1 and LAST_DAY  = 1 and LEAST  = 1 and LENGTH  = 1 and LENGTHB  = 1 and LPAD  = 1 and LTRIM  = 1 and MAXVALUE  = 1 and MINVALUE  = 1 and MONTHS_BETWEEN  = 1 and "NOCYCLE"  = 1 and NOMAXVALUE  = 1 and NOMINVALUE  = 1 and NVL  = 1 and NVL2  = 1 and ORDERBY_NUM  = 1 and POWER  = 1 and ROUND  = 1 and RPAD  = 1 and RTRIM  = 1 and SERIAL  = 1 and SIGN  = 1 and START  = 1 and STDDEV  = 1 and SUBSTR  = 1 and SUBSTRB  = 1 and SWITCH  = 1 and SYSTEM  = 1 and TO_CHAR  = 1 and TO_DATE  = 1 and TO_NUMBER  = 1 and TO_TIME  = 1 and TO_TIMESTAMP  = 1 and TRUNC  = 1 and VARIANCE  = 1 using index ridx1;
select * from yoo where ABS  = '1' and AUDIT  = 1 and AUTHORIZATION  = '1' and CEIL  = 1 and CHAR_LENGTH  = '1' and CHR  = 1 and DECODE  = '1'  and DECRYPT  = 1 and ENCRYPT  = '1' and FLOOR  = 1 and GE_INF  = '1' and GE_LE  = 1 and GE_LT  = '1' and GREATEST  = 1 and GROUPBY_NUM  = '1' and GT_INF  = 1 and GT_LE  = '1' and GT_LT  = 1 and INCREMENT  = '1' and INF_LE  = 1 and INF_LT  = '1' and INSTR  = 1 and INSTRB  = '1' and INST_NUM  = 1 and LAST_DAY  = '1' and LEAST  = 1 and LENGTH  = '1' and LENGTHB  = 1 and LPAD  = '1' and LTRIM  = 1 and MAXVALUE  = '1' and MINVALUE  = 1 and MONTHS_BETWEEN  = '1' and "NOCYCLE"  = 1 and NOMAXVALUE  = '1' and NOMINVALUE  = 1 and NVL  = '1' and NVL2  = 1 and ORDERBY_NUM  = '1' and POWER  = 1 and ROUND  = '1' and RPAD  = 1 and RTRIM  = '1' and SERIAL  = 1 and SIGN  = '1' and START  = 1 and STDDEV  = '1' and SUBSTR  = 1 and SUBSTRB  = '1' and SWITCH  = 1 and SYSTEM  = '1' and TO_CHAR  = 1 and TO_DATE  = '1' and TO_NUMBER  = 1 and TO_TIME  = '1' and TO_TIMESTAMP  = 1 and TRUNC  = '1' and VARIANCE  = 1 using index ridx2;
select * from zoo where ABS  = '1' and AUDIT  = '1' and AUTHORIZATION  = '1' and CEIL  = '1' and CHAR_LENGTH  = '1' and CHR  = '1' and DECODE  = '1' and DECRYPT  = '1' and ENCRYPT  = '1' and FLOOR  = '1' and GE_INF  = '1' and GE_LE  = '1' and GE_LT  = '1' and GREATEST  = '1' and GROUPBY_NUM  = '1' and GT_INF  = '1' and GT_LE  = '1' and GT_LT  = '1' and INCREMENT  = '1' and INF_LE  = '1' and INF_LT  = '1' and INSTR  = '1' and INSTRB  = '1' and INST_NUM  = '1' and LAST_DAY  = '1' and LEAST  = '1' and LENGTH  = '1' and LENGTHB  = '1' and LPAD  = '1' and LTRIM  = '1' and MAXVALUE  = '1' and MINVALUE  = '1' and MONTHS_BETWEEN  = '1' and "NOCYCLE"  = '1' and NOMAXVALUE  = '1' and NOMINVALUE  = '1' and NVL  = '1' and NVL2  = '1' and ORDERBY_NUM  = '1' and POWER  = '1' and ROUND  = '1' and RPAD  = '1' and RTRIM  = '1' and SERIAL  = '1' and SIGN  = '1' and START  = '1' and STDDEV  = '1' and SUBSTR  = '1' and SUBSTRB  = '1' and SWITCH  = '1' and SYSTEM  = '1' and TO_CHAR  = '1' and TO_DATE  = '1' and TO_NUMBER  = '1' and TO_TIME  = '1' and TO_TIMESTAMP  = '1' and TRUNC  = '1' and VARIANCE  = '1' using index ridx3;

select * from xoo where ABS = 2 using index idx1;
select * from xoo where ABS = 3 using index idx1;

select * from yoo where ABS = '2' using index idx2;
select * from yoo where ABS = '3' using index idx2;

select * from zoo where ABS = '2' using index idx3;
select * from zoo where ABS = '3' using index idx3;

select * from xoo where ABS = 2 using index ridx1;
select * from xoo where ABS = 3 using index ridx1;

select * from yoo where ABS = '2' using index ridx2;
select * from yoo where ABS = '3' using index ridx2;

select * from zoo where ABS = '2' using index ridx3;
select * from zoo where ABS = '3' using index ridx3;



drop xoo;
drop yoo;
drop zoo;
set system parameters 'create_table_reuseoid=yes';
