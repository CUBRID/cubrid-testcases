--+ holdcas on;
--[er]test (/) operator by timestamp data type value divide integer

create class func_02(
a      date,
b      time,
c      timestamp
);
insert into func_02 values ( DATE '08/14/1977', TIME '02:10:00', TIMESTAMP '08/14/1977 5:35:00 pm');
insert into func_02 values ( DATE '08/14/1977', TIME '02:10:00', TIMESTAMP '08/15/1977 5:35:00 pm');
insert into func_02 values ( DATE '08/14/1977', TIME '02:10:00', TIMESTAMP '08/15/1977 02:10:00');
insert into func_02 values ( null, null, null);

select c, c / 600 from func_02 order by 1;

set system parameters 'compat_mode=mysql';
select c, c / 600 from func_02 order by 1;

drop class func_02;
set system parameters 'compat_mode=cubrid';
commit;
--+ holdcas off;
