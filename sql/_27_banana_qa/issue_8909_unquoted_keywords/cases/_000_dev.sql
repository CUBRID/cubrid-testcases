--test case provided by dev

DROP TABLE IF EXISTS tbl;

CREATE TABLE tbl(
  "int" integer,
  "none" integer, 
  col1 integer NOT NULL UNIQUE,
  CONSTRAINT pk_tbl_id PRIMARY KEY("int")
);

insert into tbl("int", "none", col1) values(1, 2, 3);

select t.
   int, t.   none
   , t.    col1 , t->   int , t->
     None , t->  col1, t.   "int",
t.[NONE], t.`Col1`, t->[int], t->`NONE`, t->"Col1", t.* from tbl t;

select * from tbl t where t.int=1 using index t.pk_tbl_id;
select * from tbl t where t.int=1 using index t.pk_tbl_id(+);
select * from tbl t where t.int=1 using index t.pk_tbl_id(-);

select * from tbl t where t.int=1 using index t."pk_tbl_id";
select * from tbl t where t.int=1 using index t."pk_tbl_id"(+);
select * from tbl t where t.int=1 using index t."pk_tbl_id"(-);

select * from tbl t where t.int=1 using index t.none;
select * from tbl t where t.int=1 using index t.none(+);
select * from tbl t where t.int=1 using index t.none(-);

select * from tbl t where t.int=1 using index t.NONE;
select * from tbl t where t.int=1 using index t.NONE(+);
select * from tbl t where t.int=1 using index t.NONE(-);

select * from tbl t where t.int=1 using index t."none";
select * from tbl t where t.int=1 using index t."none"(+);
select * from tbl t where t.int=1 using index t."none"(-);

DROP TABLE IF EXISTS tbl;
