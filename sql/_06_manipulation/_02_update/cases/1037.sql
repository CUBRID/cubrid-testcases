set system parameters 'create_table_reuseoid=no';
--Test update using object with multi values
create class t1 (col1 integer, col2 set varchar(10));
insert into t1 values( 101, {'xxx','yyy','zzzz','null'});
insert into t1 values( 102, {'aaa','yyy','zzzz','null'});
insert into t1 values( 103, {'bbb','yyy','zzzz','null'});
insert into t1 values( 104, {'ccc','yyy','zzzz','null'});
insert into t1 values( 105, {'ddd','yyy','zzzz'});
insert into t1 values( 106, {'eee','yyy','zzzz'});
insert into t1 values( 107, {'fff','yyy','zzzz'});
insert into t1 values( 108, {'zzz','yyy','zzzz'});
insert into t1 values( 109, {});


insert into t1 (col1, col2) values(110,{'a','b','c'}) into new_column;
update object new_column 
set    (col1, col2)  = (111,{'x','y','z'});

select * from t1
where  col1 = 111;

drop class t1;
set system parameters 'create_table_reuseoid=yes';
