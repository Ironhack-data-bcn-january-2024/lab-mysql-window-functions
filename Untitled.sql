USE shakila;
-- 1. Calculate the average rental duration (in days) for each film:

SELECT title, AVG(DATEDIFF(return_date,rental_date)) as avg_days
FROM rental
	JOIN inventory
		ON rental.inventory_id = inventory.inventory_id
    JOIN film
		ON inventory.film_id = film.film_id
GROUP BY title;

-- 2. Calculate the average payment amount for each staff member:

SELECT staff_id, AVG(amount) FROM payment
GROUP BY staff_id;


-- 3. Calculate the total revenue for each customer, showing
	-- the running total within each customer's rental history:

SELECT customer_id, SUM(amount) as tot_rev
FROM payment
GROUP BY customer_id;

-- 4. Determine the quartile for the rental rates of films:

SELECT rental_rate, 
       NTILE(4) OVER (ORDER BY rental_rate) AS quartile
FROM film;

-- 5. Determine the first and last rental date for each customer:

SELECT customer_id, 
       MIN(rental_date) AS first_rental_date,
       MAX(rental_date) AS last_rental_date
FROM rental
GROUP BY customer_id;


-- 6. Calculate the rank of customers based on their rental counts:

SELECT customer_id,
RANK() OVER (ORDER BY COUNT(rental_date) DESC) AS rank_rate
FROM rental
GROUP BY customer_id;


-- 7. Calculate the running total of revenue per day for the 'G' film category:

SELECT rental_date,
SUM(amount) OVER (ORDER BY rental_date) AS running_total
FROM rental
	JOIN payment
		ON rental.rental_id = payment.rental_id
	JOIN inventory
		ON rental.inventory_id = inventory.inventory_id
	JOIN film
		ON inventory.film_id = film.film_id
WHERE rating = 'G'
GROUP BY rental_date;



-- 8. Assign a unique ID to each payment within each customer's payment history:

SELECT customer_id, payment_id,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY payment_date) AS payment_sequence_id
    FROM payment;


-- 9. Calculate the difference in days between each rental and the previous
--  rental for each customer:

 SELECT
    customer_id,
    rental_date,
    LAG(rental_date) OVER (PARTITION BY customer_id ORDER BY rental_date) AS previous_rental_date,
    DATEDIFF(rental_date, LAG(rental_date) OVER (PARTITION BY customer_id ORDER BY rental_date)) AS diff
FROM
    rental
ORDER BY
    customer_id, rental_date;