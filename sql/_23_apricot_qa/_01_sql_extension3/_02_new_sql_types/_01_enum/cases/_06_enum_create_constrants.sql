--create table with enum type column, with constraints.


--TEST: set default value to enum type column.
create table cons(a enum('a', 'b', 'c') default 'b'); 
drop table if exists cons;
create table cons(a enum('a', 'b', 'c') default 3);
drop table if exists cons;


--TEST: set shared value to enum type column.
create table cons(a enum('a', 'b', 'c') shared 'b'); 
drop table if exists cons;
create table cons(a enum('a', 'b', 'c') shared 3);
drop table if exists cons;


--TEST: [er], set auto_increment to enum type column.
create table cons(a enum('a', 'b', 'c') auto_increment);
drop table if exists cons;


--TEST: set not null constraint to enum type column.
create table cons(a enum('a', 'b', 'c') not null);
show columns in cons;
--TEST: [er], insert a null value
insert into cons values(default);
insert into cons values(null);
drop table if exists cons;

--TEST: set primary key constraint to enum type column.
create table cons(a enum('a', 'b', 'c') primary key);
show columns in cons;
--TEST: [er], insert duplicate values.
insert into cons vlaues('a'), (1);
drop table if exists cons;

--TEST: set unique constraint to enum type column.
create table cons(a enum('a', 'b', 'c') unique);
show columns in cons;
--TEST: [er], insert duplicate values.
insert into cons values('a'), (1);
drop table if exists cons;

--TEST: set primary key constraint to enum type column.
create table cons(a enum('a', 'b', 'c') primary key);
show columns in cons;
drop table if exists cons;

--TEST: set foreign key constraint to enum type column.
create table cons1(a enum('a', 'b', 'c') primary key);
insert into cons1 values(1), (2), (3);
create table cons2(a enum('a', 'b', 'd') primary key, constraint fk_a foreign key(a) references cons1(a));
show columns in cons2;
--TEST: fk violation
insert into cons2 values(1), (2), (3);
select * from cons2 order by 1;
drop table if exists cons2, cons1;
