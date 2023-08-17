-- reproduce bug chk for CBRD-24928
set system parameters 'deduplicate_key_level=3';
set system parameters 'print_index_detail=y';

drop table if exists dk_t2, dk_t3, dk_t1;
create table dk_t1(id1 int, id2 int, PRIMARY KEY (id1, id2));
create table dk_t2(id1 int primary key, id2 int, v int, foreign key (id1, id2) references dk_t1);
create table dk_t3(id1 int primary key, id2 int, v int);
alter table dk_t3 add foreign key fk1(id1, id2) references dk_t1;

show create table dk_t2;

set system parameters 'deduplicate_key_level=-1';
set system parameters 'print_index_detail=n';
