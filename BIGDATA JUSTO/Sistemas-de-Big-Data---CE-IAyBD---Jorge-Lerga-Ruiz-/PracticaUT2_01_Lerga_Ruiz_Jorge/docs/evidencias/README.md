# Evidencias de Ejecución

En este apartado se recogen las capturas de las pruebas realizadas en MongoDB, con los comandos utilizados y sus resultados.

---

## 1. Evidencia de las colecciones y los datos

He creado la base de datos `prueba1` con tres colecciones: `productos`, `categorias` y `usuarios`.

En las primeras capturas se pueden ver las colecciones y algunos documentos de ejemplo.

![](/Sistemas-de-Big-Data---CE-IAyBD---Jorge-Lerga-Ruiz-/PracticaUT2_01_Lerga_Ruiz_Jorge/docs/1.png)
![](/Sistemas-de-Big-Data---CE-IAyBD---Jorge-Lerga-Ruiz-/PracticaUT2_01_Lerga_Ruiz_Jorge/docs/2.png)
![](/Sistemas-de-Big-Data---CE-IAyBD---Jorge-Lerga-Ruiz-/PracticaUT2_01_Lerga_Ruiz_Jorge/docs/3.png)
![](/Sistemas-de-Big-Data---CE-IAyBD---Jorge-Lerga-Ruiz-/PracticaUT2_01_Lerga_Ruiz_Jorge/docs/4.png)
## 2. Evidencia de inserción y actualización

He insertado el producto `PROD005`, he modificado su precio y después lo he desactivado utilizando el campo `activo`.

De esta forma, el producto deja de estar activo sin tener que eliminarlo definitivamente.

![](/Sistemas-de-Big-Data---CE-IAyBD---Jorge-Lerga-Ruiz-/PracticaUT2_01_Lerga_Ruiz_Jorge/docs/5.png) inserción del producto.
![](/Sistemas-de-Big-Data---CE-IAyBD---Jorge-Lerga-Ruiz-/PracticaUT2_01_Lerga_Ruiz_Jorge/docs/6.png) desactivación del producto.

## 3. Evidencia de consultas y agregaciones

### 3.1. Búsqueda por precio

He realizado una consulta para mostrar los productos activos con un precio entre 20 y 300 euros. Los resultados se ordenan de mayor a menor precio y se limita la cantidad de documentos devueltos.

![](/Sistemas-de-Big-Data---CE-IAyBD---Jorge-Lerga-Ruiz-/PracticaUT2_01_Lerga_Ruiz_Jorge/docs/7.png) resultado de la consulta con filtros, ordenación y paginación.

### 3.2. Relación entre productos y categorías

He utilizado `$lookup` para relacionar los productos con las categorías mediante el campo `categoria_id`.

El resultado permite consultar la información del producto junto con los datos de su categoría.

![](/Sistemas-de-Big-Data---CE-IAyBD---Jorge-Lerga-Ruiz-/PracticaUT2_01_Lerga_Ruiz_Jorge/docs/8.1.png) 
![](/Sistemas-de-Big-Data---CE-IAyBD---Jorge-Lerga-Ruiz-/PracticaUT2_01_Lerga_Ruiz_Jorge/docs/8.2.png)resultado de la consulta con `$lookup`.

### 3.3. Valoración media de los productos

He realizado una agregación para calcular la puntuación media y el número de reseñas de cada producto activo.

Para ello he utilizado `$match`, `$unwind`, `$group` y `$sort`.

Esta consulta permite saber qué productos tienen mejores valoraciones.

![](/Sistemas-de-Big-Data---CE-IAyBD---Jorge-Lerga-Ruiz-/PracticaUT2_01_Lerga_Ruiz_Jorge/docs/9.png) resultado de la agregación de reseñas.

### 3.4. Productos con poco stock

He realizado otra consulta para encontrar los productos activos que tienen menos de 10 unidades disponibles.

En el resultado aparecen dos productos, uno con 3 unidades y otro con 8.

![](/Sistemas-de-Big-Data---CE-IAyBD---Jorge-Lerga-Ruiz-/PracticaUT2_01_Lerga_Ruiz_Jorge/docs/10.png)

## 4. Evidencia de los índices

He consultado los índices de la colección `productos` y he creado índices para ayudar en las búsquedas por categoría, estado, precio, nombre y existencias.

Los índices pueden acelerar las búsquedas, aunque también ocupan espacio y deben actualizarse cuando cambian los datos.

![](/Sistemas-de-Big-Data---CE-IAyBD---Jorge-Lerga-Ruiz-/PracticaUT2_01_Lerga_Ruiz_Jorge/docs/11.png) índices que había en la colección.
![](/Sistemas-de-Big-Data---CE-IAyBD---Jorge-Lerga-Ruiz-/PracticaUT2_01_Lerga_Ruiz_Jorge/docs/12.png) creación y comprobación de los índices.

## 5. Evidencia del rendimiento con `explain()`

Para comprobar cómo se ejecuta una consulta, he utilizado el siguiente comando:

```javascript
db.productos.find({
  categoria_id: "CAT001",
  activo: true,
  precio: { $gte: 20, $lte: 200 }
}).sort({
  precio: 1
}).explain("executionStats")
```

El resultado permite ver cómo MongoDB busca los productos y si utiliza un índice.

Los datos más importantes son:

- `winningPlan`: muestra el plan de ejecución elegido.
- `nReturned`: indica cuántos documentos devuelve.
- `totalDocsExamined`: indica cuántos documentos examina.
- `totalKeysExamined`: indica cuántas claves de índice examina.
- `executionTimeMillis`: muestra el tiempo de ejecución indicado por MongoDB.

Si aparece `IXSCAN`, significa que se está utilizando un índice para realizar parte de la búsqueda. Si aparece `COLLSCAN`, MongoDB está recorriendo los documentos de la colección.

![](/Sistemas-de-Big-Data---CE-IAyBD---Jorge-Lerga-Ruiz-/PracticaUT2_01_Lerga_Ruiz_Jorge/docs/13.png)
![](/Sistemas-de-Big-Data---CE-IAyBD---Jorge-Lerga-Ruiz-/PracticaUT2_01_Lerga_Ruiz_Jorge/docs/13.1.png)
![](/Sistemas-de-Big-Data---CE-IAyBD---Jorge-Lerga-Ruiz-/PracticaUT2_01_Lerga_Ruiz_Jorge/docs/13.2.png)
![](/Sistemas-de-Big-Data---CE-IAyBD---Jorge-Lerga-Ruiz-/PracticaUT2_01_Lerga_Ruiz_Jorge/docs/13.3.png) resultado de `explain("executionStats")`.

No comparo los tiempos antes y después de crear los índices porque no he guardado resultados de las dos pruebas que permitan hacer esa comparación.

## 6. Evidencia de la copia de seguridad

Para hacer una copia de seguridad de la base de datos se pueden utilizar `mongodump` y `mongorestore`.

```bash
mongodump --db prueba1 --out "./backup"
```

Para restaurarla:

```bash
mongorestore --drop --nsInclude="prueba1.*" "./backup"
```

He intentado ejecutar el comando de copia, pero no he conseguido que funcione. Por eso, dejo documentado el procedimiento, aunque no puedo confirmar que la copia y la restauración se hayan realizado correctamente.

## 7. Validación de documentos

Las reglas de validación sirven para evitar datos incorrectos, por ejemplo, precios negativos, existencias negativas o puntuaciones fuera del rango permitido.

Para demostrar que MongoDB rechaza un documento incorrecto, es necesario tener las reglas configuradas y realizar una prueba de inserción inválida.

No incluyo un resultado de rechazo porque no tengo una captura que demuestre esa prueba.