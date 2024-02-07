SELECT * FROM sakila.film;

-- 1. Calculate the average rental duration (in days) for each film:

SELECT title, rental_duration,
AVG(rental_duration) OVER () AS avg_rental_duration
FROM film
GROUP BY title, rental_duration;

-- 2. Calculate the average payment amount for each staff member:

SELECT * FROM sakila.payment;

SELECT staff_id,
AVG(amount) OVER (partition by staff_id) AS avg_payment_amount
FROM payment;

-- 3. Calculate the total revenue for each customer, showing the running total within each customer's rental history:

SELECT * FROM sakila.rental;

SELECT customer.customer_id, rental.rental_id, rental_date, amount, 
SUM(amount) OVER (PARTITION BY customer.customer_id ORDER BY rental.rental_date) AS running_total
FROM customer
JOIN payment
ON customer.customer_id=payment.customer_id
JOIN rental
ON payment.rental_id=rental.rental_id;

-- 4. Determine the quartile for the rental rates of films:

SELECT title, rental_rate,
NTILE(4) OVER (ORDER BY title) AS quartile
FROM film
JOIN inventory
ON film.film_id=inventory.film_id
JOIN rental
ON inventory.inventory_id=rental.inventory_id;

-- 5. Determine the first and last rental date for each customer:

SELECT
    customer_id,
    MIN(rental_date) AS first_rental_date,
    MAX(rental_date) AS last_rental_date
FROM
    rental
GROUP BY
    customer_id;

-- 6. Calculate the rank of customers based on their rental counts:

SELECT customer_id, 
COUNT(customer_id) AS rental_count,
RANK() OVER (ORDER BY COUNT(customer_id) DESC) AS rental_count_rank
FROM rental
GROUP BY customer_id;

-- 7. Calculate the running total of revenue per day for the 'G' film category:

SELECT * FROM film;

SELECT title AS film_category, rental_date, amount,
SUM(amount) OVER (PARTITION BY rental_date ORDER BY rating) AS daily_revenue
FROM film
JOIN inventory
ON film.film_id=inventory.film_id
JOIN rental
ON inventory.inventory_id=rental.inventory_id
JOIN payment
ON rental.rental_id=payment_id
WHERE rating = "G";

-- 8. Assign a unique ID to each payment within each customer's payment history:

SELECT customer_id, payment_id,
ROW_NUMBER () OVER (PARTITION BY customer_id ORDER BY payment_id) AS payment_sequence_id
FROM payment;


-- 9. Calculate the difference in days between each rental and the previous rental for each customer:

SELECT customer_id, rental_id, rental_date,
LAG(rental_date) OVER (PARTITION BY customer_id ORDER BY rental_id) AS previous_rental_date,
DATEDIFF(rental_date, LAG(rental_date) OVER (PARTITION BY customer_id ORDER BY rental_id)) AS days_between_rental
FROM rental;

