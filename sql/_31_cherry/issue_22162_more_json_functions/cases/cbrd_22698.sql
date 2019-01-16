drop table if exists t1;
CREATE TABLE t1 (id int primary key,  a TIME);

insert into t1 values (1, time '07:00:34 PM');

select * from json_table ( (
       select json_arrayagg(aa) from (
               select json_array( 
                  ( time_format(a, '%H %i %s. The TIME_FORMAT function converts the date/time data type value including time value into a string of specified date/time format, and returns the value with the VARCHAR data type. When the format argument is assigned, the time is output according to the specified language. At this time, the language specified as the intl_date_lang system parameter is applied. If intl_date_lang system parameter is not set, the language specified when creating DB is applied.')
                  )
               ) aa from t1 where id = 1
           )
   ), '$[*]' COLUMNS (col_0 VARCHAR PATH '$[0]') ) as t;


drop table if exists t1;

