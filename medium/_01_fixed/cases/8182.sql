autocommit off;
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
select x.id from wwidget, table(components) as t(x) where wwidget = :m1 ;
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
rollback;
