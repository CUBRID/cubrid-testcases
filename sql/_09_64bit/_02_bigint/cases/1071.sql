create class test_class (bigint_col bigint primary key, char_col char(20), UNIQUE(bigint_col));

insert into test_class values(1000, 'a');
insert into test_class values(2000, 'b');
insert into test_class values(3000, 'c');
insert into test_class values(4000, 'd');

CREATE TABLE test_class1(
id int AUTO_INCREMENT,
f_id bigint,
FOREIGN KEY (f_id) REFERENCES test_class(bigint_col)
);

insert into test_class1(f_id) values(1000);
insert into test_class1(f_id) values(2000);
insert into test_class1(f_id) values(3000);
insert into test_class1(f_id) values(2000);
insert into test_class1(f_id) values(1000);

insert into test_class1(f_id) values(5000);

insert into test_class1(f_id) values(2000);
insert into test_class1(f_id) values(1000);

select * from test_class order by 1,2;
select * from test_class1 order by 1,2;

delete from test_class where bigint_col = 1000;
delete from test_class where bigint_col = 4000;

drop class test_class;

drop class test_class1;
drop class test_class;
