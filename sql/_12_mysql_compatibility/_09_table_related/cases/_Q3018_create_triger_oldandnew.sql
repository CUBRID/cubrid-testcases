--+ holdcas on;
set system parameters 'compat_mode=mysql';

create table s25_a(id int primary key, a int);
create table s25_b(id int primary key, a_old int, a_new int);
create trigger s25_a_tri before update on s25_a execute insert into s25_b values (old.id, old.a, new.a);
drop trigger s25_a_tri;
drop table s25_a;
drop table s25_b;
create table s25_a(id int primary key, a int);
create table s25_b(id int primary key, a_old int, a_new int);
create trigger s25_a_tri before update on s25_a execute insert into s25_b values (old.id, old.a, new.a);
drop trigger s25_a_tri;
drop table s25_a;
drop table s25_b;


set system parameters 'compat_mode=cubrid';
commit;
--+ holdcas off;
