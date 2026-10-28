-- ========================================================================
-- CONSULTA 01
-- Enunciado: Crea el esquema de la BBDD.
-- ========================================================================
-- El esquema relacional se documenta en docs/esquema_bbdd.md.
-- Las tablas, tipos, secuencias y claves se crean al importar el dump original:
-- datos/BBDD_Proyecto_shakila_sinuser.sql
-- Verificación de las 15 tablas base del esquema public:
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public' AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- ========================================================================
-- CONSULTA 02
-- Enunciado: Muestra los nombres de todas las películas con una clasificación por edades de ‘R’.
-- ========================================================================
SELECT title FROM film WHERE rating = 'R' ORDER BY title;

-- ========================================================================
-- CONSULTA 03
-- Enunciado: Encuentra los nombres de los actores que tengan un “actor_id” entre 30 y 40.
-- ========================================================================
SELECT first_name, last_name FROM actor WHERE actor_id BETWEEN 30 AND 40 ORDER BY actor_id;

-- ========================================================================
-- CONSULTA 04
-- Enunciado: Obtén las películas cuyo idioma coincide con el idioma original.
-- ========================================================================
SELECT film_id, title FROM film WHERE original_language_id IS NOT NULL AND language_id = original_language_id ORDER BY title;

-- ========================================================================
-- CONSULTA 05
-- Enunciado: Ordena las películas por duración de forma ascendente.
-- ========================================================================
SELECT title, length FROM film ORDER BY length ASC NULLS LAST, title;

-- ========================================================================
-- CONSULTA 06
-- Enunciado: Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su apellido.
-- ========================================================================
SELECT first_name, last_name FROM actor WHERE last_name ILIKE '%Allen%' ORDER BY last_name, first_name;

-- ========================================================================
-- CONSULTA 07
-- Enunciado: Encuentra la cantidad total de películas en cada clasificación de la tabla “film” y muestra la clasificación junto con el recuento.
-- ========================================================================
SELECT rating, COUNT(*) AS total_peliculas FROM film GROUP BY rating ORDER BY rating;

-- ========================================================================
-- CONSULTA 08
-- Enunciado: Encuentra el título de todas las películas que son ‘PG-13’ o tienen una duración mayor a 3 horas en la tabla film.
-- ========================================================================
SELECT title, rating, length FROM film WHERE rating = 'PG-13' OR length > 180 ORDER BY title;

-- ========================================================================
-- CONSULTA 09
-- Enunciado: Encuentra la variabilidad de lo que costaría reemplazar las películas.
-- ========================================================================
SELECT ROUND(VARIANCE(replacement_cost)::numeric, 2) AS varianza_coste_reposicion, ROUND(STDDEV(replacement_cost)::numeric, 2) AS desviacion_coste_reposicion, MIN(replacement_cost) AS minimo, MAX(replacement_cost) AS maximo FROM film;

-- ========================================================================
-- CONSULTA 10
-- Enunciado: Encuentra la mayor y menor duración de una película de nuestra BBDD.
-- ========================================================================
SELECT MIN(length) AS duracion_minima, MAX(length) AS duracion_maxima FROM film;

-- ========================================================================
-- CONSULTA 11
-- Enunciado: Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
-- ========================================================================
-- Antepenúltimo alquiler cronológicamente: pago asociado al tercer alquiler más reciente.
-- Si el alquiler tiene varios pagos, se devuelve su importe total.
SELECT r.rental_id, r.rental_date, COALESCE(SUM(p.amount), 0) AS coste_alquiler
FROM rental r LEFT JOIN payment p ON p.rental_id = r.rental_id
GROUP BY r.rental_id, r.rental_date
ORDER BY r.rental_date DESC, r.rental_id DESC
OFFSET 2 LIMIT 1;

-- ========================================================================
-- CONSULTA 12
-- Enunciado: Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC- 17’ ni ‘G’ en cuanto a su clasificación.
-- ========================================================================
SELECT title FROM film WHERE rating NOT IN ('NC-17', 'G') ORDER BY title;

-- ========================================================================
-- CONSULTA 13
-- Enunciado: Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
-- ========================================================================
SELECT rating, ROUND(AVG(length), 2) AS duracion_media_min FROM film GROUP BY rating ORDER BY rating;

-- ========================================================================
-- CONSULTA 14
-- Enunciado: Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.
-- ========================================================================
SELECT title, length FROM film WHERE length > 180 ORDER BY length DESC, title;

-- ========================================================================
-- CONSULTA 15
-- Enunciado: ¿Cuánto dinero ha generado en total la empresa?
-- ========================================================================
SELECT COALESCE(SUM(amount), 0) AS ingresos_totales FROM payment;

-- ========================================================================
-- CONSULTA 16
-- Enunciado: Muestra los 10 clientes con mayor valor de id.
-- ========================================================================
SELECT customer_id, first_name, last_name FROM customer ORDER BY customer_id DESC LIMIT 10;

-- ========================================================================
-- CONSULTA 17
-- Enunciado: Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’.
-- ========================================================================
SELECT DISTINCT a.first_name, a.last_name FROM actor a JOIN film_actor fa ON fa.actor_id = a.actor_id JOIN film f ON f.film_id = fa.film_id WHERE f.title = 'Egg Igby' ORDER BY a.last_name, a.first_name;

-- ========================================================================
-- CONSULTA 18
-- Enunciado: Selecciona todos los nombres de las películas únicos.
-- ========================================================================
SELECT DISTINCT title FROM film ORDER BY title;

-- ========================================================================
-- CONSULTA 19
-- Enunciado: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “film”.
-- ========================================================================
SELECT f.title, f.length FROM film f JOIN film_category fc ON fc.film_id = f.film_id JOIN category c ON c.category_id = fc.category_id WHERE c.name = 'Comedy' AND f.length > 180 ORDER BY f.title;

-- ========================================================================
-- CONSULTA 20
-- Enunciado: Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración.
-- ========================================================================
SELECT c.name AS categoria, ROUND(AVG(f.length), 2) AS duracion_media_min FROM category c JOIN film_category fc ON fc.category_id = c.category_id JOIN film f ON f.film_id = fc.film_id GROUP BY c.category_id, c.name HAVING AVG(f.length) > 110 ORDER BY duracion_media_min DESC, c.name;

-- ========================================================================
-- CONSULTA 21
-- Enunciado: ¿Cuál es la media de duración del alquiler de las películas?
-- ========================================================================
-- Duración contractual media del alquiler, expresada en días.
SELECT ROUND(AVG(rental_duration), 2) AS duracion_media_alquiler_dias FROM film;

-- ========================================================================
-- CONSULTA 22
-- Enunciado: Crea una columna con el nombre y apellidos de todos los actores y actrices.
-- ========================================================================
SELECT actor_id, CONCAT_WS(' ', first_name, last_name) AS nombre_completo FROM actor ORDER BY actor_id;

-- ========================================================================
-- CONSULTA 23
-- Enunciado: Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.
-- ========================================================================
SELECT rental_date::date AS fecha, COUNT(*) AS alquileres FROM rental GROUP BY rental_date::date ORDER BY alquileres DESC, fecha;

-- ========================================================================
-- CONSULTA 24
-- Enunciado: Encuentra las películas con una duración superior al promedio.
-- ========================================================================
SELECT title, length FROM film WHERE length > (SELECT AVG(length) FROM film) ORDER BY length DESC, title;

-- ========================================================================
-- CONSULTA 25
-- Enunciado: Averigua el número de alquileres registrados por mes.
-- ========================================================================
SELECT DATE_TRUNC('month', rental_date)::date AS mes, COUNT(*) AS alquileres FROM rental GROUP BY DATE_TRUNC('month', rental_date)::date ORDER BY mes;

-- ========================================================================
-- CONSULTA 26
-- Enunciado: Encuentra el promedio, la desviación estándar y varianza del total pagado.
-- ========================================================================
SELECT ROUND(AVG(amount), 2) AS pago_medio, ROUND(STDDEV_SAMP(amount), 2) AS desviacion_estandar, ROUND(VAR_SAMP(amount), 2) AS varianza FROM payment;

-- ========================================================================
-- CONSULTA 27
-- Enunciado: ¿Qué películas se alquilan por encima del precio medio?
-- ========================================================================
SELECT title, rental_rate FROM film WHERE rental_rate > (SELECT AVG(rental_rate) FROM film) ORDER BY rental_rate DESC, title;

-- ========================================================================
-- CONSULTA 28
-- Enunciado: Muestra el id de los actores que hayan participado en más de 40 películas.
-- ========================================================================
SELECT actor_id, COUNT(DISTINCT film_id) AS numero_peliculas FROM film_actor GROUP BY actor_id HAVING COUNT(DISTINCT film_id) > 40 ORDER BY numero_peliculas DESC, actor_id;

-- ========================================================================
-- CONSULTA 29
-- Enunciado: Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.
-- ========================================================================
-- Disponibles: ejemplares sin ningún alquiler abierto (return_date IS NULL).
SELECT f.film_id, f.title, COUNT(i.inventory_id) FILTER (
    WHERE NOT EXISTS (SELECT 1 FROM rental r WHERE r.inventory_id = i.inventory_id AND r.return_date IS NULL)
) AS ejemplares_disponibles
FROM film f LEFT JOIN inventory i ON i.film_id = f.film_id
GROUP BY f.film_id, f.title ORDER BY f.title;

-- ========================================================================
-- CONSULTA 30
-- Enunciado: Obtener los actores y el número de películas en las que ha actuado.
-- ========================================================================
SELECT a.actor_id, a.first_name, a.last_name, COUNT(DISTINCT fa.film_id) AS numero_peliculas FROM actor a LEFT JOIN film_actor fa ON fa.actor_id = a.actor_id GROUP BY a.actor_id, a.first_name, a.last_name ORDER BY numero_peliculas DESC, a.actor_id;

-- ========================================================================
-- CONSULTA 31
-- Enunciado: Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.
-- ========================================================================
SELECT f.film_id, f.title, a.actor_id, a.first_name, a.last_name FROM film f LEFT JOIN film_actor fa ON fa.film_id = f.film_id LEFT JOIN actor a ON a.actor_id = fa.actor_id ORDER BY f.title, a.last_name, a.first_name;

-- ========================================================================
-- CONSULTA 32
-- Enunciado: Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.
-- ========================================================================
SELECT a.actor_id, a.first_name, a.last_name, f.film_id, f.title FROM actor a LEFT JOIN film_actor fa ON fa.actor_id = a.actor_id LEFT JOIN film f ON f.film_id = fa.film_id ORDER BY a.last_name, a.first_name, f.title;

-- ========================================================================
-- CONSULTA 33
-- Enunciado: Obtener todas las películas que tenemos y todos los registros de alquiler.
-- ========================================================================
-- LEFT JOIN conserva películas sin alquileres; cada fila adicional es un alquiler.
SELECT f.film_id, f.title, r.rental_id, r.rental_date, r.return_date
FROM film f LEFT JOIN inventory i ON i.film_id = f.film_id
LEFT JOIN rental r ON r.inventory_id = i.inventory_id
ORDER BY f.film_id, r.rental_date, r.rental_id;

-- ========================================================================
-- CONSULTA 34
-- Enunciado: Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
-- ========================================================================
SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_gastado FROM customer c JOIN payment p ON p.customer_id = c.customer_id GROUP BY c.customer_id, c.first_name, c.last_name ORDER BY total_gastado DESC, c.customer_id LIMIT 5;

-- ========================================================================
-- CONSULTA 35
-- Enunciado: Selecciona todos los actores cuyo primer nombre es 'Johnny'.
-- ========================================================================
SELECT actor_id, first_name, last_name FROM actor WHERE first_name = 'Johnny' ORDER BY last_name;

-- ========================================================================
-- CONSULTA 36
-- Enunciado: Renombra la columna “first_name” como Nombre y “last_name” como Apellido.
-- ========================================================================
SELECT first_name AS "Nombre", last_name AS "Apellido" FROM actor ORDER BY last_name, first_name;

-- ========================================================================
-- CONSULTA 37
-- Enunciado: Encuentra el ID del actor más bajo y más alto en la tabla actor.
-- ========================================================================
SELECT MIN(actor_id) AS actor_id_min, MAX(actor_id) AS actor_id_max FROM actor;

-- ========================================================================
-- CONSULTA 38
-- Enunciado: Cuenta cuántos actores hay en la tabla “actor”.
-- ========================================================================
SELECT COUNT(*) AS total_actores FROM actor;

-- ========================================================================
-- CONSULTA 39
-- Enunciado: Selecciona todos los actores y ordénalos por apellido en orden ascendente.
-- ========================================================================
SELECT * FROM actor ORDER BY last_name ASC, first_name ASC;

-- ========================================================================
-- CONSULTA 40
-- Enunciado: Selecciona las primeras 5 películas de la tabla “film”.
-- ========================================================================
SELECT * FROM film ORDER BY film_id LIMIT 5;

-- ========================================================================
-- CONSULTA 41
-- Enunciado: Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?
-- ========================================================================
SELECT first_name, COUNT(*) AS veces_repetido FROM actor GROUP BY first_name ORDER BY veces_repetido DESC, first_name LIMIT 1;

-- ========================================================================
-- CONSULTA 42
-- Enunciado: Encuentra todos los alquileres y los nombres de los clientes que los realizaron.
-- ========================================================================
SELECT r.rental_id, r.rental_date, c.customer_id, c.first_name, c.last_name FROM rental r JOIN customer c ON c.customer_id = r.customer_id ORDER BY r.rental_id;

-- ========================================================================
-- CONSULTA 43
-- Enunciado: Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.
-- ========================================================================
SELECT c.customer_id, c.first_name, c.last_name, r.rental_id, r.rental_date FROM customer c LEFT JOIN rental r ON r.customer_id = c.customer_id ORDER BY c.customer_id, r.rental_date;

-- ========================================================================
-- CONSULTA 44
-- Enunciado: Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.
-- ========================================================================
SELECT f.film_id, f.title, c.category_id, c.name AS categoria
FROM film f CROSS JOIN category c
ORDER BY f.film_id, c.category_id;
-- Respuesta: no aporta valor analítico directo para conocer la categoría real de cada película.
-- Crea TODAS las combinaciones posibles, incluidas asociaciones falsas. Para las
-- categorías reales se utilizan film_category y JOIN con category.

-- ========================================================================
-- CONSULTA 45
-- Enunciado: Encuentra los actores que han participado en películas de la categoría 'Action'.
-- ========================================================================
SELECT DISTINCT a.actor_id, a.first_name, a.last_name FROM actor a JOIN film_actor fa ON fa.actor_id = a.actor_id JOIN film_category fc ON fc.film_id = fa.film_id JOIN category c ON c.category_id = fc.category_id WHERE c.name = 'Action' ORDER BY a.last_name, a.first_name;

-- ========================================================================
-- CONSULTA 46
-- Enunciado: Encuentra todos los actores que no han participado en películas.
-- ========================================================================
SELECT a.actor_id, a.first_name, a.last_name FROM actor a WHERE NOT EXISTS (SELECT 1 FROM film_actor fa WHERE fa.actor_id = a.actor_id) ORDER BY a.last_name, a.first_name;

-- ========================================================================
-- CONSULTA 47
-- Enunciado: Selecciona el nombre de los actores y la cantidad de películas en las que han participado.
-- ========================================================================
SELECT a.first_name, a.last_name, COUNT(DISTINCT fa.film_id) AS cantidad_peliculas FROM actor a LEFT JOIN film_actor fa ON fa.actor_id = a.actor_id GROUP BY a.actor_id, a.first_name, a.last_name ORDER BY cantidad_peliculas DESC, a.last_name, a.first_name;

-- ========================================================================
-- CONSULTA 48
-- Enunciado: Crea una vista llamada “actor_num_peliculas” que muestre los nombres de los actores y el número de películas en las que han participado.
-- ========================================================================
CREATE OR REPLACE VIEW actor_num_peliculas AS
SELECT a.actor_id, a.first_name, a.last_name, COUNT(DISTINCT fa.film_id) AS numero_peliculas
FROM actor a LEFT JOIN film_actor fa ON fa.actor_id = a.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name;
SELECT * FROM actor_num_peliculas ORDER BY numero_peliculas DESC, actor_id;

-- ========================================================================
-- CONSULTA 49
-- Enunciado: Calcula el número total de alquileres realizados por cada cliente.
-- ========================================================================
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_alquileres FROM customer c LEFT JOIN rental r ON r.customer_id = c.customer_id GROUP BY c.customer_id, c.first_name, c.last_name ORDER BY total_alquileres DESC, c.customer_id;

-- ========================================================================
-- CONSULTA 50
-- Enunciado: Calcula la duración total de las películas en la categoría 'Action'.
-- ========================================================================
SELECT COALESCE(SUM(f.length), 0) AS minutos_totales_action FROM film f JOIN film_category fc ON fc.film_id = f.film_id JOIN category c ON c.category_id = fc.category_id WHERE c.name = 'Action';

-- ========================================================================
-- CONSULTA 51
-- Enunciado: Crea una tabla temporal llamada “cliente_rentas_temporal” para almacenar el total de alquileres por cliente.
-- ========================================================================
DROP TABLE IF EXISTS cliente_rentas_temporal;
CREATE TEMP TABLE cliente_rentas_temporal AS
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_alquileres
FROM customer c LEFT JOIN rental r ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;
SELECT * FROM cliente_rentas_temporal ORDER BY total_alquileres DESC, customer_id;

-- ========================================================================
-- CONSULTA 52
-- Enunciado: Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las películas que han sido alquiladas al menos 10 veces.
-- ========================================================================
DROP TABLE IF EXISTS peliculas_alquiladas;
CREATE TEMP TABLE peliculas_alquiladas AS
SELECT f.film_id, f.title, COUNT(r.rental_id) AS veces_alquilada
FROM film f JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
GROUP BY f.film_id, f.title HAVING COUNT(r.rental_id) >= 10;
SELECT * FROM peliculas_alquiladas ORDER BY veces_alquilada DESC, title;

-- ========================================================================
-- CONSULTA 53
-- Enunciado: Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película.
-- ========================================================================
SELECT DISTINCT f.title FROM customer c JOIN rental r ON r.customer_id = c.customer_id JOIN inventory i ON i.inventory_id = r.inventory_id JOIN film f ON f.film_id = i.film_id WHERE c.first_name = 'Tammy' AND c.last_name = 'Sanders' AND r.return_date IS NULL ORDER BY f.title;

-- ========================================================================
-- CONSULTA 54
-- Enunciado: Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados alfabéticamente por apellido.
-- ========================================================================
SELECT DISTINCT a.first_name, a.last_name FROM actor a JOIN film_actor fa ON fa.actor_id = a.actor_id JOIN film_category fc ON fc.film_id = fa.film_id JOIN category c ON c.category_id = fc.category_id WHERE c.name = 'Sci-Fi' ORDER BY a.last_name, a.first_name;

-- ========================================================================
-- CONSULTA 55
-- Enunciado: Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus Cheaper’ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.
-- ========================================================================
-- Fecha del PRIMER alquiler de Spartacus Cheaper.
-- Se incluyen actores de películas con al menos un alquiler posterior.
SELECT DISTINCT a.first_name, a.last_name
FROM actor a JOIN film_actor fa ON fa.actor_id = a.actor_id
JOIN inventory i ON i.film_id = fa.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
WHERE r.rental_date > (
    SELECT MIN(r0.rental_date)
    FROM film f0 JOIN inventory i0 ON i0.film_id = f0.film_id
    JOIN rental r0 ON r0.inventory_id = i0.inventory_id
    WHERE f0.title = 'Spartacus Cheaper'
)
ORDER BY a.last_name, a.first_name;

-- ========================================================================
-- CONSULTA 56
-- Enunciado: Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Music’.
-- ========================================================================
SELECT a.first_name, a.last_name FROM actor a
WHERE NOT EXISTS (
    SELECT 1 FROM film_actor fa JOIN film_category fc ON fc.film_id = fa.film_id
    JOIN category c ON c.category_id = fc.category_id
    WHERE fa.actor_id = a.actor_id AND c.name = 'Music'
) ORDER BY a.last_name, a.first_name;

-- ========================================================================
-- CONSULTA 57
-- Enunciado: Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.
-- ========================================================================
-- Duración real, solo alquileres ya devueltos, estrictamente > 8 días.
SELECT DISTINCT f.title FROM film f JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
WHERE r.return_date - r.rental_date > INTERVAL '8 days' ORDER BY f.title;

-- ========================================================================
-- CONSULTA 58
-- Enunciado: Encuentra el título de todas las películas que son de la misma categoría que ‘Animation’.
-- ========================================================================
SELECT DISTINCT f.title FROM film f JOIN film_category fc ON fc.film_id = f.film_id JOIN category c ON c.category_id = fc.category_id WHERE c.name = 'Animation' ORDER BY f.title;

-- ========================================================================
-- CONSULTA 59
-- Enunciado: Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Fever’. Ordena los resultados alfabéticamente por título de película.
-- ========================================================================
SELECT title, length FROM film WHERE length IN (SELECT length FROM film WHERE title = 'Dancing Fever') ORDER BY title;

-- ========================================================================
-- CONSULTA 60
-- Enunciado: Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.
-- ========================================================================
SELECT c.first_name, c.last_name FROM customer c JOIN rental r ON r.customer_id = c.customer_id JOIN inventory i ON i.inventory_id = r.inventory_id GROUP BY c.customer_id, c.first_name, c.last_name HAVING COUNT(DISTINCT i.film_id) >= 7 ORDER BY c.last_name, c.first_name;

-- ========================================================================
-- CONSULTA 61
-- Enunciado: Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
-- ========================================================================
SELECT c.name AS categoria, COUNT(r.rental_id) AS total_alquileres FROM category c LEFT JOIN film_category fc ON fc.category_id = c.category_id LEFT JOIN inventory i ON i.film_id = fc.film_id LEFT JOIN rental r ON r.inventory_id = i.inventory_id GROUP BY c.category_id, c.name ORDER BY total_alquileres DESC, c.name;

-- ========================================================================
-- CONSULTA 62
-- Enunciado: Encuentra el número de películas por categoría estrenadas en 2006.
-- ========================================================================
SELECT c.name AS categoria, COUNT(DISTINCT f.film_id) AS peliculas_estrenadas_2006 FROM category c LEFT JOIN film_category fc ON fc.category_id = c.category_id LEFT JOIN film f ON f.film_id = fc.film_id AND f.release_year = 2006 GROUP BY c.category_id, c.name ORDER BY c.name;

-- ========================================================================
-- CONSULTA 63
-- Enunciado: Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.
-- ========================================================================
SELECT s.staff_id, s.first_name, s.last_name, st.store_id FROM staff s CROSS JOIN store st ORDER BY s.staff_id, st.store_id;

-- ========================================================================
-- CONSULTA 64
-- Enunciado: Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
-- ========================================================================
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS cantidad_peliculas_alquiladas FROM customer c LEFT JOIN rental r ON r.customer_id = c.customer_id GROUP BY c.customer_id, c.first_name, c.last_name ORDER BY cantidad_peliculas_alquiladas DESC, c.customer_id;
