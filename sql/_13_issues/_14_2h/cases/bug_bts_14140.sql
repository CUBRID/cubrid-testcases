--+ holdcas on;
create table test4 (col_short short);
insert into test4 values(2);

select col_short into :val_short from test4;
select :val_short from test4;

drop table test4;
--+ holdcas off;
commit;
