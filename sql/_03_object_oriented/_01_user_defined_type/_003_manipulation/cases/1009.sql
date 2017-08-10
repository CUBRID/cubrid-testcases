-- it tests a nested insert data into superclass and subclass syntax

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
insert into DML_0001 values (1, 'test1', {1,'test1'},(insert into DML_SUPER values(3,'test3',{3,'test3'})));

insert into DML_0001 values (1, 'test1', {1,'test1'},a);


insert into DML_0002 values (
1,'test1',{1,'test1'},
(insert into DML_0001 values (1,'test1',{1,'test1'},(insert into DML_SUPER values (3,'test3',{3,'test3'})))),
{(insert into DML_0001 values(2,'test2',{2,'test2'},(insert into DML_SUPER values(4,'test4',{4,'test4'})))),
(insert into DML_0001 values(3,'test3',{3,'test3'},(insert into DML_SUPER values(5,'test5',{5,'test5'}))))
});

insert into DML_0002 values (
	1,'test1',{1,'test1'},
	(insert into DML_0001 values (1,'test1',{1,'test1'},
	(insert into DML_SUPER values (3,'test3',{3,'test3'})))),
	{(insert into DML_0001 values(2,'test2',{2,'test2'},(insert into DML_SUPER values(4,'test4',{4,'test4'})))),
	(insert into DML_0001 values(3,'test3',{3,'test3'},(insert into DML_SUPER values(5,'test5',{5,'test5'}))))});


insert into DML_SUPER values(1,'test1',{1,'test1'}) into a1;
insert into DML_SUPER values(2,'test2',{2,'test2'}) into a2;
insert into DML_0001 values(1,'test1',{1,'test1'},a1) into b1;
insert into DML_0001 values(2,'test2',{2,'test2'},a2) into b2;
insert into DML_0002 values(1,'test1',{1,'test1'},a1,{b1,b1,b2});
insert into DML_0002 values(2,'test2',{2,'test2'},a2,{b1,b2,b2});
select * from all DML_SUPER order by 1,2,3;



drop class DML_SUPER;
drop class DML_0001;
drop class DML_0002;