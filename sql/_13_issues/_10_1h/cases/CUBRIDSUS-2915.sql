create table t1(id varchar(22), name varchar(30), constraint unique index (id desc, name asc));
insert into t1 values ('1000','john');
insert into t1 values ('1000','johny');
insert into t1 values ('1000','jon');
insert into t1 values ('1001','johny');
insert into t1 values ('1001','john');
insert into t1 values ('1001','jon');

select * from t1 where id > '100';

create unique index u_t1_id_name_d  on t1 (id asc, name desc);
create unique index u_t1_id_name on t1 (id asc, name asc);
create unique index u_t1_id_d_name on t1 (id desc, name asc);
create unique index u_t1_id_d_name_d on t1 (id desc, name desc);

drop unique index u_t1_id_d_name on t1;
drop class t1;


create table t1(id varchar(22), name varchar(30), constraint unique index u_t1_id_name_d (id asc, name desc));
insert into t1 values ('1000','john');
insert into t1 values ('1000','johny');
insert into t1 values ('1000','jon');
insert into t1 values ('1001','johny');
insert into t1 values ('1001','john');
insert into t1 values ('1001','jon');

select * from t1 where id > '100';

create unique index u_t1_id_name_d  on t1 (id asc, name desc);
create unique index u_t1_id_name on t1 (id asc, name asc);
create unique index u_t1_id_d_name on t1 (id desc, name asc);
create unique index u_t1_id_d_name_d on t1 (id desc, name desc);

drop unique index u_t1_id_name_d on t1;
drop class t1;


create table t1(id varchar(22), name varchar(30), constraint unique index ru_t1_id_name  (id desc, name desc));
insert into t1 values ('1000','john');
insert into t1 values ('1000','johny');
insert into t1 values ('1000','jon');
insert into t1 values ('1001','johny');
insert into t1 values ('1001','john');
insert into t1 values ('1001','jon');

select * from t1 where id > '100';

create unique index u_t1_id_name_d on t1 (id asc, name desc);
create unique index u_t1_id_name on t1 (id asc, name asc);
create unique index u_t1_id_d_name on t1 (id desc, name asc);
create unique index u_t1_id_d_name_d on t1 (id desc, name desc);

drop reverse unique index ru_t1_id_name on t1;
drop class t1;



create table t1(id varchar(22), name varchar(30), constraint unique index u_t1_id_name  (id asc, name asc));
insert into t1 values ('1000','john');
insert into t1 values ('1000','johny');
insert into t1 values ('1000','jon');
insert into t1 values ('1001','johny');
insert into t1 values ('1001','john');
insert into t1 values ('1001','jon');

select * from t1 where id > '100';

create unique index u_t1_id_name_d on t1 (id asc, name desc);
create unique index u_t1_id_name on t1 (id asc, name asc);
create unique index u_t1_id_d_name on t1 (id desc, name asc);
create unique index u_t1_id_d_name_d  on t1 (id desc, name desc);

drop unique index u_t1_id_name on t1;
drop class t1;
