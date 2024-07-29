-- Problem where nodes without a join relationship are connected and incorrect results are output.

-- check join operation order in the plan. 
-- check the result.  
   -- The result count of 1 before modifed was 4, which should be 2 in this case. 

-- check the Join graph nodes section in the plan.
   -- The right_dep_set is removed and the dummy_join_term is not generated.

drop table if exists tbla;
drop table if exists tblb;
drop table if exists tblc;
drop table if exists tbld;
drop table if exists tble;
drop table if exists tblf;

create table tbla(
	proj_rqst_no         CHARACTER VARYING
	,busi_cls             CHARACTER VARYING
);
insert into tbla select ROWNUM,ROWNUM from db_class a, db_class b, db_class c limit 2;

create table tblb(
     busi_cd              CHARACTER VARYING
);
insert into tblb select ROWNUM from db_class a, db_class b, db_class c limit 2;

create table tblc(
     rqst_no              CHARACTER VARYING
);
insert into tblc select ROWNUM from db_class a, db_class b, db_class c limit 1000;

create table tbld(
     rqst_no              CHARACTER VARYING
     ,aprov_stat           CHARACTER VARYING 
);
insert into tbld select ROWNUM ,ROWNUM from db_class a, db_class b, db_class c limit 2;

create table tble(
     comm_cd              CHARACTER VARYING
);
insert into tble select ROWNUM from db_class a, db_class b, db_class c limit 2;

create table tblf(
     busi_cd              CHARACTER VARYING 
);
insert into tblf select ROWNUM from db_class a, db_class b, db_class c limit 2;

UPDATE STATISTICS ON tbla,tblb,tblc,tbld,tble,tblf;

select 'The result count of 1 before modification was 4, which should have been 2. Check the join operation order in the plan.' as TEST;

set trace on;

select /*+ RECOMPILE */
    1 as result
from
    tbla A
    inner join tblb E on A.BUSI_CLS = E.BUSI_CD
    left outer join tblc H on A.PROJ_RQST_NO = H.RQST_NO
    inner join tbld F on H.RQST_NO = F.RQST_NO
    left outer join tble G on F.APROV_STAT = G.COMM_CD
    inner join tblf Z on E.BUSI_CD = Z.BUSI_CD;

show trace;
set trace off;

drop table tblb;
drop table tbld;

create table tblb(col1 int, col2 int);
create table tbld(col1 int, col2 int);

insert into tblb values(1,1);
insert into tblb values(2,2);

insert into tbld values(1,1);
insert into tbld values(2,2);

--left outer join
select /*+ recompile */ * from tblb a left outer join tbld b on a.col1 =4;
select /*+ recompile */ * from tblb a left outer join tbld b on a.col1 =b.col1;
select /*+ recompile */ * from tblb a left outer join tbld b on a.col1 =4 left outer join tbld c on a.col1 = c.col1;
select /*+ recompile */ * from tblb a left outer join tbld b on a.col1 =4 left outer join tbld c on b.col1 = c.col1;
select /*+ recompile */ * from tblb a left outer join tbld b on a.col1 =4 left outer join tbld c on c.col1 = 4;

--right outer join
select /*+ recompile */ * from tblb a right outer join tbld b on a.col1 =4;
select /*+ recompile */ * from tblb a right outer join tbld b on a.col1 =b.col1;
select /*+ recompile */ * from tblb a left outer join tbld b on a.col1 =4 right outer join tbld c on a.col1 = c.col1;
select /*+ recompile */ * from tblb a left outer join tbld b on a.col1 =4 right outer join tbld c on b.col1 = c.col1;
select /*+ recompile */ * from tblb a left outer join tbld b on a.col1 =4 right outer join tbld c on c.col1 = 4;
select /*+ recompile */ * from tblb a inner join tbld b on a.col1 = b.col1 right outer join tbld c on a.col1 = c.col1;
select /*+ recompile */ * from tblb a left outer join tbld b on a.col1 =b.col1 right outer join tbld c on b.col1 = c.col1;

select 'check the Join graph nodes section in the plan.	The right_dep_set is removed and the dummy_join_term is not generated.' as TEST;

--@joingraph
select /*+ recompile */ * from tblb a inner join tbld b on a.col1 = b.col1 
			           inner join tbld e on a.col1 = e.col1 
                                               inner join tbld c on a.col1 = c.col1 
                                               right outer join tbld d on a.col1 = d.col1;

--@joingraph
select /*+ recompile */ * from tblb a inner join tbld b on a.col1 = b.col1 
			           inner join tbld e on b.col1 = e.col1 
                                               inner join tbld c on b.col1 = c.col1 
                                               right outer join tbld d on a.col1 = d.col1;

--inner join
select /*+ recompile */ * from tblb a inner join tbld b on a.col1 =4;
select /*+ recompile */ * from tblb a inner join tbld b on a.col1 =4 right outer join tbld c on a.col1 = c.col1;
select /*+ recompile */ * from tblb a inner join tbld b on a.col1 =4 left outer join tbld c on a.col1 = c.col1;
select /*+ recompile */ * from tblb a inner join tbld b on a.col1 =4 right outer join tbld c on a.col1 = c.col1 inner join tbld d on c.col1 = d.col1 left outer join tbld e on e.col1 = 4;

drop table tbla;
drop table tblb;
drop table tblc;
drop table tbld;
drop table tble;
drop table tblf;
