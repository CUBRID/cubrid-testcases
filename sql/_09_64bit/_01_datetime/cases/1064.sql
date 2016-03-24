create class test_class (datetime_col datetime primary key, char_col char(20));

insert into test_class values(DATETIME '1991-01-02 23:59:59.999', 'a');
insert into test_class values(DATETIME '1992-01-02 23:59:59.999', 'b');
insert into test_class values(DATETIME '1993-01-02 23:59:59.999', 'c');
insert into test_class values(DATETIME '1994-01-02 23:59:59.999', 'd');


CREATE TABLE test_class1(
id int AUTO_INCREMENT,
f_dt datetime,
FOREIGN KEY (f_dt) REFERENCES test_class(datetime_col)
);

insert into test_class1(f_dt) values(DATETIME '1991-01-02 23:59:59.999');
insert into test_class1(f_dt) values(DATETIME '1992-01-02 23:59:59.999');
insert into test_class1(f_dt) values(DATETIME '1993-01-02 23:59:59.999');
insert into test_class1(f_dt) values(DATETIME '1991-01-02 23:59:59.999');
insert into test_class1(f_dt) values(DATETIME '1992-01-02 23:59:59.999');

insert into test_class1(f_dt) values(DATETIME '1995-01-02 23:59:59.999');

insert into test_class1(f_dt) values(DATETIME '1991-01-02 23:59:59.999');
insert into test_class1(f_dt) values(DATETIME '1992-01-02 23:59:59.999');

select * from test_class order by 1,2;
select * from test_class1 order by 1,2;

delete from test_class where datetime_col = DATETIME '1991-01-02 23:59:59.999';
delete from test_class where datetime_col = DATETIME '1994-01-02 23:59:59.999';

drop class test_class;

drop class test_class1;
drop class test_class;