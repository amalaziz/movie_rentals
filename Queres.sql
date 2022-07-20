

--------------------------------------Slide 1------------------------------------

--Set#1-Question 1 query:--
SELECT  sub.category_name, 
      sum(sub.rental_count) as sum_count
FROM

(SELECT film.title as film_title,
       category.name as category_name,
       COUNT(rental.rental_id) AS rental_count
  FROM category 
       JOIN film_category AS f_c
        ON category.category_id = f_c.category_id
        AND category.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')

       JOIN film 
        ON film.film_id = f_c.film_id

       JOIN inventory 
        ON film.film_id = inventory.film_id

       JOIN rental
    ON inventory.inventory_id = rental.inventory_id
    
 GROUP BY film_title, category_name
 ORDER BY category_name, film_title) sub 
 
 GROUP BY sub.category_name;


--------------------------------------Slide 2------------------------------------

--Set#1-Question 3 query:--

SELECT sub.name, sub.standard_quartile, 
      COUNT(sub.standard_quartile)
FROM
      (SELECT film.title, category.name , film.rental_duration, NTILE(4) OVER (ORDER BY film.rental_duration) AS standard_quartile
    FROM film_category AS f_c
       JOIN category 
         ON category.category_id = f_c.category_id
       JOIN film 
         ON film.film_id = f_c.film_id
and category.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')) sub 
                      
GROUP BY sub.name, sub.standard_quartile
ORDER BY sub.name, sub.standard_quartile;


--------------------------------------Slide 3------------------------------------

--Set#2-Question 1 query:--

SELECT DATE_PART('month', rental.rental_date) AS Rental_month, 
       DATE_PART('year', rental.rental_date) AS Rental_year,
       (store.store_id) as storee_id,
       COUNT(*) as Count_rentals
  FROM store 
       JOIN staff 
        ON store.store_id = staff.store_id
		
       JOIN rental 
        ON staff.staff_id = rental.staff_id
        
 GROUP BY Rental_month, Rental_year, storee_id
 ORDER BY Rental_year, Rental_month;

--------------------------------------Slide 4------------------------------------


--Set#2-Question 2 query:--

SELECT DATE_TRUNC('month', payment.payment_date)AS pay_month,
        customer.first_name || ' ' || customer.last_name AS full_name, 
        COUNT(payment.amount) AS pay_countpermon, SUM(payment.amount) AS pay_amount
FROM customer 
    JOIN payment 
       ON payment.customer_id = customer.customer_id

 WHERE customer.first_name || ' ' || customer.last_name IN
    (SELECT sub.full_name
      FROM
            (SELECT customer.first_name || ' ' || customer.last_name AS full_name, SUM(payment.amount) AS amount
             FROM customer 
               JOIN payment 
                ON payment.customer_id = customer.customer_id	

GROUP BY full_name
ORDER BY amount DESC 
         LIMIT 10)
         sub) AND (payment.payment_date BETWEEN '2007-01-01' AND '2008-01-01')

GROUP BY full_name, pay_month
ORDER BY full_name, pay_month, pay_countpermon;
