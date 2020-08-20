-- it tests a insert data into superclass and subclass syntax with type set
set system parameters 'create_table_reuseoid=no';

create class DML_SUPER (
	int_col int not null,
	var_col varchar(20),
	set_col set (int, varchar(20))
);
create class DML_0001 under DML_SUPER  ( 
	ref_col DML_SUPER
);

create class DML_0002 under DML_0001 (	
	set_ref_col set of DML_0001
);

insert into DML_SUPER values (1, 'test1',{1,'test1'}) into a;
insert into DML_SUPER values (2, 'test2',{2,'test2'}) into b;

insert into DML_0001 values (1, 'test1', {1,'test1'},a) into c;
insert into DML_0001 values (2, 'test2', {2,'test2'},b) into d;

insert into DML_0002 values (1,'test1',{1,'test1'},a,{c,d});
insert into DML_0002 values (2,'test2',{2,'test2'},b,{c,d});
select * from all DML_SUPER order by 1,2,3;



drop class DML_SUPER;
drop class DML_0001;
drop class DML_0002;

set system parameters 'create_table_reuseoid=yes';
