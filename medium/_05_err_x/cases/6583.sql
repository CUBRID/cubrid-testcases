autocommit off;
create class tokuisaki(
        code char(2) unique,
        name char(8)
);
create class torihikisaki(
        code char(7) unique,
        name char(8),
        t_saki set_of tokuisaki
);
insert into torihikisaki
values('0000001', 't_saki1',
        {(insert into tokuisaki values('01','tk_sak1')),
        (insert into tokuisaki values('02','tk_sak2')),
        (insert into tokuisaki values('03','tk_sak3'))}
);
insert into torihikisaki
values('0000002', 't_saki2',
        {(insert into tokuisaki values('01','tk_sak1')),
        (insert into tokuisaki values('02','tk_sak2')),
        (insert into tokuisaki values('04','tk_sak4'))}
);
select * from tokuisaki order by 1,2;
rollback;
