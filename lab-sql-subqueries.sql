/*
## Introduction
Welcome to the SQL Subqueries lab!

In this lab, you will be working with the [Sakila] database on movie rentals. 
Specifically, you will be practicing how to perform subqueries, which are queries embedded within other queries. Subqueries allow you to retrieve data from one or more tables and use that data in a separate query to retrieve more specific information.

## Challenge
Write SQL queries to perform the following tasks using the Sakila database:
*/
use sakila;

-- 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.

select  * from inventory;
select film_id, title from film
where title = "Hunchback Impossible"
;
-- 
SELECT 
    COUNT(*)
FROM
    inventory
WHERE
    film_id = (SELECT 
            film_id
        FROM
            film
        WHERE
            title = 'Hunchback Impossible')
;


-- 2. List all films whose length is longer than the average length of all the films in the Sakila database.

	--  first get the individual queries:
select * from film;
select avg(length) from film;


	-- then create the sub query
SELECT 
    *
FROM
    film
WHERE
    length > (SELECT 
            AVG(length)
        FROM
            film)
;

-- 3. Use a subquery to display all actors who appear in the film "Alone Trip".

	--  first get the individual queries:
select * from film
	where title = "Alone Trip";
select * from actor;
select * from film_actor;

	-- then the join subquery:
select first_name, last_name, title from actor
join film_actor
using (actor_id)
left join film
using (film_id)
;

	-- subquery:
select * from actor
join film_actor
using (actor_id)
where film_id = (select film_id from film
	where title = "Alone Trip")
;


--  Option 2
/*
SELECT
    *
FROM
    actor a
        JOIN
    film_actor fa ON a.actor_id = fa.actor_id
WHERE
    film_id IN (
    SELECT * FROM
            (SELECT film_id
            FROM film
            WHERE
                title = 'Alone Trip') sub);
*/                

-- --------------------------------------------------
-- **Bonus**:
-- --------------------------------------------------
-- 4. Sales have been lagging among young families, and you want to target family movies for a promotion. 
-- Identify all movies categorized as family films. 
	-- Step 1
Select * from film;
Select * from film_category;
Select * from category;

	-- Step 2
Select * from film
join film_category
using (film_id)
join category
using (category_id)
where category.name = 'Family'
;

	-- Step 3 Convert to subquery
Select *
from film
where film_id IN (
	SELECT film_id
    from film_category
    join category using (category_id)
    where category.name = 'Family'
);


-- 5. Retrieve the name and email of customers from Canada using both subqueries and joins. 
-- To use joins, you will need to identify the relevant tables and their primary and foreign keys.
	-- Step 1
select * from customer;
select * from address;
select * from city;
select * from country;
	-- Step 2
select country_id, country from country
where country = 'canada'
;
	-- Step 3 FINAL
SELECT 
    customer.first_name, customer.last_name, customer.email
FROM
    customer
JOIN address USING (address_id)
JOIN city USING (city_id)
JOIN country USING (country_id)
WHERE
    country.country_id = (SELECT 
            country_id
        FROM
            country
        WHERE
            country = 'canada')
;

-- 6. Determine which films were starred by the most prolific actor in the Sakila database. 
	-- A prolific actor is defined as the actor who has acted in the most number of films. 
	-- First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.

	-- Step 1
select * from film;
select * from film_actor order by actor_id desc;
select * from actor;
	-- Step 2
select actor_id, count(film_id) as film_amount from film_actor
group by actor_id
order by film_amount desc limit 1
;
	-- Step 3
select film.title, first_name, last_name from actor
join film_actor
using (actor_id)
join film
using (film_id)
where actor_id = (select actor_id from (select actor_id, count(film_id) as film_amount from film_actor
group by actor_id
order by film_amount desc limit 1)as sub)
;


-- 7. Find the films rented by the most profitable customer in the Sakila database. 
-- You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.
	-- Step 1
select * from payment;
select * from customer;
	-- Step 2
select customer_id, sum(amount) as total_spent from customer
join payment
using (customer_id)
group by customer_id
order by total_spent desc
limit 1
;
	-- Step 2
select title, first_name, last_name from film
join inventory
using (film_id)
join rental
using (inventory_id)
join customer
using (customer_id)
where customer_id = 
(select customer_id from (select customer_id, sum(amount) as total_spent from customer
join payment
using (customer_id)
group by customer_id
order by total_spent desc
limit 1)sub)
;

-- 8. Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. You can use subqueries to accomplish this.

-- avg of the total_amount spent by each client
select avg(total_client) as average_spent from (
select customer_id, sum(amount) as total_client
from payment
group by customer_id) as clients_totals
;

-- client_id and the total_amount_spent of those clients who spent more than avg

select customer_id, sum(amount) as total_amount_spent from payment
group by customer_id
having total_amount_spent > (select avg(total_client) as average_spent from (
select customer_id, sum(amount) as total_client
from payment
group by customer_id) as clients_totals)
order by total_amount_spent desc
;






