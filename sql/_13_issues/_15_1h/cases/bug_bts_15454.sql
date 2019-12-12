--+ holdcas on;
get optimization cost 'nl-join' into :default_iscan;
drop class if exists B,A,dummy;
create class B (bn int);
create class A (ab B, an int);
insert into B values (10) to :b0;       --   1
insert into B values (20) to :b1;       --   2
insert into B select * from B;          --   4
insert into B select * from B;          --   8
insert into B select * from B;          --  16
insert into B select * from B;          --  32
insert into B select * from B;          --  64
insert into B select * from B;          -- 128
insert into A values (:b0, 100) to :a0;
create class dummy
        method class set_cost(string, string)
                function qo_set_cost;
call set_cost('nl-join', '0') on class dummy;
update statistics on A, B;
select an, ab.bn from A;

drop class if exists atype,wwidget,tvalue,titem;
create class atype (code integer, description char varying);
insert into atype (code,description) values (1,'Valid') into :valid_value ;
insert into atype (code,description) values (2,'Error') into :error_value ;
insert into atype (code,description) values (3,'NULL')  into :null_value ;
insert into atype (code,description) values (4,'Min')   into :min_value ;
insert into atype (code,description) values (5,'Max')   into :max_value ;
create class wwidget (id char varying);
alter class wwidget add attribute components set (wwidget) default {};
insert into wwidget (id) values('Main-1') into :m1;
insert into wwidget (id) values('Y1') into :yy1;
insert into wwidget (id) values('Y2') into :yy2;
update wwidget set components = components + {:yy1,yy2} where wwidget = :m1 ;
select x.id from wwidget, table(components) as t(x) where wwidget = :m1 order by 1;
create class tvalue 
  (ttype atype, 
   dvalue  char varying);
insert into tvalue (ttype,dvalue) values (:valid_value, '1' )   into :a1 ;
insert into tvalue (ttype,dvalue) values (:error_value, '-1' )  into :a2 ;
insert into tvalue (ttype,dvalue) values (:null_value,  'NULL') into :a3 ;
insert into tvalue (ttype,dvalue) values (:min_value,   '0' )   into :a4 ;
insert into tvalue (ttype,dvalue) values (:max_value,   '100')  into :a5 ;
create class titem 
  (wwidget wwidget, 
   tvalues set(tvalue) );
insert into titem (wwidget,tvalues) values(:yy1,{:a1,:a2,:a3,:a4,:a5}) into :t1;
insert into titem (wwidget,tvalues) values(:yy2,{:a1,:a2,:a3,:a4,:a5}) into :t2;
select wwidget into :main from wwidget where id = 'Main-1';
select atype into :value1 from atype where code = 1;
select * from wwidget where wwidget = :main ;
select ti0.wwidget.id, a0.dvalue 
  from titem ti0,table(ti0.tvalues) as tv0(a0) 
  where ti0.wwidget = :yy1 AND a0.ttype = :value1;
select 
  w.id,x0.id,
  a0.dvalue
 from
    wwidget w, table(components) as t0(x0)
   ,titem ti0, table(ti0.tvalues) as tv0(a0)
 where
   w = :main
and x0 = :yy1
 AND
  ti0.wwidget = :yy1 AND a0.ttype = :value1;
--set optimization level 0;
select 
  w.id,x0.id,
  a0.dvalue
 from
    wwidget w, table(components) as t0(x0)
   ,titem ti0, table(ti0.tvalues) as tv0(a0)
 where
   w = :main
and x0 = :yy1
 AND
  ti0.wwidget = :yy1 AND a0.ttype = :value1;
drop class if exists B,A,dummy;
drop class if exists atype,wwidget,tvalue,titem;

drop table if exists a,b,dummy;
create table a (i int);
insert into a values (1);
select a into :var from a;
create table b (j int, aa a);
insert into b select i, a from a;

-- The default plan generated for the following query does not crash
select b.aa.i from b where b.aa = :var;

-- Now we assign zero cost to nested loop join
create class dummy method class set_cost(string, string) function qo_set_cost;
call set_cost('nl-join', '0') on class dummy;

--re-run the query; we get crash
select b.aa.i from b where b.aa = :var;

drop table if exists a,b,dummy;
set optimization cost 'nl-join' :default_iscan;

--+ holdcas off;
