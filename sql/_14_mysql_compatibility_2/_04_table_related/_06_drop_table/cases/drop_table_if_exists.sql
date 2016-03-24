create table dropt (i int);

drop table if exists dropt;

drop table dropt;

drop table if exists dropt;

create table t1 (i int);

create table t2 (i int);

drop table if exists t1, dropt, t2, t3;

drop table t1;

drop table t2;

drop table if exists t1, t2 ,t3;



create table animals (i int);

create table cows as subclass of animals;

create table dogs as subclass of animals;

create table lions as subclass of animals;

drop table if exists all animals;

drop table all animals;

drop table if exists all animals;


create table animals (i int);

create table cows as subclass of animals;

create table dogs as subclass of animals;

create table lions as subclass of animals;

drop table if exists only animals;

drop table only animals;

drop table if exists cows, dogs, lions;

drop table cows;

drop table dogs;

drop table lions;



create table animals (i int);

create table cows as subclass of animals;

create table dogs as subclass of animals;

create table lions as subclass of animals;

drop table if exists all animals (except dogs,lions);

drop table cows;

drop table if exists dogs, lions, cows;

drop table lions;

drop table dogs;


create table animals (i int);

create table cows as subclass of animals;

create table dogs as subclass of animals;

create table lions as subclass of animals;

create table t1 (i int);

create table t2 (i int);

create table t3 (i int);

drop table if exists all animals (except dogs), t1, only t2, all t3;

drop table if exists only animals;

drop table animals;

drop table t1;

drop table t2;

drop table t3;

drop table cows;

drop table lions;

drop table lions;

drop table if exists dogs;




create table animals (i int);

create table cows as subclass of animals;

create table dogs (i int);

create table t1 (i int);

create table t2 (i int);

create table t3 (i int);

drop table if exists all animals;

drop table animals;

drop table cows;

drop table if exists dogs, only animals, all cows, t1, t2, only t3;

drop table dogs;

drop table t1;

drop table t2;

drop table t3;
 

create table animals (i int);

create table dogs as subclass of animals;

create table puppies as subclass of dogs;

create table t1 (i int);

create table t2 (i int);

drop table if exists all animals, dogs, puppies, only t1, t2, t1, all t2;

drop table animals;

drop table dogs;

drop table puppies;

drop table t1;

drop table t2;




drop class if exists dropt;

drop class dropt;

drop if exists dropt;

drop dropt;

create class dropt (i int);

drop class if exists dropt;

drop class dropt;

create class dropt (i int);

drop if exists dropt;
 
drop dropt;




