--+ holdcas on;
set system parameters 'ansi_quotes=no';

create table "t1";

create table a (a varchar(10));
insert into a values ("abcd");

select * from a where a="abcd";

drop table a;
set system parameters 'ansi_quotes=yes';commit;
--+ holdcas off;
