## 2. Diseñar las colecciones

## 2.1. Colecciones y propósito
El modelo estará formado por tres colecciones principales:

* **Productos**
  Contendrá la información principal de cada producto.
  Además, tendrá algunos datos incrustados:
  * Variantes.
  * Stock por almacén.
  * Especificaciones.
  * Reseñas.
  * Etiquetas.
  
  Se ha elegido esta estructura porque estos datos normalmente se consultan junto con el producto.

* **Categorias**
  Contendrá las categorías y subcategorías disponibles en la tienda.
  Los productos almacenarán una referencia mediante el identificador de la categoría.

* **Usuarios**
  Contendrá los usuarios que pueden realizar acciones dentro de la plataforma, como escribir reseñas.
  Las reseñas almacenadas en productos solamente guardarán el `usuario_id` como referencia.


## 2.2. Esquema general
El modelo puede representarse de la siguiente manera:

```text
┌──────────────────────┐
│      categorias      │
├──────────────────────┤
│ _id                  │
│ nombre               │
│ descripcion          │
│ activa               │
└──────────┬───────────┘
           │
           │ categoria_id
           │
           ▼
┌─────────────────────────────────┐
│           productos             │
├─────────────────────────────────┤
│ _id                             │
│ nombre                          │
│ descripcion                     │
│ categoria_id  ──────────────────┼──► categorias
│ marca                           │
│ precio                          │
│ activo                          │
│ especificaciones {}             │
│ variantes []                    │
│ stock {}                        │
│ resenas []                      │
│ etiquetas []                    │
│ fecha_creacion                  │
│ fecha_actualizacion             │
└────────────────┬────────────────┘
                 │
                 │ usuario_id
                 ▼
        ┌──────────────────┐
        │     usuarios     │
        ├──────────────────┤
        │ _id              │
        │ nombre           │
        │ email            │
        │ rol              │
        │ fecha_registro   │
        └──────────────────┘
```
## 2.3. Documentos de ejemplo
##### Colección categorias

Ejemplo de documento:
```json
{
  "_id": "CAT001",
  "nombre": "Electrónica",
  "descripcion": "Productos electrónicos y dispositivos tecnológicos",
  "subcategorias": [
    "Audio",
    "Móviles",
    "Televisores",
    "Informática"
  ],
  "activa": true,
  "fecha_creacion": "2026-08-01"
}
```

##### Colección usuarios

Ejemplo de documento:
```json
{
  "_id": "USR001",
  "nombre": "Carlos García",
  "email": "carlos@example.com",
  "rol": "cliente",
  "activo": true,
  "fecha_registro": "2026-08-10"
}
```

##### Colección productos

Ejemplo de documento:
```json
{
  "_id": "PROD001",
  "nombre": "Auriculares Bluetooth Pro",
  "descripcion": "Auriculares inalámbricos con cancelación de ruido",

  "categoria_id": "CAT001",

  "marca": "SoundMax",
  "precio": 79.99,
  "activo": true,

  "variantes": [
    {
      "sku": "AUDPRO-BLK",
      "color": "Negro",
      "memoria": "32GB",
      "precio": 79.99,
      "stock": 25
    },
    {
      "sku": "AUDPRO-WHT",
      "color": "Blanco",
      "memoria": "32GB",
      "precio": 84.99,
      "stock": 12
    }
  ],

  "especificaciones": {
    "bluetooth": "5.3",
    "bateria_horas": 30,
    "cancelacion_ruido": true,
    "peso_gramos": 250
  },

  "stock": {
    "total": 37,
    "almacenes": [
      {
        "almacen": "MAD01",
        "ciudad": "Madrid",
        "unidades": 20
      },
      {
        "almacen": "BCN01",
        "ciudad": "Barcelona",
        "unidades": 17
      }
    ]
  },

  "resenas": [
    {
      "usuario_id": "USR001",
      "puntuacion": 5,
      "comentario": "Muy buena calidad de sonido.",
      "fecha": "2026-09-10"
    },
    {
      "usuario_id": "USR002",
      "puntuacion": 4,
      "comentario": "La batería dura bastante.",
      "fecha": "2026-09-15"
    }
  ],

  "etiquetas": [
    "bluetooth",
    "inalambrico",
    "cancelacion-ruido"
  ],

  "fecha_creacion": "2026-08-01",
  "fecha_actualizacion": "2026-09-20"
}
```
## 2.4. Decisiones de modelado
##### Incrustación

Se ha decidido incrustar las variantes dentro del documento producto.

Por ejemplo:

"variantes": [
  {
    "sku": "AUDPRO-BLK",
    "color": "Negro",
    "precio": 79.99,
    "stock": 25
  }
]
##### Justificación

Las variantes pertenecen directamente a un producto y normalmente se necesitan cuando se hace una consulta.

##### Además:

El tamaño de cada variante es pequeño.
La cantidad de variantes de un producto normalmente será limitada.
Se suelen leer junto al producto.
No tienen sentido por separado sin el producto al que pertenecen.
Permite obtener el producto y sus variantes en una única consulta.

Por estos motivos, la incrustación reduce el número de consultas necesarias.

También se han incrustado las especificaciones, ya que pueden variar dependiendo del tipo de producto y se consultan junto con él.

Las reseñas también se han incrustado inicialmente porque forman parte de la información que se muestra en la ficha del producto.

##### Referencias

Se ha decidido utilizar una referencia entre productos y categorias:

"categoria_id": "CAT001"

En lugar de guardar toda la categoría dentro de cada producto.

##### Justificación

Una categoría puede tener muchos productos, por lo que existe una relación de tipo 1.

Por ejemplo:

Electrónica
   │
   ├── Auriculares
   ├── Smartphone
   ├── Televisor
   └── Tablet

Si se almacenara toda la información de la categoría dentro de cada producto, habría duplicación de datos.

Al utilizar categoria_id, si se modifica el nombre o descripción de una categoría solamente es necesario modificar un documento.

También se utiliza una referencia para los usuarios de las reseñas:

"usuario_id": "USR001"

No se copia toda la información del usuario dentro de cada reseña.

## 2.5. Identificadores

Se utilizará un identificador _id único para cada documento.

En esta práctica se utilizarán identificadores de tipo string con un formato sencillo:
```json
CAT001
CAT002

USR001
USR002

PROD001
PROD002
```
En una aplicación real también podría utilizarse el ObjectId que proporciona MongoDB.

Los identificadores de productos, categorías y usuarios serán únicos.

Para las variantes se utilizará un sku, que también será único dentro del catálogo.

Ejemplo:
```json
{
  "sku": "AUDPRO-BLK"
}
```

## 2.6. Fechas

Los documentos tendrán campos para controlar las fechas importantes:
```json
"fecha_creacion": "2026-08-01",
"fecha_actualizacion": "2026-09-20"
```
Estos campos permitirán conocer cuándo se creó y cuándo se modificó un producto.

En una implementación real de MongoDB se recomienda utilizar el tipo Date  en lugar de almacenar las fechas como texto.

Por ejemplo:
```json
ISODate("2026-09-20T10:30:00Z")
```
Esto permitirá realizar consultas y ordenaciones correctamente por fecha.

## 2.7. Estados

Los estados se representarán mediante campos específicos.

Para los productos:
```json
"activo": true
```
Para los usuarios:
```json
"activo": true
```
De esta forma no es necesario eliminar físicamente un producto cuando deja de estar disponible temporalmente.

Por ejemplo:
```json
{
  "_id": "PROD001",
  "activo": false
}
```
El producto seguiría existiendo en la base de datos, pero no aparecería en el catálogo público.

## 2.8. Campos opcionales

MongoDB permite que diferentes productos tengan diferentes campos.

Esto es especialmente útil para las especificaciones.

Por ejemplo, un teléfono podría tener:
```json
"especificaciones": {
  "ram": "8GB",
  "almacenamiento": "256GB",
  "pantalla_pulgadas": 6.5
}
```
Mientras que unas zapatillas podrían tener:
```json
"especificaciones": {
  "talla": 42,
  "material": "Cuero",
  "tipo_suela": "Goma"
}
```
No todos los productos tendrán los mismos campos.

Por tanto, estos campos serán opcionales y no será necesario introducir valores null para características que no correspondan a un producto.

## 2.9. Límites del modelo
##### Tamaño máximo del documento

MongoDB tiene un límite máximo de 16 MB por documento .

El diseño intenta evitar acercarse a este límite.

Las variantes y reseñas se almacenan dentro del producto porque se espera que su cantidad sea moderada.

Si un producto tuviera miles o millones de reseñas, este modelo dejaría de ser adecuado y sería necesario crear una colección independiente para las reseñas.

##### Crecimiento de arrays

Los principales arrays del modelo son:

variantes[]
almacenes[]
resenas[]
etiquetas[]

Los arrays de variantes, almacenes y etiquetas deberían tener un crecimiento limitado.

El array que puede crecer más es resenas[].

Si un producto recibiera una cantidad muy elevada de reseñas, el documento podría crecer demasiado y las actualizaciones serían menos eficientes.

En ese caso se podría crear una colección independiente:

resenas

y utilizar:
```json
{
  "_id": "REV001",
  "producto_id": "PROD001",
  "usuario_id": "USR001",
  "puntuacion": 5,
  "comentario": "Muy buena calidad.",
  "fecha": "2026-09-10"
}
```
##### Duplicación de datos

El modelo intenta reducir la duplicación.

La categoría se referencia mediante:
```json
"categoria_id": "CAT001"
```
y las reseñas utilizan:
```json
"usuario_id": "USR001"
```
No se copia la información completa de las categorías ni de los usuarios dentro de cada producto.

Sin embargo, algunos datos pueden estar duplicados de forma controlada.

Por ejemplo, la ciudad del almacén aparece dentro del stock:
```json
{
  "almacen": "MAD01",
  "ciudad": "Madrid",
  "unidades": 20
}
```
Esta duplicación puede simplificar las consultas del catálogo.

##### Consistencia

Al tener parte de la información incrustada, algunas actualizaciones se realizan directamente dentro del documento del producto.

Por ejemplo, actualizar el stock de una variante:
```json
db.productos.updateOne(
  {
    "_id": "PROD001",
    "variantes.sku": "AUDPRO-BLK"
  },
  {
    "$set": {
      "variantes.$.stock": 20
    }
  }
)
```
La referencia entre categorías y productos implica que si se elimina una categoría habrá que comprobar previamente qué productos la utilizan.

Por tanto, algunas operaciones requieren mantener la consistencia entre diferentes colecciones.

Operaciones que resultarían incómodas

Este modelo puede resultar menos cómodo en determinadas situaciones:

Buscar todas las reseñas de todos los productos de un usuario.
Gestionar millones de reseñas.
Actualizar información de una categoría que estuviera duplicada en muchos productos.
Realizar estadísticas muy complejas sobre grandes cantidades de reseñas.
Gestionar un número enorme de variantes dentro de un único producto.

Si estas operaciones fueran muy frecuentes, se podría modificar el modelo y crear colecciones independientes para determinados datos.

Por ejemplo:
```json
productos
categorias
usuarios
resenas
```
En este caso se sacrificaría parte de la comodidad de obtener toda la información del producto en una sola consulta a cambio de mejorar el crecimiento y las consultas sobre grandes cantidades de reseñas.
