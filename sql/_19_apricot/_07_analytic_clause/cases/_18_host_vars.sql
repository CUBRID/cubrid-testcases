
create table t(i1 int, i2 int, i3 int);
insert into t values
(1,1,1),
(1,1,2),
(1,2,1),
(1,2,2),
(1,2,3),
(2,1,1),
(2,1,2),
(2,1,3),
(2,1,4),
(2,2,1),
(2,2,2),
(2,3,1),
(2,3,2),
(2,3,3);

-- OVER()
prepare stmt from 'select i1,i2,i3,count(?) over(),min(?) over(),max(?) over(),sum(?) over(),avg(?) over(),stddev(?) over(),variance(?) over(),stddev_pop(?) over(),var_pop(?) over(),stddev_samp(?) over(),var_samp(?) over() from t order by 1,2,3,4,5,6';
execute stmt using 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 11;
execute stmt using 1.1, 2.2, 3.1, 4.4, 5.7, 0.2, 7.9, 8.5, 9.3, 0.4, 11.8;
execute stmt using '1.1', '2.2', '3.1', '4.4', '5.7', '0.2', '7.9', '8.5', '9.3', '0.4', '11.8';
execute stmt using 1.1f, 2.2f, 3.1f, 4.4f, 5.7f, 0.2f, 7.9f, 8.5f, 9.3f, 0.4f, 11.8f;
deallocate prepare stmt;

-- OVER(PARTITION BY)
prepare stmt from 'select i1,i2,i3,count(?) over(partition by i1),min(?) over(partition by i1),max(?) over(partition by i1),sum(?) over(partition by i1),avg(?) over(partition by i1),stddev(?) over(partition by i1),variance(?) over(partition by i1),stddev_pop(?) over(partition by i1),var_pop(?) over(partition by i1),stddev_samp(?) over(partition by i1),var_samp(?) over(partition by i1) from t order by 1,2,3,4,5,6';
execute stmt using 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 11;
execute stmt using 1.1, 2.2, 3.1, 4.4, 5.7, 0.2, 7.9, 8.5, 9.3, 0.4, 11.8;
execute stmt using '1.1', '2.2', '3.1', '4.4', '5.7', '0.2', '7.9', '8.5', '9.3', '0.4', '11.8';
execute stmt using 1.1f, 2.2f, 3.1f, 4.4f, 5.7f, 0.2f, 7.9f, 8.5f, 9.3f, 0.4f, 11.8f;
deallocate prepare stmt;

prepare stmt from 'select i1,i2,i3,count(?) over(partition by i1,i2),min(?) over(partition by i1,i2),max(?) over(partition by i1,i2),sum(?) over(partition by i1,i2),avg(?) over(partition by i1,i2),stddev(?) over(partition by i1,i2),variance(?) over(partition by i1,i2),stddev_pop(?) over(partition by i1,i2),var_pop(?) over(partition by i1,i2),stddev_samp(?) over(partition by i1,i2),var_samp(?) over(partition by i1,i2) from t order by 1,2,3,4,5,6';
execute stmt using 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 11;
execute stmt using 1.1, 2.2, 3.1, 4.4, 5.7, 0.2, 7.9, 8.5, 9.3, 0.4, 11.8;
execute stmt using '1.1', '2.2', '3.1', '4.4', '5.7', '0.2', '7.9', '8.5', '9.3', '0.4', '11.8';
execute stmt using 1.1f, 2.2f, 3.1f, 4.4f, 5.7f, 0.2f, 7.9f, 8.5f, 9.3f, 0.4f, 11.8f;
deallocate prepare stmt;

-- OVER(ORDER BY)
prepare stmt from 'select i1,i2,i3,count(?) over(order by i1),min(?) over(order by i1),max(?) over(order by i1),sum(?) over(order by i1),avg(?) over(order by i1),stddev(?) over(order by i1),variance(?) over(order by i1),stddev_pop(?) over(order by i1),var_pop(?) over(order by i1),stddev_samp(?) over(order by i1),var_samp(?) over(order by i1) from t order by 1,2,3,4,5,6';
execute stmt using 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 11;
execute stmt using 1.1, 2.2, 3.1, 4.4, 5.7, 0.2, 7.9, 8.5, 9.3, 0.4, 11.8;
execute stmt using '1.1', '2.2', '3.1', '4.4', '5.7', '0.2', '7.9', '8.5', '9.3', '0.4', '11.8';
execute stmt using 1.1f, 2.2f, 3.1f, 4.4f, 5.7f, 0.2f, 7.9f, 8.5f, 9.3f, 0.4f, 11.8f;
deallocate prepare stmt;

prepare stmt from 'select i1,i2,i3,count(?) over(order by i1,i2),min(?) over(order by i1,i2),max(?) over(order by i1,i2),sum(?) over(order by i1,i2),avg(?) over(order by i1,i2),stddev(?) over(order by i1,i2),variance(?) over(order by i1,i2),stddev_pop(?) over(order by i1,i2),var_pop(?) over(order by i1,i2),stddev_samp(?) over(order by i1,i2),var_samp(?) over(order by i1,i2) from t order by 1,2,3,4,5,6';
execute stmt using 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 11;
execute stmt using 1.1, 2.2, 3.1, 4.4, 5.7, 0.2, 7.9, 8.5, 9.3, 0.4, 11.8;
execute stmt using '1.1', '2.2', '3.1', '4.4', '5.7', '0.2', '7.9', '8.5', '9.3', '0.4', '11.8';
execute stmt using 1.1f, 2.2f, 3.1f, 4.4f, 5.7f, 0.2f, 7.9f, 8.5f, 9.3f, 0.4f, 11.8f;
deallocate prepare stmt;

-- OVER(PARTITION BY ORDER BY)
prepare stmt from 'select i1,i2,i3,count(?) over(partition by i1 order by i2),min(?) over(partition by i1 order by i2),max(?) over(partition by i1 order by i2),sum(?) over(partition by i1 order by i2),avg(?) over(partition by i1 order by i2),stddev(?) over(partition by i1 order by i2),variance(?) over(partition by i1 order by i2),stddev_pop(?) over(partition by i1 order by i2),var_pop(?) over(partition by i1 order by i2),stddev_samp(?) over(partition by i1 order by i2),var_samp(?) over(partition by i1 order by i2) from t order by 1,2,3,4,5,6';
execute stmt using 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 11;
execute stmt using 1.1, 2.2, 3.1, 4.4, 5.7, 0.2, 7.9, 8.5, 9.3, 0.4, 11.8;
execute stmt using '1.1', '2.2', '3.1', '4.4', '5.7', '0.2', '7.9', '8.5', '9.3', '0.4', '11.8';
execute stmt using 1.1f, 2.2f, 3.1f, 4.4f, 5.7f, 0.2f, 7.9f, 8.5f, 9.3f, 0.4f, 11.8f;
deallocate prepare stmt;

prepare stmt from 'select i1,i2,i3,count(?) over(partition by i1,i2 order by i3),min(?) over(partition by i1,i2 order by i3),max(?) over(partition by i1,i2 order by i3),sum(?) over(partition by i1,i2 order by i3),avg(?) over(partition by i1,i2 order by i3),stddev(?) over(partition by i1,i2 order by i3),variance(?) over(partition by i1,i2 order by i3),stddev_pop(?) over(partition by i1,i2 order by i3),var_pop(?) over(partition by i1,i2 order by i3),var_samp(?) over(partition by i1,i2 order by i3) from t order by 1,2,3,4,5,6';
execute stmt using 1, 2, 3, 4, 5, 6, 7, 8, 9, 11;
execute stmt using 1.1, 2.2, 3.1, 4.4, 5.7, 0.2, 7.9, 8.5, 9.3, 11.8;
execute stmt using '1.1', '2.2', '3.1', '4.4', '5.7', '0.2', '7.9', '8.5', '9.3', '11.8';
execute stmt using 1.1f, 2.2f, 3.1f, 4.4f, 5.7f, 0.2f, 7.9f, 8.5f, 9.3f, 11.8f;
deallocate prepare stmt;

drop t;
