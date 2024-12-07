SELECT * FROM ejercicios_c.datos;
-- Query para condensar las busqueda por años
SELECT
	EXTRACT(YEAR FROM date) AS busqueda,
    SUM(Crédito) AS credito
FROM datos
group by 1;

-- Query para saber cuál ha sido el mes en que más busqueda se han realizado

SELECT
	date AS fecha,
    SUM(Crédito) OVER(ORDER BY date) AS bus,
    SUM(Crédito)
FROM datos;


-- El anterior no jalo
SELECT
	date,
    crédito,
    SUM(Crédito)
FROM datos
GROUP BY 1;

-- Estacionalidad
-- Periodo vs Periodo

SELECT
	date AS fecha,
    Crédito,
    LAG(date) OVER(ORDER BY date) AS dia_prev,
    LAG(Crédito) OVER(ORDER BY date) AS cre_prev
FROM datos;


-- Calcular el porcentaje de variacion a lo largo de los meses
SELECT
	date AS fecha,
    Crédito,
    LAG(date) OVER(ORDER BY date) AS dia_prev,
    LAG(Crédito) OVER(ORDER BY date) AS cre_prev,
    (Crédito/ LAG(Crédito) OVER(ORDER BY date)-1)* 100 AS pct_per
FROM datos;

-- Calcular el porcentaje de variacion a lo largo de los año vs año

SELECT	
	año,
    bus_an,
    LAG(bus_an) OVER(ORDER BY año) AS año_pre,
    (bus_an/ LAG(bus_an) OVER(ORDER BY año)-1)* 100 AS pct_crec
FROM(
	SELECT
			EXTRACT(YEAR FROM date) AS año,
			SUM(Crédito) AS bus_an
	FROM datos
	GROUP BY 1) AS a;

-- Sacar las búsquedas de los meses por los diferentes Años
SELECT
	date AS fecha,
	Crédito,
	EXTRACT(MONTH FROM date) AS mes,
    LAG(date) OVER (PARTITION  BY EXTRACT(MONTH FROM date) ORDER BY date) AS mes_año_previo,
    LAG(Crédito) OVER(PARTITION  BY EXTRACT(MONTH FROM date) ORDER BY date) AS bus_año_previo
FROM datos
GROUP BY 1;


-- Lo mismo que lo anterior pero ahora con el porcentaje 
SELECT
	date AS fecha,
	Crédito,
	EXTRACT(MONTH FROM date) AS mes,
    LAG(date) OVER (PARTITION  BY EXTRACT(MONTH FROM date) ORDER BY date) AS mes_año_previo,
    LAG(Crédito) OVER(PARTITION  BY EXTRACT(MONTH FROM date) ORDER BY date) AS bus_año_previo,
    Crédito - LAG(Crédito) OVER(PARTITION  BY EXTRACT(MONTH FROM date) ORDER BY date) AS dif_abs,
    (Crédito / LAG(Crédito) OVER(PARTITION  BY EXTRACT(MONTH FROM date) ORDER BY date)-1) * 100 AS pct_cre
FROM datos
GROUP BY 1;

-- Analizar los meses en sus varios periodos previos en este caso vamos a analizar 3 años
SELECT
	date AS fecha,
    Crédito,
    LAG(Crédito,1) OVER(PARTITION  BY EXTRACT(MONTH FROM date) ORDER BY date) AS ventas_pre1,
    LAG(Crédito,2) OVER(PARTITION  BY EXTRACT(MONTH FROM date) ORDER BY date) AS ventas_pre2,
    LAG(Crédito,3) OVER(PARTITION  BY EXTRACT(MONTH FROM date) ORDER BY date) AS ventas_pre3
FROM datos
GROUP BY 1;

-- Analizar los meses contra los 3 años anteriores
SELECT
	date AS fecha,
    Crédito,
    AVG(Crédito) OVER(PARTITION BY EXTRACT(MONTH FROM date) ORDER BY date ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING) AS prom_tres,
    Crédito / AVG(Crédito) OVER(PARTITION BY EXTRACT(MONTH FROM date) ORDER BY date ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING) AS pct_cred
FROM datos
GROUP BY 1;

-- Ventanas Moviles
SELECT
	date AS fecha,
    Crédito,
    AVG(Crédito) OVER(ORDER BY date ROWS BETWEEN 11 PRECEDING AND CURRENT ROW) AS promedio_movil,
	COUNT(Crédito) OVER(ORDER BY date ROWS BETWEEN 11 PRECEDING AND CURRENT ROW) AS num_reg
FROM datos;