---- ALTER TABLE ...  CHANGE COLUMN  
-- class attribute
-- changing (adding) constraints :  NOT NULL , UNIQUE, PRIMARY KEY, AUTO_INCREMENT



-- NOT NULL
create class c1 class attribute (c_i integer)  ( i integer ) ;
insert into c1 values (1),(2);
update c1 set class c1.c_i=-1;

select class c1.c_i, i from c1 order by 1,2;
show columns in c1;

alter table c1 change class attribute c_i c_i integer NOT NULL;

insert into c1 set i=3;

select class c1.c_i, i from c1 order by 1,2;

show columns in c1;

drop class c1;


-- UNIQUE
create class c1 class attribute (c_i integer)  ( i integer ) ;
insert into c1 values (1),(2);
update c1 set class c1.c_i=-1;

select class c1.c_i, i from c1 order by 1,2;
show columns in c1;

alter table c1 change class attribute c_i c_i integer UNIQUE;

insert into c1 set i=3;

select class c1.c_i, i from c1 order by 1,2;

show columns in c1;

drop class c1;

-- PRIMARY KEY
create class c1 class attribute (c_i integer)  ( i integer ) ;
insert into c1 values (1),(2);
update c1 set class c1.c_i=-1;

select class c1.c_i, i from c1 order by 1,2;
show columns in c1;

alter table c1 change class attribute c_i c_i integer PRIMARY KEY;

insert into c1 set i=3;

select class c1.c_i, i from c1 order by 1,2;

show columns in c1;

drop class c1;


-- auto_increment
create class c1 class attribute (c_i integer)  ( i integer ) ;
insert into c1 values (1),(2);
update c1 set class c1.c_i=-1;

select class c1.c_i, i from c1 order by 1,2;
show columns in c1;

alter table c1 change class attribute c_i c_i integer auto_increment;

insert into c1 set i=3;

select class c1.c_i, i from c1 order by 1,2;

show columns in c1;

drop class c1;
