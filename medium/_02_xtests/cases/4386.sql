--+ holdcas on;
autocommit off;
create class ore_sample
(
 x_coord int,
 y_coord int,
 sample  int
);
create class fred
(
 jmb int,
 x set of ore_sample
);
insert into fred (jmb, x)
values (1, {});
insert into ore_sample (x_coord, y_coord, sample)
values (1, 2, 3);
insert into ore_sample (x_coord, y_coord, sample)
values (4, 5, 6);
insert into ore_sample (x_coord, y_coord, sample)
values (7, 8, 9);
insert into ore_sample (x_coord, y_coord, sample)
values (10, 11, 12);
insert into ore_sample (x_coord, y_coord, sample)
values (13, 14, 15);
insert into ore_sample (x_coord, y_coord, sample)
values (16, 17, 18);
select x into :temp_set from fred where jmb = 1;
select b from table(:temp_set) as t(b);
select set(select x from ore_sample x) into :temp_set from ore_sample y where y.x_coord = 1;
select b{o}.x_coord, b{o}.y_coord, b{o}.sample 
from table(temp_set) as t(b), ore_sample o;       
rollback;

--+ holdcas off;
