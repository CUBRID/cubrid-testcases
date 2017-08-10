create table ad (
 pk                int(11)  AUTO_INCREMENT,
 col_int_nokey       int(11) ,
 col_int_key         int(11) ,
 col_date_key        date default sysdate,
 col_date_nokey      date default '2011-01-01',
 col_time_key        time default '09:10:10',
 col_time_nokey      time default '09:10:11',
 col_datetime_key    datetime default '2011-01-01 09:10:11',
 col_datetime_nokey  datetime default systimestamp,
 col_varchar_key     varchar(1),
 col_varchar_nokey   varchar(1) default '5',
 primary key(pk,col_int_nokey)

)
partition by range (col_int_nokey)
(
    partition p400 values less than (400),
    partition p800 values less than (800),
    partition pmax values less than MAXVALUE
);
alter table ad promote partition p400;
alter table ad promote partition p800;
alter table ad promote partition pmax;
drop table ad__p__p400;
alter table aa add partition(partition p400 values less than (400));
alter table ad partition by range (col_int_nokey) (partition p400 values less than (400));
drop ad;
drop ad__p__p800,ad__p__pmax;
