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
-- 4. Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films. 



-- 5. Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.

-- 6. Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films. First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.

-- 7. Find the films rented by the most profitable customer in the Sakila database. You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.

-- 8. Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. You can use subqueries to accomplish this.
