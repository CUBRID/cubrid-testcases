create table tb (a int, b varchar(10));
create INDEX i_tb_a ON tb (a);

insert into tb values (1,'A'),(2,'B'),(3,'C'),(4,'D'),(5,'E'),(6,'F'),(7,'G'),(8,'H'),(9,'I'),(10,'J'),(11,'K'),(12,'L'),(13,'M');

-- should use index
select /*+ recompile */ rownum,a,b from tb where a > 0 and rownum=2;


select /*+ recompile */ rownum,a,b from tb where a > 0 using index i_tb_a(+);
select /*+ recompile */ rownum,a,b from tb where a > 0 and rownum = 5 using index i_tb_a(+);

select /*+ recompile */ rownum,a,b from tb where a > 0 and rownum between 6 and 8 using index i_tb_a(+);

-- the following two should yield wrong results
select /*+ recompile */ rownum,a,b from tb where a > 0 and rownum = 5 using index i_tb_a(+) keylimit 3,2;
select /*+ recompile */ rownum,a,b from tb where a > 0 and rownum = 5 using index i_tb_a(+) keylimit 6,2;

-- the folowing statements should not suffer the optimization (for instance joins).
select rownum, x.a from tb x, tb y where x.a > 0 and rownum = 7 using index x.i_tb_a(+);
select rownum, a from tb where a > 0 using index i_tb_a(+) keylimit 3;

DROP TABLE tb;

