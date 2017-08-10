-- SHOW COLUMNS -- check constraint print
create table src (i integer primary key);
create table tt1 (i1 integer primary key,
		  i2 integer,
		  i3 integer unique,
		  i4 integer default 33,
		  i5 integer not null,
		  i6 integer foreign key references src(i),
		  i7 integer auto_increment,
		  i8 integer,
		  i9 integer,
		  i10 integer,
		  i11 integer
		  );

create index i_i5i4 on tt1 (i5 desc, i4 desc);

create index i_i2i3 on tt1 (i2 desc,i3 desc);

create index i_i8 on tt1(i8);
create reverse index i_i9 on tt1(i9 desc);
create unique index i_i10 on tt1(i10 desc);


show columns from tt1;

show columns from tt1 where `Field`='i1' and `Key`='PRI';

show columns from tt1 where `Field`='i2' and `Key`='MUL';

show columns from tt1 where `Field`='i3' and `Key`='UNI';

show columns from tt1 where `Field`='i4' and `Key`='';

show columns from tt1 where `Field`='i5' and `Key`='MUL';

show columns from tt1 where `Field`='i6' and `Key`='MUL';

show columns from tt1 where `Field`='i7' and `Key`='';

show columns from tt1 where `Field`='i8' and `Key`='MUL';

show columns from tt1 where `Field`='i9' and `Key`='MUL';

show columns from tt1 where `Field`='i10' and `Key`='UNI';

show columns from tt1 where `Field`='i11' and `Key`='';

	  
drop table tt1;
drop table src;
