DROP TABLE IF EXISTS a_tbl;

CREATE TABLE a_tbl (
id INT NOT NULL,
phone VARCHAR(10)
);
DROP VIEW IF EXISTS b_view;
CREATE VIEW b_view (a, b) AS SELECT * FROM a_tbl ;

DROP VIEW IF EXISTS b_view;
CREATE VIEW b_view (a INT, b VARCHAR COMMENT 'b col') AS SELECT * FROM a_tbl;

DROP VIEW IF EXISTS b_view;
CREATE VIEW b_view (a, b COMMENT 'b col') AS SELECT * FROM a_tbl order by id;

insert into a_tbl values(1,'abcsc'),(2,'2222abcsc'), (3,'223abcsc'),(4,'44abcsc'),(5,'a55bcsc'),(6,'ab66csc'),(7,'a77bcsc');

show create view b_view;
select * from db_vclass where vclass_name='b_view' order by 1,2;

alter view b_view comment='alter view to add comment on view';

select * from a_tbl order by id;
select * from b_view order by a;

alter view b_view add query select * from a_tbl where a_tbl.id in (1,3,5) comment'new''s comment for view';
show create view b_view;
select * from db_vclass where vclass_name='b_view' order by vclass_name,vclass_def;

DROP VIEW IF EXISTS b_view;
DROP TABLE IF EXISTS a_tbl;
