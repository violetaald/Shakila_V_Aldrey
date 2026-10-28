# DataProject — Lógica de consultas SQL

**Máster de Data Analytics · ThePower Tech School**

## Objetivo
Resolver los 64 ejercicios del enunciado a partir de la base de datos de alquiler de películas facilitada. El proyecto utiliza **PostgreSQL**, como se comprueba por la sintaxis del dump (`plpgsql`, `CREATE TYPE ... ENUM`, `::regclass`, etc.).

## Estructura

```text
Proyecto_SQL_ThePower/
├── README.md                       # Metodología e informe de análisis
├── datos/
│   └── BBDD_Proyecto_shakila_sinuser.sql  # Base original suministrada
├── docs/
│   └── esquema_bbdd.md            # Diagrama entidad-relación (Mermaid)
└── sql/
    └── consultas_resueltas.sql    # 64 consultas comentadas y numeradas
```

## Pasos seguidos

1. **Revisión del enunciado:** identificación de las 64 consultas y las operaciones solicitadas.
2. **Exploración del esquema:** identificación de las 15 tablas y de las claves primarias y foráneas del dump original.
3. **Modelado de relaciones:** documentación de las uniones entre películas, actores, categorías, inventario, alquileres, clientes y pagos.
4. **Resolución en SQL:** uso de filtros, ordenaciones, agrupaciones, subconsultas, funciones estadísticas, `JOIN`, `LEFT JOIN`, `CROSS JOIN`, `EXISTS`, vistas y tablas temporales.
5. **Documentación:** comentarios con número y enunciado de cada ejercicio, criterios para casos ambiguos y guía de reproducción.

## Cómo ejecutar

1. Instalar PostgreSQL y crear una base vacía, por ejemplo `dataproject`.
2. Importar el dump original en la base. En una terminal con `psql` disponible:

   ```bash
   createdb dataproject
   psql -X -v ON_ERROR_STOP=1 -d dataproject -f datos/BBDD_Proyecto_shakila_sinuser.sql
   ```

3. Ejecutar las soluciones (desde la raíz de este repositorio):

   ```bash
   psql -X -v ON_ERROR_STOP=1 -d dataproject -f sql/consultas_resueltas.sql
   ```

   **Alternativa:** abrir el archivo de consultas en pgAdmin o DBeaver y ejecutar los bloques por separado. Las consultas 51 y 52 crean tablas temporales y deben ejecutarse en la misma sesión en la que se quieran consultar. La 48 crea una vista permanente.

**Aviso de compatibilidad:** el dump facilitado contiene sintaxis antigua (por ejemplo `CREATE OR REPLACE PROCEDURAL LANGUAGE plpgsql` y una función que usa `IF(...)`), por lo que su importación puede requerir ajustes en instalaciones modernas de PostgreSQL. Los ejercicios se escriben para PostgreSQL y no dependen de esas funciones auxiliares. Si aparece un error en la importación, identificar la sentencia que falla antes de continuar; no se debe asumir que toda la base se ha cargado.

## Informe de análisis

### Modelo de datos

La base representa el negocio de alquiler de películas. `film` contiene el catálogo y características de cada película (clasificación, duración, precio de alquiler, coste de reposición). Las tablas `film_actor` y `film_category` vinculan las películas con intérpretes y géneros; `inventory` registra copias físicas por tienda. `rental` registra alquileres y devoluciones, `payment` los importes abonados y `customer` a los clientes.

### Preguntas de negocio abordadas

- **Oferta:** distribución por clasificaciones, géneros, duraciones y costes de reposición (consultas 2–14, 18–20, 24 y 50).
- **Ingresos y clientes:** facturación, gasto por cliente, actividad diaria y mensual, diferencias entre pagos y volumen de alquileres (15, 23, 25–27, 34, 49, 60–64).
- **Popularidad y disponibilidad:** títulos alquilados, frecuencia de alquileres y ejemplares disponibles (29, 33, 52, 53, 57 y 61).
- **Reparto y relaciones:** asociaciones entre películas, actores y categorías, incluidas ausencias mediante `LEFT JOIN` y `NOT EXISTS` (17, 28, 30–32, 45–48, 54–56).

### Interpretación y decisiones metodológicas

- **Consulta 9:** «variabilidad» se interpreta como varianza y desviación estándar del coste de reposición; se añaden mínimo y máximo para contextualizar.
- **Consulta 11:** «antepenúltimo alquiler ordenado por día» se interpreta como el tercer alquiler más reciente por fecha y hora, desempate por identificador; su coste es la suma de los pagos asociados.
- **Consulta 21:** «media de duración del alquiler» se interpreta como la duración contractual (`film.rental_duration`, días), no el tiempo real entre la entrega y la devolución.
- **Consulta 29:** disponible significa copia sin alquiler abierto (`return_date IS NULL`), no solamente registrada en inventario.
- **Consulta 44:** el `CROSS JOIN` produce todas las combinaciones, incluso relaciones irreales; la respuesta explicativa está después del SQL.
- **Consulta 57:** el umbral de ocho días se aplica al intervalo real entre alquiler y devolución; no incluye alquileres aún abiertos.
- **Consulta 58:** «misma categoría que Animation» se interpreta como todas las películas clasificadas en `Animation`.
- **Consultas 49 y 64:** se cuenta cada registro de alquiler, incluso si el cliente alquila el mismo título más de una vez. La 60 exige películas *distintas*.

### Hallazgos e interpretación responsable

Las consultas preparadas permiten cuantificar los ingresos contabilizados, identificar clientes de alto valor, examinar la demanda por categorías y comparar duración y tarifas. **No se incluyen resultados numéricos ni conclusiones cuantitativas inventadas**: para informar cifras reales hace falta ejecutar las consultas sobre una instancia correctamente importada de la base. Una vez ejecutadas, pueden añadirse capturas o una tabla de resultados a este apartado.

## Alcance y comprobación

Se ha comprobado de forma estática que los 64 bloques están numerados, que sus tablas/columnas se basan en el esquema aportado y que las relaciones del diagrama proceden de las claves foráneas del dump. **No se ha realizado una ejecución integral en un servidor PostgreSQL**, por lo que la validación final de resultados y compatibilidad con la versión local corresponde al paso de ejecución anterior.

## Fuente

- Enunciado *DataProject: Lógica Consultas SQL* facilitado para el máster.
- `datos/BBDD_Proyecto_shakila_sinuser.sql`, archivo original aportado para la práctica.
