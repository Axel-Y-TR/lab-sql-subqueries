-- Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.

SELECT film.title, COUNT(film.film_id) AS film_count
FROM film
JOIN inventory ON film.film_id = inventory.film_id
WHERE film.title LIKE 'Hunchback Impossible'
GROUP BY film.title;


-- List all films whose length is longer than the average length of all the films in the Sakila database.
select title, length
from film
 where length > (select avg(length) from film)
 order by length;

-- Use a subquery to display all actors who appear in the film "Alone Trip".
select  first_name, last_name,film.title
From actor 
join film_actor on actor.actor_id = film_actor.actor_id
join film on film_actor.film_id = film.film_id
where title like "Alone Trip";

SELECT first_name, last_name
FROM actor
WHERE actor_id IN (
  SELECT actor_id
  FROM film_actor
  WHERE film_id IN (
    SELECT film_id
    FROM film
    WHERE title LIKE 'Alone Trip'
  )
);

TEST non cloncluant !
-- select  first_name, last_name, film.title
-- from ((select actor.actor_id  from actor) as T1, (select film_id  from film_actor) as T2)
-- join film_actor on T1.actor_id = film_actor.actor_id
-- join film on T2.film_id = film.film_id
-- where title like "Alone Trip";

-- SELECT first_name, last_name
-- FROM (SELECT actor.actor_id FROM actor) AS T1
-- JOIN film_actor ON T1.actor_id = film_actor.actor_id;




-- Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.
SELECT film.title, category.name
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
where category.name like "%Fam%";

SELECT film.title, category.name
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
where category.name like "%Fam%";



-- Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.

SELECT customer.email, customer.last_name, country.country
FROM customer
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON city.country_id = country.country_id
WHERE address.address_id IN (SELECT address_id FROM address
WHERE address.city_id IN ( SELECT city_id FROM city
WHERE city.country_id IN (SELECT country_id FROM country
WHERE country.country LIKE '%Canad%')));


-- Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films. First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in
select  first_name, last_name, count(film.title) From actor 
join film_actor on actor.actor_id = film_actor.actor_id
join film on film_actor.film_id = film.film_id
group by first_name, last_name order by count(film.title) desc;

SELECT film.title
FROM film
WHERE film.film_id IN (
  SELECT film_id
  FROM film_actor
  WHERE actor_id IN (
    SELECT actor_id
    FROM actor
    WHERE first_name LIKE '%susan%'
    AND last_name LIKE '%davis%'
  )
);


-- Find the films rented by the most profitable customer in the Sakila database. You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.

select  first_name, last_name, count(1),sum(payment.amount) From customer 
join payment on customer.customer_id = payment.customer_id
group by first_name, last_name order by sum(payment.amount) desc limit 1 ;

SELECT film.title
FROM film
WHERE film.film_id IN (
  SELECT film_id
  FROM inventory
  WHERE inventory.inventory_id IN (
    SELECT rental.inventory_id
    FROM rental
    WHERE rental.rental_id IN (
      SELECT payment.rental_id
      FROM payment
      WHERE payment.customer_id IN (
        SELECT customer.customer_id
        FROM customer
        WHERE customer.first_name LIKE '%Karl%'
        AND customer.last_name LIKE '%Seal%'
      )
    )
  )
);

       


-- Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. You can use subqueries to accomplish this.

SELECT customer_id, SUM(amount) AS total_amount
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > (SELECT AVG(total_amount) FROM (SELECT SUM(amount) AS total_amount FROM payment GROUP BY customer_id) AS subquery);


