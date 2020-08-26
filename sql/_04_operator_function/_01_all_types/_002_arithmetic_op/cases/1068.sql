set system parameters 'create_table_reuseoid=no';
--[er]test (+) operator using object field plus(+) integer in select clause

create class func_02_01 ( a int );
create class func_02_02 ( a func_02_01 );
insert into func_02_02 values ( insert into func_02_01 values (1) );

select a + 1 from func_02_02 order by 1;

drop class func_02_01;
drop class func_02_02;
set system parameters 'create_table_reuseoid=yes';
