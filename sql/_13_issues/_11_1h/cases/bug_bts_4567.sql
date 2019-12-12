create table tb (a int );
--no error were thrown for following three queries.
select * from tb where a=any{};
select * from tb where a=some{};
select * from tb where a=all{};

create index i_tb_a on tb(a);

select * from tb where a=any{};
select * from tb where a=some{};
select * from tb where a=all{};


drop table tb;

