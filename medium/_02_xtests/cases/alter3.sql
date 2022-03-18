autocommit off;
alter class public.breakfast modify class attribute meal_type character varying(1073741823) default 'lunch';
select class [public.breakfast].meal_type, serving_hours from public.breakfast;
alter class public.breakfast modify class attribute meal_type character varying(1073741823) default 'dinner';
select class [public.breakfast].meal_type, serving_hours from public.breakfast;
rollback work;
rollback;
