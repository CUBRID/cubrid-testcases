create table i (a int, b int, c int, d int);

insert into i values (1, 1, 1, 1);
insert into i values (1, 1, 2, 2);
insert into i values (1, 1, 3, 3);
insert into i values (1, 1, 4, 4);

create unique index idx on i (a, b, c desc);
alter table i add primary key (a, b, c );

select a, b, c from i where a > 0 using index pk_i_a_b_c;

drop table i;
