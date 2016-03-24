autocommit off;
alter class breakfast modify class attribute meal_type character varying(1073741823) default 'lunch';
select class breakfast.meal_type, serving_hours from breakfast;
alter class breakfast modify class attribute meal_type character varying(1073741823) default 'dinner';
select class breakfast.meal_type, serving_hours from breakfast;
rollback work;
rollback;
