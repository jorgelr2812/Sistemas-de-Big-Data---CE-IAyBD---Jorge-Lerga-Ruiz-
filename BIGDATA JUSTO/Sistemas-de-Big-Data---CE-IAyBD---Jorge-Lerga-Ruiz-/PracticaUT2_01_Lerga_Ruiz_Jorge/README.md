# Práctica 01: Diseño de una base de datos documental con MongoDB

En esta práctica he creado una base de datos para una tienda online. El objetivo es guardar productos, categorías y usuarios, además de realizar consultas para controlar los precios, las existencias y las valoraciones de los productos.

He utilizado MongoDB y MongoDB Compass para crear la base de datos y realizar las pruebas.

---

## 1. Conexión a MongoDB

La base de datos utilizada se llama `prueba1` y contiene tres colecciones:

- `productos`
- `categorias`
- `usuarios`

Para trabajar con la base de datos desde `mongosh`, primero hay que conectarse al servidor local de MongoDB y ejecutar:

```javascript
use prueba1
show collections
```

Para consultar la versión de MongoDB utilizada:

```javascript
db.version()
```

## 2. Contenido de la práctica

La práctica está dividida en varios apartados:

1. **Diseño del modelo:** explicación de las colecciones, las relaciones y los datos que he decidido guardar dentro de cada producto.
2. **Colecciones y validación:** organización de los datos y reglas para evitar introducir información incorrecta.
3. **Datos de prueba:** productos, categorías y usuarios inventados para realizar las pruebas.
4. **Consultas e índices:** inserción, actualización, búsquedas, ordenación, relaciones con `$lookup` y agregaciones.
5. **Copias de seguridad y seguridad:** explicación de cómo realizar copias, recuperar los datos y limitar los permisos de cada usuario.
6. **Evidencias:** capturas de los comandos ejecutados y de los resultados obtenidos.

## 3. Modelo de datos

He elegido un catálogo de comercio electrónico.

La colección `productos` guarda la información principal de cada producto, junto con sus variantes, características, existencias y reseñas.

La colección `categorias` permite organizar los productos y evitar repetir la información de cada categoría.

La colección `usuarios` contiene datos ficticios de los usuarios. Las reseñas guardan el identificador del usuario que las ha escrito.

He utilizado referencias para relacionar productos y categorías, e incrustación para guardar dentro de los productos los datos que normalmente se consultan juntos.

La explicación completa del modelo se encuentra en `docs/modelo.md`.

## 4. Cómo repetir las pruebas

Para repetir las consultas es necesario tener MongoDB instalado y disponer de la base de datos con las colecciones y los datos de prueba.

Los comandos se deben ejecutar en el orden indicado en los archivos del proyecto. Las capturas de las pruebas se encuentran en la carpeta de evidencias.

Entre las consultas realizadas se encuentran:

- Buscar productos activos según su precio.
- Relacionar productos y categorías mediante `$lookup`.
- Calcular la puntuación media de las reseñas.
- Localizar productos con menos de 10 unidades en stock.
- Comprobar los índices y el rendimiento con `explain("executionStats")`.

## 5. Copias de seguridad

He documentado los comandos `mongodump` y `mongorestore` para hacer copias de seguridad y recuperar los datos.

No he podido comprobar que la copia se realice correctamente porque el comando `mongodump` no me ha funcionado. Por tanto, dejo explicado el procedimiento, pero no afirmo que la copia y la restauración se hayan completado.

