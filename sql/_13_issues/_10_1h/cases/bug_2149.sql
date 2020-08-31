set system parameters 'create_table_reuseoid=no';
create class a (i int primary key);
insert into a values (1);
insert into a values (2);

create class b (i int primary key, pk_ref a);
insert into b( i ) values (1);
insert into b( i ) values (2);

alter class b add constraint fk_i foreign key( i ) references a( i );

create class c (i int, pk_ref a);
insert into c( i ) values (1);
insert into c( i ) values (1);
insert into c( i ) values (NULL);
insert into c( i ) values (2);

alter class c add constraint fk_i foreign key( i ) references a( i );

select * from b order by i;
select i from b order by i;

select * from c order by i;
select i  from c order by i;

drop table c;
drop table b;
drop table a;
set system parameters 'create_table_reuseoid=yes';
