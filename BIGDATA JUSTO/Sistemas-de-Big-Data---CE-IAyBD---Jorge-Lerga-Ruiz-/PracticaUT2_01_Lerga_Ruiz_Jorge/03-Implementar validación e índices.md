# 3. Implementar validación e índices

## 3.1 Creación de colecciones con `$jsonSchema`

Se crean las tres colecciones principales del catálogo (`categorias`, `usuarios` y `productos`) aplicando validación mediante $jsonSchema .

La validación permite comprobar que los documentos tienen los tipos de datos correctos, que existen determinados campos obligatorios, que algunos campos solo pueden tener determinados valores y que existen restricciones de rango o formato.

### 1. Colección `categorias`

Las categorías deben tener un identificador, un nombre, una lista de subcategorías y un estado que indique si están activas.

```javascript
db.createCollection("categorias", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["_id", "nombre", "subcategorias", "activa"],
      properties: {
        _id: {
          bsonType: "string"
        },
        nombre: {
          bsonType: "string",
          minLength: 2
        },
        descripcion: {
          bsonType: "string"
        },
        subcategorias: {
          bsonType: "array",
          items: {
            bsonType: "string"
          }
        },
        activa: {
          bsonType: "bool"
        },
        fecha_creacion: {
          bsonType: "date"
        }
      }
    }
  }
});
```

### 2. Colección `usuarios`

Los usuarios pueden ser clientes, administradores o personal de almacén. El correo electrónico se valida mediante una expresión regular y el rol mediante una enumeración.

```javascript
db.createCollection("usuarios", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["_id", "nombre", "email", "rol", "activo"],
      properties: {
        _id: {
          bsonType: "string"
        },
        nombre: {
          bsonType: "string",
          minLength: 2
        },
        email: {
          bsonType: "string",
          pattern: "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
        },
        rol: {
          enum: ["cliente", "admin", "almacen"]
        },
        activo: {
          bsonType: "bool"
        },
        fecha_registro: {
          bsonType: "date"
        }
      }
    }
  }
});
```

### 3. Colección `productos`

Esta es la colección principal del catálogo. Se validan los datos básicos del producto y también los documentos incrustados de las variantes, el stock y las reseñas.

```javascript
db.createCollection("productos", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: [
        "_id",
        "categoria_id",
        "nombre",
        "marca",
        "precio",
        "activo",
        "variantes",
        "stock",
        "resenas"
      ],
      properties: {
        _id: {
          bsonType: "string"
        },
        categoria_id: {
          bsonType: "string"
        },
        nombre: {
          bsonType: "string",
          minLength: 2
        },
        descripcion: {
          bsonType: "string"
        },
        marca: {
          bsonType: "string"
        },
        precio: {
          bsonType: ["double", "int", "decimal"],
          minimum: 0
        },
        activo: {
          bsonType: "bool"
        },

        variantes: {
          bsonType: "array",
          minItems: 1,
          items: {
            bsonType: "object",
            required: ["sku", "precio", "stock"],
            properties: {
              sku: {
                bsonType: "string",
                pattern: "^[A-Z0-9-]{4,20}$"
              },
              color: {
                bsonType: "string"
              },
              memoria: {
                bsonType: "string"
              },
              precio: {
                bsonType: ["double", "int", "decimal"],
                minimum: 0
              },
              stock: {
                bsonType: "int",
                minimum: 0
              }
            }
          }
        },

        especificaciones: {
          bsonType: "object"
        },

        stock: {
          bsonType: "object",
          required: ["total", "almacenes"],
          properties: {
            total: {
              bsonType: "int",
              minimum: 0
            },
            almacenes: {
              bsonType: "array",
              items: {
                bsonType: "object",
                required: ["almacen", "ciudad", "unidades"],
                properties: {
                  almacen: {
                    bsonType: "string"
                  },
                  ciudad: {
                    bsonType: "string"
                  },
                  unidades: {
                    bsonType: "int",
                    minimum: 0
                  }
                }
              }
            }
          }
        },

        resenas: {
          bsonType: "array",
          items: {
            bsonType: "object",
            required: ["usuario_id", "puntuacion", "comentario", "fecha"],
            properties: {
              usuario_id: {
                bsonType: "string"
              },
              puntuacion: {
                bsonType: "int",
                minimum: 1,
                maximum: 5
              },
              comentario: {
                bsonType: "string"
              },
              fecha: {
                bsonType: "date"
              }
            }
          }
        },

        etiquetas: {
          bsonType: "array",
          items: {
            bsonType: "string"
          }
        },

        fecha_creacion: {
          bsonType: "date"
        },

        fecha_actualizacion: {
          bsonType: "date"
        }
      }
    }
  }
});
```

### Prueba de rechazo provocada

Para comprobar que la validación funciona, podemos intentar introducir un producto con un precio negativo y una variante con stock negativo.

```javascript
db.productos.insertOne({
  _id: "PROD-ERROR",
  categoria_id: "CAT001",
  nombre: "Producto incorrecto",
  marca: "MarcaTest",
  precio: -20,
  activo: true,

  variantes: [
    {
      sku: "TEST-01",
      precio: -10,
      stock: -5
    }
  ],

  stock: {
    total: -5,
    almacenes: []
  },

  resenas: []
});
```

**Resultado esperado:** MongoDB rechaza la operación mediante `DocumentValidationFailure`, ya que el precio y el stock tienen valores inferiores al mínimo permitido.

También se rechazaría una reseña con una puntuación fuera del rango de 1 a 5.



## 3.2 Creación de los índices

Los índices se han elegido a partir de las preguntas de negocio definidas anteriormente.

### Índice 1: compuesto por categoría, estado y precio

```javascript
db.productos.createIndex(
  {
    categoria_id: 1,
    activo: 1,
    precio: 1
  },
  {
    name: "idx_productos_categoria_activo_precio"
  }
);
```

Este índice está pensado para consultas en las que se muestran los productos de una categoría, únicamente los productos activos y ordenados por precio.

Por ejemplo:

```javascript
db.productos.find({
  categoria_id: "CAT001",
  activo: true,
  precio: {
    $gte: 20,
    $lte: 200
  }
}).sort({
  precio: 1
});
```

El orden de los campos se ha elegido colocando primero los campos utilizados para igualdad (`categoria_id` y `activo`) y después `precio`, que se utiliza para ordenar y realizar un rango.

**Coste:** el índice ocupa espacio adicional y hace que las operaciones de inserción, modificación o eliminación de productos sean ligeramente más costosas, ya que MongoDB debe mantener actualizado el índice.



### Índice 2: texto sobre el nombre y la descripción

```javascript
db.productos.createIndex(
  {
    nombre: "text",
    descripcion: "text"
  },
  {
    name: "idx_productos_texto"
  }
);
```

Este índice permite realizar búsquedas de texto sobre el nombre y la descripción de los productos.

Por ejemplo:

```javascript
db.productos.find({
  $text: {
    $search: "auriculares bluetooth"
  }
});
```

Este índice resulta útil para la pregunta de negocio relacionada con la búsqueda de productos por palabras clave.

**Coste:** ocupa más espacio que un índice sencillo y aumenta el coste de las escrituras, porque MongoDB debe actualizar el índice de texto cuando cambia el contenido indexado.



### Índice 3: stock total y estado del producto

```javascript
db.productos.createIndex(
  {
    "stock.total": 1,
    activo: 1
  },
  {
    name: "idx_productos_stock_activo"
  }
);
```

Este índice permite localizar rápidamente productos con poco stock y que estén actualmente activos.

Por ejemplo:

```javascript
db.productos.find({
  "stock.total": {
    $lte: 10
  },
  activo: true
});
```

Esto responde a la necesidad de detectar productos cuyo stock está próximo a agotarse.

**Coste:** añade almacenamiento y aumenta ligeramente el coste de las actualizaciones del stock, algo especialmente importante porque el stock puede modificarse con frecuencia.


## 3.3 Justificación de los índices

| Índice                                  | Consulta que acelera                                                 | Orden de campos                             | Coste                                               |
| --------------------------------------- | -------------------------------------------------------------------- | ------------------------------------------- | --------------------------------------------------- |
| `idx_productos_categoria_activo_precio` | Productos de una categoría, activos y filtrados/ordenados por precio | `categoria_id → activo → precio`            | Más espacio y pequeñas penalizaciones en escrituras |
| `idx_productos_texto`                   | Búsqueda por palabras en nombre y descripción                        | `nombre → descripcion` como índice de texto | Mayor almacenamiento y coste al modificar texto     |
| `idx_productos_stock_activo`            | Productos activos con stock bajo                                     | `stock.total → activo`                      | Coste adicional en actualizaciones de stock         |

Se han elegido estos índices porque corresponden a operaciones habituales del escenario y no se crean índices innecesarios sobre todos los campos de los documentos.



## 3.4 Evidencia del plan de ejecución con `explain("executionStats")`

Para comprobar el efecto del índice compuesto se puede ejecutar la misma consulta antes y después de crear el índice.

La consulta utilizada es:

```javascript
db.productos.find({
  categoria_id: "CAT001",
  activo: true,
  precio: {
    $gte: 20,
    $lte: 200
  }
}).sort({
  precio: 1
}).explain("executionStats");
```

#### Antes de crear el índice

Si no existe un índice adecuado para esta consulta, MongoDB puede realizar un escaneo completo de la colección.

El resultado esperado es similar a:

```text
COLLSCAN
```

Esto significa que MongoDB tiene que revisar los documentos de la colección para encontrar los que cumplen las condiciones.

#### Después de crear el índice

Una vez creado:

```javascript
db.productos.createIndex(
  {
    categoria_id: 1,
    activo: 1,
    precio: 1
  },
  {
    name: "idx_productos_categoria_activo_precio"
  }
);
```

volvemos a ejecutar:

```javascript
db.productos.find({
  categoria_id: "CAT001",
  activo: true,
  precio: {
    $gte: 20,
    $lte: 200
  }
}).sort({
  precio: 1
}).explain("executionStats");
```

Ahora el plan puede utilizar:

```text
IXSCAN
```

seguido normalmente de `FETCH`, ya que MongoDB utiliza el índice para localizar los documentos que cumplen las condiciones.

#### Comparación

| Métrica                     | Sin índice                            | Con índice                                         |
| --------------------------- | ------------------------------------- | -------------------------------------------------- |
| Plan principal              | `COLLSCAN`                            | `IXSCAN` + `FETCH`                                 |
| Documentos examinados       | Mayor cantidad                        | Menor cantidad cuando el filtro es selectivo       |
| Claves de índice examinadas | 0                                     | Depende de los resultados                          |
| Tiempo de ejecución         | Mayor a medida que crece la colección | Generalmente menor                                 |
| Ordenación                  | Puede necesitar ordenar resultados    | El índice puede proporcionar el orden por `precio` |

Los valores exactos de `executionTimeMillis`, `nReturned`, `totalDocsExamined` y `totalKeysExamined` dependen del número de documentos existentes en la base de datos y de los datos utilizados durante la prueba.

Por este motivo, no se deben inventar valores concretos de tiempo o documentos examinados. Para obtener la evidencia real se debe ejecutar `explain("executionStats")` en MongoDB antes y después de crear el índice.
