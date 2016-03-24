--test implicit conversion from number to date/time type as a function parameter 


--date format
select date(20101110);
select date(991228);
select year(20101110);
select year(991228);
select month(20101110);
select month(991228);
select day(20101110);
select day(991228);
select last_day(20101110);
select last_day(991228);
select to_days(20101110);
select to_days(991228);


--time format
select time(093045);
select time(51436);
select time(180923.321);
select time(1534);
select time(250.111);
select time(56);
select time(9);
select time(7.33);
select hour(093045);
select hour(51436);
select hour(180923.321);
select hour(1534);
select hour(250.111);
select hour(56);
select hour(9);
select hour(7.33);


--timestamp format
select date(20101110101156);
select date(671208183459);
select time(20101110101156);
select time(671208183459);
select year(20101110101156);
select year(671208183459);
select month(20101110101156);
select month(671208183459);
select day(20101110101156);
select day(671208183459);
select last_day(20101110101156);
select last_day(671208183459);
select to_days(20101110101156);
select to_days(671208183459);


--datetime format
select date(20101110101156.123);
select date(671208183459.456);
select time(20101110101156.123);
select time(671208183459.456);
select year(20101110101156.123);
select year(671208183459.456);
select month(20101110101156.123);
select month(671208183459.456);
select day(20101110101156.123);
select day(671208183459.456);
select last_day(20101110101156.123);
select last_day(671208183459.456);
select to_days(20101110101156.123);
select to_days(671208183459.456);

