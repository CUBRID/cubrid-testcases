drop table if exists tb_a;
drop table if exists tb_b;

CREATE TABLE tb_a(field1 INTEGER  NOT NULL, field2 INTEGER  NOT NULL);
CREATE TABLE tb_b(field1 INTEGER  NOT NULL, field2 INTEGER  NOT NULL);
CREATE TRIGGER trig_tb_a_insert BEFORE INSERT ON tb_a EXECUTE INSERT tb_b (field1, field2) VALUES(new.field1,new.field2);

alter trigger trig_tb_a_insert status inactive;
alter trigger trig_tb_a_insert status active;

drop table if exists tb_a;
drop table if exists tb_b;
