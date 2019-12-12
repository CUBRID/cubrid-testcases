--+ holdcas on;
set system parameters 'add_column_update_hard_default = yes';

-- class attributes should not be initialized to hard defaults
create class t (i int);
insert into t values (1), (2);

alter class t add class attribute atr int;
select class t.atr from t;

drop class t;


-- foreign keys 1

create table cities(i int primary key, name string);
insert into cities values (1, 'Paris'), (2, 'Prague'), (3, 'Plescoi');

create table countries (x int);
insert into countries values (66), (67), (68);

-- this would result in a foreign key violation, so it must throw an error
-- because in the cities table there is no row with i = 0
alter table countries add column (city int not null, foreign key (city) references cities(i));


drop table countries;
drop table cities;


-- foreign keys 2: foreigh keys on the same table

create table t(i int);
insert into t values (1), (2);

-- should throw an error - unrelated
alter table t add column (reff int primary key not null, ch int not null, foreign key (ch) references t(reff));

-- should throw an erorr - on our part
alter table t add column (reff int primary key not null), add column (ch int not null, foreign key (ch) references t(reff));

-- go to cubrid mode
set system parameters 'add_column_update_hard_default = no';

-- retry the command - should work now
alter table t add column (reff int primary key not null), add column (ch int not null, foreign key (ch) references t(reff));
select * from t order by i;

-- go back to mysql compat mode
set system parameters 'add_column_update_hard_default = yes';


drop table t;


-- primary keys 1
create table t(i int);
insert into t values (1);

-- this should work, there's only one row in the database
alter table t add column (pk1 int, pk2 int, primary key(pk1, pk2));
select * from t order by i;
drop table t;

-- primary keys 2
create table t(i int);
insert into t values (1), (2);

-- this should FAIL, we have 2 columns in the database
alter table t add column (pk1 int, pk2 int, primary key(pk1, pk2));

-- now switch to cubrid mode and it should work
set system parameters 'add_column_update_hard_default = no';
alter table t add column (pk1 int, pk2 int, primary key(pk1, pk2));
select * from t order by i;

-- go back to mysql mode
set system parameters 'add_column_update_hard_default = yes';

drop table t;



set system parameters 'add_column_update_hard_default = no';
commit;
--+ holdcas off;
