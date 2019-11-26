--+ holdcas on;
autocommit off;
create class iCaSe (sTr string);
alter iCaSE add attribute ixi int;
insert into iCAsE(sTr, iXI) values('one', 2);
select StR, Ixi from icASE;
select str, IXi from ICASe;
select STR into lbl from IcAsE where ixI = 2;
select iXi from iCAse where Str = LBL;
alter icase drop attribute STR;
alter ICASE drop attribute IXI;
rollback work;
rollback;

--+ holdcas off;
