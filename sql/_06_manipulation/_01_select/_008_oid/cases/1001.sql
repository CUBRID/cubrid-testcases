set system parameters 'create_table_reuseoid=no';
--get oid using select statement 
create class tb(
	id int auto_increment primary key,
	name varchar(10)
);

insert into tb (name) values('aaa');
insert into tb (name) values('bbb');
insert into tb (name) values('ccc');

select tb as oidcol from tb;

drop class tb;
set system parameters 'create_table_reuseoid=yes';
