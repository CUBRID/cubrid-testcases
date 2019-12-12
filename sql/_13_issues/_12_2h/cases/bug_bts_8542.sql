drop table if exists tbl1,tbl2;
CREATE TABLE tbl1 (a int);
CREATE TABLE tbl2 (a int);
 
SELECT typo_here
FROM
(SELECT a,
(SELECT count(*)
FROM tbl1 t1
WHERE t1.a = ttt.a)
FROM tbl2 ttt);
    
drop table if exists tbl1,tbl2;

drop table if exists test_in,test_an,test_ainfo;

CREATE TABLE test_in (
   in_seq smallint,
   agnt_id character varying(8),
   dt1 datetime,
   dt2 datetime,
   id2 character varying(8),
   c1 character varying(1073741823),
   c2 character varying(20),
   bef_agnt_id character varying(8),
   c3 character varying(4000),
   in_id character varying(22)
);

CREATE TABLE test_an (
   in_seq smallint,
   id2 character varying(8),
   c1 character varying(300),
   c2 character varying(20),
   s1 smallint,
   cre_dt datetime,
   cont1 character varying(1073741823),
   c3 character varying(20),
   in_id character varying(22)
);

CREATE TABLE test_ainfo (
       agntid character varying(8),
       empno character varying(7),
       c1 character varying(20),
       c2 character varying(8),
       c3 character varying(8),
       c4 character varying(20),
       c5 character varying(4),
       c6 character varying(4),
       c7 character varying(4),
       c8 character varying(1),
       c9 character varying(2),
       c10 character varying(11),
       c11 character varying(15),
       c12 character varying(15),
       c13 character varying(8),
       c14 character varying(20),
       c15 character varying(20),
       c16 character varying(10),
       c17 character varying(100),
       c18 character varying(50),
       c19 character varying(5),
       c20 character varying(8),
       c21 character varying(8),
       c22 character varying(8),
       c23 character varying(4),
       c24 character varying(4),
       c25 character varying(4),
       c26 character varying(400),
       c27 character varying(1),
       dt1 datetime,
       id2 character varying(8),
       dt2 datetime,
       id3 character varying(8),
       c28 character varying(20),
       c29 character varying(1),
       c30 character varying(8),
       c31 character varying(1),
       c32 character varying(10),
       c33 character varying(8),
       c34 character varying(8),
       c35 character varying(8),
       c36 character varying(2),
       dt3 datetime
);

select t2agnt_id, sum(decode(t2.mailnotprgss,0,1,0)) as mailnotprgss
		  from (
				select agnt_id,  (select count(*) from test_an t2 where t2.IN_ID=t1.IN_ID and t2.IN_SEQ=t1.IN_SEQ) as mailnotprgss
				  from test_in t1
				 where agnt_id is not null
				   and cre_dt between sysdate-10 and sysdate
				   and agnt_id in ( select agntid from test_ainfo where svccd='O' and chnldiv='M')
		       ) t2
		 group by agnt_id;

drop table if exists test_in,test_an,test_ainfo;
