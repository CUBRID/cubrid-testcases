--drop pk without deleting fk in advance

create class xoo ( a int primary key, b int , foreign key (b) references xoo(a) );
alter class xoo drop constraint pk_xoo_a;

create class yoo ( a int primary key, b int , foreign key (b) references yoo(a) );
alter class yoo drop constraint fk_yoo_b;
alter class yoo drop constraint pk_yoo_a;

create class aoo ( a int primary key);
create class boo ( a int primary key, b int , foreign key (b) references aoo(a) );
alter class aoo drop constraint pk_aoo_a;


create class coo ( a int primary key);
create class doo ( a int primary key, b int , foreign key (b) references coo(a) );
create class eoo ( a int primary key, b int , foreign key (b) references coo(a) );
alter class doo drop constraint fk_doo_b;
alter class coo drop constraint pk_coo_a;

drop yoo;
drop xoo;
drop boo;
drop aoo;
drop eoo, doo;
drop coo;