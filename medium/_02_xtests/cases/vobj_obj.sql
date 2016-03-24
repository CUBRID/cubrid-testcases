autocommit off;
create class eev1 (eev1_int int);
create class eev2 (eev2_ref1 eev1);
insert into eev2 values (NULL);
select eev2_ref1 from eev2;
insert into eev1 (eev1_int) values (0) to xx;
update eev2 set eev2_ref1=xx;

delete from eev1;
delete from eev2;
create vclass vev1 as select * from eev1;
create vclass vev2 as select * from eev2;
insert into vev2 values (NULL);
select eev2_ref1 from vev2;
insert into vev1 (eev1_int) values (0) to xx;
update vev2 set eev2_ref1=xx;

drop vev1, vev2;
drop eev1, eev2;
commit;
rollback;
