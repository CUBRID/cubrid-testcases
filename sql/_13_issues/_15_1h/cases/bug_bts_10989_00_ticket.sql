drop table if exists fwnostz1;
drop table if exists fwnostz2;

CREATE TABLE fwnostz1 (
       "name" character(25), 
       aam integer,
       dhpt character(20),
       rank character(10))
;
CREATE TABLE fwnostz2 (
       mwvh2 character(25),
       aam integer,
       dhpt character(20),
       rank character(10))
;

CREATE OR REPLACE VIEW fwnostz;
ALTER VIEW fwnostz ADD ATTRIBUTE
       aam integer,
       gbjait character(0),
       fmwvh character(20),
       dhpt character(10),
       rank character(10);

ALTER VIEW fwnostz ADD QUERY select fwnostz1.aam+1,  cast('fwnostz1' as char(0)),  cast(fwnostz1."name" as char(20)),  cast(fwnostz1.dhpt as char(10)), fwnostz1.rank from fwnostz1 fwnostz1 ;
ALTER VIEW fwnostz ADD QUERY select fwnostz2.aam+2,  cast('fwnostz2' as char(0)),  cast(fwnostz2.mwvh2 as char(20)),  cast(fwnostz2.dhpt as char(10)), fwnostz2.rank from fwnostz2 fwnostz2 ;

create OR replace view boo as select * from fwnostz where aam > 5 with check option;
insert into boo(aam) values(1);

drop fwnostz1, fwnostz2, fwnostz, boo;
