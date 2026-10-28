# Esquema de la base de datos

Diagrama de relaciones **extraído de las claves foráneas del archivo SQL original**.

```mermaid
erDiagram
    city ||--o{ address : "city_id"
    country ||--o{ city : "country_id"
    address ||--o{ customer : "address_id"
    store ||--o{ customer : "store_id"
    actor ||--o{ film_actor : "actor_id"
    film ||--o{ film_actor : "film_id"
    category ||--o{ film_category : "category_id"
    film ||--o{ film_category : "film_id"
    language ||--o{ film : "language_id"
    language ||--o{ film : "original_language_id"
    film ||--o{ inventory : "film_id"
    store ||--o{ inventory : "store_id"
    customer ||--o{ payment : "customer_id"
    rental ||--o{ payment : "rental_id"
    staff ||--o{ payment : "staff_id"
    customer ||--o{ rental : "customer_id"
    inventory ||--o{ rental : "inventory_id"
    staff ||--o{ rental : "staff_id"
    address ||--o{ staff : "address_id"
    store ||--o{ staff : "store_id"
    address ||--o{ store : "address_id"
    staff ||--o{ store : "manager_staff_id"
```

## Tablas del modelo

El esquema `public` define **15 tablas**: `actor`, `category`, `film`, `film_actor`, `film_category`, `address`, `city`, `country`, `customer`, `inventory`, `language`, `payment`, `rental`, `staff`, `store`.

## Relaciones clave

- `film` ↔ `actor` a través de `film_actor` (muchos a muchos).
- `film` ↔ `category` a través de `film_category` (muchos a muchos).
- `film` → `inventory` → `rental` → `payment` permite analizar copias, alquileres e ingresos.
- `customer` → `rental` y `customer` → `payment` permite analizar el comportamiento por cliente.
- `staff`, `store`, `address`, `city` y `country` describen la operación y ubicación.

El fichero fuente contiene además tipos, funciones, índices, triggers y registros de muestra. El diagrama muestra relaciones declaradas como claves foráneas, no todas las dependencias lógicas posibles.
