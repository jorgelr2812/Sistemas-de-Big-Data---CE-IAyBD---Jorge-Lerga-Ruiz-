# Práctica 01 UT02 
## 1. Definir el problema y los accesos

### 1.1. Escenario elegido y usuarios

El escenario elegido es un **catálogo de comercio electrónico variable**. La base de datos almacenará información sobre productos, categorías, variantes, stock y reseñas de los usuarios.

El catálogo debe permitir trabajar con productos de características diferentes. Por ejemplo, un teléfono móvil puede tener memoria RAM y almacenamiento, mientras que unas zapatillas pueden tener talla y material. MongoDB permite almacenar estos datos con una estructura flexible.

Los principales usuarios del sistema serán:

* **Clientes:** consultan productos, categorías, precios, stock y reseñas.
* **Administradores:** crean, modifican y eliminan productos y categorías, además de gestionar el stock.
* **Personal de almacén:** consulta y actualiza las unidades disponibles en cada almacén.
* **Responsables de la tienda:** consultan estadísticas sobre productos, stock y valoraciones.

---

### 1.2. Preguntas de negocio

La base de datos debe poder responder, como mínimo, a las siguientes preguntas:

**1. ¿Qué productos pertenecen a cada categoría?**
**2. ¿Qué productos tienen un precio inferior a una cantidad determinada?**
**3. ¿Qué productos tienen stock disponible en un determinado almacén?**
**4. ¿Cuál es la valoración media de cada producto?**
**5. ¿Cuáles son los productos mejor valorados?**
**6. ¿Cuánto stock total existe de cada producto?**
**7. ¿Qué variantes de un producto están disponibles y qué stock tiene cada una?**
**8. ¿Qué productos tienen poco stock y deberían reponerse?**

Estas son las consultas con las que trabajaremos posteriormente .

---

### 1.3. Datos que se leen y escriben con mayor frecuencia

### Datos de lectura frecuente

Los datos que se consultarán con mayor frecuencia serán:

* Nombre y descripción del producto.
* Categoría y subcategoría.
* Precio.
* Variantes disponibles.
* Stock disponible.
* Especificaciones del producto.
* Valoraciones y reseñas.
* Etiquetas.

Estos datos se consultarán principalmente cuando un cliente busque productos .

### Datos de escritura frecuente

Los datos que tendrán más modificaciones serán:

* **Stock**, debido a las entradas y salidas de productos por ejemplo cuando el cliente haga una compra , el stock debe de actualizarse.
* **Reseñas**, cuando los clientes valoren productos.
* **Precio**, cuando se produzcan cambios de precio.
* **Información del producto**, cuando un administrador actualice sus características.

El stock será especialmente importante porque puede cambiar con bastante frecuencia.

---

### 1.4. Relación entre preguntas y accesos

| Pregunta de negocio                            | Colección   | Filtros                                   | Ordenación                   | Paginación |
| ---------------------------------------------- | ----------- | ----------------------------------------- | ---------------------------- | ---------- |
| ¿Qué productos pertenecen a una categoría?     | `productos` | `categoria.id`                            | `nombre`                     | Sí         |
| ¿Qué productos cuestan menos de una cantidad?  | `productos` | `precio < cantidad`                       | `precio` ascendente          | Sí         |
| ¿Qué productos tienen stock en un almacén?     | `productos` | `stock.almacenes.almacen`, `unidades > 0` | `nombre`                     | Sí         |
| ¿Cuál es la valoración media de cada producto? | `productos` | `resenas`                                 | `valoración media`           | Sí         |
| ¿Cuáles son los productos mejor valorados?     | `productos` | `resenas`                                 | valoración media descendente | Sí         |
| ¿Cuánto stock total tiene cada producto?       | `productos` | `stock.total`                             | stock descendente            | Sí         |
| ¿Qué variantes están disponibles?              | `productos` | `variantes.sku`, `variantes.stock > 0`    | `precio`                     | No         |
| ¿Qué productos tienen poco stock?              | `productos` | `stock.total < X`                         | stock ascendente             | Sí         |

---

### 1.5. Requisitos de seguridad, privacidad, disponibilidad y crecimiento

#### Seguridad

* Solo los administradores podrán crear, modificar o eliminar productos.
* El personal de almacén podrá modificar el stock, pero no la información general de los productos.
* Los clientes podrán consultar el catálogo.
* Se evitará almacenar información personal innecesaria de los clientes dentro de las reseñas.

#### Privacidad

Las reseñas utilizarán un identificador de usuario, como `usuario_id`, en lugar de almacenar directamente información personal.

Evitar almacenar datos personales no sean necesarios para el funcionamiento del catálogo.

#### Disponibilidad

El catálogo debe estar disponible durante la mayor parte del tiempo porque los clientes pueden realizar consultas en cualquier momento.

También será necesario realizar copias de seguridad periódicas para evitar la pérdida de información y tener disponibilidad de esta misma cuando sea necesario.

#### Crecimiento

La cantidad de productos puede aumentar con el tiempo y también crecerá el número de variantes y reseñas , entonces debemos tener capacidad de aumentar la base de datos en los aspectos necesarios segun evolucione la situación.

