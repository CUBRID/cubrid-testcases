--+ holdcas on;
set system parameters 'add_column_update_hard_default = yes';


create table father (i int);
create table son as subclass of father (j int) ;
create table nephew as subclass of son (k int);

insert into father(i) values (1), (2);
insert into son(j)    values (11), (12);
insert into nephew(k) values (111), (112);

alter class father add column trbl int not null;

-- should have updated the new column in all three tables
select * from father order by i;
select * from son order by j;
select * from nephew order by k;


drop class nephew;
drop class son;
drop class father;


set system parameters 'add_column_update_hard_default = no';
commit;
--+ holdcas off;
