## 5. Copias de seguridad, seguridad y límites

### 5.1. Copia de seguridad y restauración

Para realizar una copia de seguridad de la base de datos se pueden utilizar `mongodump` y `mongorestore`.

Los siguientes comandos se ejecutan en PowerShell o en una terminal del sistema, no dentro de `mongosh`.

Para crear una copia:

```bash
mongodump --db prueba1 --out "./backup"
```

Para restaurarla:

```bash
mongorestore --drop --nsInclude="prueba1.*" "./backup"
```

La opción `--drop` elimina las colecciones de destino antes de restaurarlas. Por eso, solo utilizaría este comando en la base de datos que quiero recuperar y después de comprobar que la copia es correcta.

**No he ejecutad ni verificado esta copia de seguridad.** Para completar la comprobación, habría que ejecutar los comandos y revisar que los datos se restauran correctamente. También es recomendable guardar las copias en otro dispositivo o ubicación.

### 5.2. Usuarios, roles y permisos

No todos los usuarios de la aplicación necesitan los mismos permisos.

- **Clientes:** pueden consultar los productos y las categorías, sin modificar el catálogo.
- **Aplicación de la tienda:** necesita únicamente los permisos de lectura y escritura que requieran sus funciones.
- **Personal de almacén:** necesita consultar los productos y modificar las existencias.
- **Administradores:** necesitan permisos adicionales para gestionar la base de datos y los usuarios.

### 5.3. Protección de los datos

Protegería especialmente los nombres, correos electrónicos, direcciones y cualquier dato personal de los clientes.

Utilizaría conexiones cifradas y cifrado del almacenamiento cuando corresponda. En las reseñas guardaría solo los datos necesarios y evitaría almacenar información de pago que no haga falta para el catálogo.


### 5.4. Límites de MongoDB

Hay situaciones en las que MongoDB no sería mi primera opción como único sistema:

1. **Aplicaciones con muchas relaciones y operaciones financieras:** una base de datos relacional como PostgreSQL puede ser más adecuada cuando predominan las relaciones entre tablas y las operaciones que deben mantener la integridad de muchos registros.

2. **Búsquedas avanzadas y análisis de grandes cantidades de datos:** en algunos proyectos sería conveniente complementar MongoDB con un buscador especializado o un sistema de análisis de datos.


### 5.5. Conservación de los datos históricos

Mantendría los pedidos y los cambios importantes de stock durante el tiempo necesario para la gestión del negocio y las obligaciones aplicables.

Los productos que ya no se vendan se podrían desactivar y archivar en lugar de eliminarlos inmediatamente. Las reseñas se conservarían según la política de la aplicación y las solicitudes de los usuarios.

Eliminaría periódicamente los datos de prueba que ya no fueran necesarios, evitando tener información personal sin motivo .

## Conclusión

Con esta práctica he aprendido a diseñar un catálogo en MongoDB, relacionar colecciones, validar documentos, crear índices y realizar consultas y agregaciones.

Creo que el modelo se adapta a una tienda online porque permite gestionar productos con características diferentes, controlar las existencias y consultar las valoraciones sin tener que utilizar exactamente la misma estructura para todos los productos.