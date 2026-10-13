## 4. Consultas y agregaciones

### 4.1. Inserción, actualización y desactivación de productos

He realizado varias operaciones para comprobar que puedo gestionar los productos de la tienda.

Primero inserté el producto `PROD005`. Después actualicé su precio a 44,99 € y finalmente lo desactivé utilizando `activo: false`, sin eliminarlo definitivamente de la base de datos.

La actualización parcial permite cambiar un campo sin tener que modificar el documento completo. La desactivación lógica permite conservar el producto por si necesitamos consultar sus datos más adelante.

![](/Sistemas-de-Big-Data---CE-IAyBD---Jorge-Lerga-Ruiz-/PracticaUT2_01_Lerga_Ruiz_Jorge/docs/5.png)
![](/Sistemas-de-Big-Data---CE-IAyBD---Jorge-Lerga-Ruiz-/PracticaUT2_01_Lerga_Ruiz_Jorge/docs/6.png)

### 4.2. Filtros, ordenación y paginación

Esta consulta muestra los productos activos cuyo precio está entre 20 y 300 €. Los ordena de mayor a menor precio y devuelve un máximo de tres resultados.

Con `sort()` ordeno los resultados, con `skip()` puedo saltarme resultados anteriores y con `limit()` limito la cantidad que se devuelve. Utilizar `_id` como segundo criterio ayuda a mantener un orden estable cuando varios productos tienen el mismo precio.

![](/Sistemas-de-Big-Data---CE-IAyBD---Jorge-Lerga-Ruiz-/PracticaUT2_01_Lerga_Ruiz_Jorge/docs/7.png)


### 4.3. Consulta con `$lookup`

He utilizado `$lookup` para relacionar los productos con la colección `categorias`. La relación se realiza mediante `categoria_id` y el campo `_id` de la categoría.

El resultado muestra los productos junto con la información de su categoría. Esto permite mantener las categorías en una colección independiente y evitar repetir sus datos en cada producto.

![](/Sistemas-de-Big-Data---CE-IAyBD---Jorge-Lerga-Ruiz-/PracticaUT2_01_Lerga_Ruiz_Jorge/docs/8.1.png)
![](/Sistemas-de-Big-Data---CE-IAyBD---Jorge-Lerga-Ruiz-/PracticaUT2_01_Lerga_Ruiz_Jorge/docs/8.2.png)

### 4.4. Agregación compleja: valoración de los productos

Esta consulta calcula la puntuación media y el número de reseñas de cada producto activo.

La consulta tiene cuatro etapas. Primero selecciona los productos activos, después separa sus reseñas, agrupa las opiniones por producto y calcula la media y el número de reseñas. Finalmente, ordena los resultados por puntuación.

Esta información puede servir para mostrar los productos mejor valorados de la tienda.

![](/Sistemas-de-Big-Data---CE-IAyBD---Jorge-Lerga-Ruiz-/PracticaUT2_01_Lerga_Ruiz_Jorge/docs/9.png)

### 4.5. Productos con poco stock

He utilizado otra agregación para localizar los productos activos que tienen menos de 10 unidades disponibles.

En mi prueba aparecen dos productos:

![](/Sistemas-de-Big-Data---CE-IAyBD---Jorge-Lerga-Ruiz-/PracticaUT2_01_Lerga_Ruiz_Jorge/docs/10.png)

### 4.6. Índices y rendimiento

He comprobado los índices de la colección `productos` y he creado los que necesitaba para las búsquedas por categoría, precio, nombre y existencias.

![](/Sistemas-de-Big-Data---CE-IAyBD---Jorge-Lerga-Ruiz-/PracticaUT2_01_Lerga_Ruiz_Jorge/docs/11.png)
![](/Sistemas-de-Big-Data---CE-IAyBD---Jorge-Lerga-Ruiz-/PracticaUT2_01_Lerga_Ruiz_Jorge/docs/12.png)

Para comprobar el rendimiento he utilizado `explain("executionStats")` en una consulta que filtra por categoría, estado y precio.

Con el resultado puedo comprobar el plan de ejecución, los documentos examinados y si MongoDB utiliza un índice.

![](/Sistemas-de-Big-Data---CE-IAyBD---Jorge-Lerga-Ruiz-/PracticaUT2_01_Lerga_Ruiz_Jorge/docs/13.png)
![](/Sistemas-de-Big-Data---CE-IAyBD---Jorge-Lerga-Ruiz-/PracticaUT2_01_Lerga_Ruiz_Jorge/docs/13.1.png)
![](/Sistemas-de-Big-Data---CE-IAyBD---Jorge-Lerga-Ruiz-/PracticaUT2_01_Lerga_Ruiz_Jorge/docs/13.2.png)
![](/Sistemas-de-Big-Data---CE-IAyBD---Jorge-Lerga-Ruiz-/PracticaUT2_01_Lerga_Ruiz_Jorge/docs/13.3.png)

### 4.7. Qué pasaría si aumentaran los datos

Si aumentara mucho el número de productos, los índices ayudarían a realizar algunas búsquedas con mayor rapidez. Sin embargo, también ocuparían espacio y tendrían que actualizarse al modificar los datos.

En las agregaciones, procesar más productos y reseñas requeriría más recursos. Por eso es útil filtrar los datos al principio de la consulta y evitar guardar cantidades ilimitadas de reseñas dentro de un mismo producto.