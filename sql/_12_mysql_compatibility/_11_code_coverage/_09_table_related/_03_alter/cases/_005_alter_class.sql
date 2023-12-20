-- ALTER ... DROP 

create class c1 (i1 integer);

alter class c1 add column ( i2 integer);

alter class c1 add class attribute (i2 integer default 0);
--fails
alter class c1 add class attribute i2 integer default 0;

drop class c1;



create class c1 (i1 integer primary key);

create class c2 (i2 integer foreign key references c1(i1) , i3 integer unique key, i4 integer , index i_c2_i4 (i4), i5 integer);

alter class c2 add index i_c2_i5(i5);

-- should fail
alter class c1 add index i_c1_i5(i5);
-- should fail
alter class c2 drop foreign key u_c2_i3;

-- should fail
alter class c2 drop unique key fk_c2_i2;

alter class c2 drop foreign key fk_c2_i2;

alter class c2 drop unique key u_c2_i3;

-- should fail
alter class c1 drop foreign key fk_c2_i2;

-- should fail
alter class c2 drop unique key u_c2_i4;

alter class c2 drop index i_c2_i4;

alter class c1 drop primary key;

-- should fail
alter class c2 drop primary key;

alter class c2 add index i_c2_i2(i2);

alter index i_c2_i2 on c2 rebuild;

-- should fail
alter index i_c2_i2 on c2(i2) rebuild;

drop index i_c2_i2 on c2;


drop class c2;
drop class c1;






--CREATE with FOREIGN KEY ON UPDATE,  with INDEX, with UNIQUE KEY
create class c1 (i1 integer primary key);

create class c2 (i2 integer foreign key references c1(i1) on update set null, i3 integer unique key, i4 integer , index i_c2_i4 (i4), i5 integer);

drop class c2;
drop class c1;


-- ALTER .. CHANGE CONSTRAINT
create class c1 (i1 integer primary key);

create class c2 (i2 integer primary key);

create class c3 (i3 integer foreign key references c1(i1) on update set null );

alter class c3 change constraint foreign key (i3) references c2(i2) on update set null;

drop class c3;
drop class c2;
drop class c1;



-- ALTER .. ADD CLASS ATTRIBUTE  [single attribute] - failure
create class c1 (i1 integer);
-- fails
alter class c1 alter class attribute i1 set default 0;

drop class c1;




-- ALTER .. DROP INDEX  REVERSE
create class c1 (i1 integer ,  index i_c1_i1 (i1));

alter class c1 drop reverse index i_c1_i1;

drop class c1;



-- ALTER .. DROP INDEX  with hints
create class c1 (i1 integer ,  index i_c1_i1 (i1));

alter /*+ NO_STATS */class c1 drop index i_c1_i1;

drop class c1;




-- ALTER .. ADD CLASS ATTRIBUTE  [list of attributes] INHERIT
create class c1 (i1 integer );

create class c2 (i2 integer );

alter class c2 add superclass c1;
alter class c2 add class attribute i3 integer,i4 integer inherit  i1 of c1;


drop class c2;
drop class c1;


-- ALTER .. ALTER CLASS ATTRIBUTE  - success
create class c1 (i1 integer );

create class c2 (i2 integer );

alter class c2 add superclass c1;
alter class c2 add class attribute i3 integer,i4 integer inherit  i1 of c1;
alter class c2 alter class attribute i3 set default 0;

-- should fail
alter class c2 change class attribute i3 set default 0;

drop class c2;
drop class c1;



-- ALTER .. ADD/DROP SUPERCLASS
create class c1 (i1 integer );

create class c2 (i2 integer );

alter class c2 add superclass c1;

alter class c2 drop superclass c1;

drop class c2;
drop class c1;




