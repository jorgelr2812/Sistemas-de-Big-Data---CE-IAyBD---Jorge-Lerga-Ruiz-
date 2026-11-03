# Directorio de Datos

En esta práctica no se incluyen conjuntos de datos externos (archivos `.csv`, `.json`, etc.) para importar con `LOAD CSV`.

Toda la carga del dataset inicial de prueba (con más de 15 nodos y 25 relaciones) se ha diseñado de forma programática y directa. Los datos están integrados mediante comandos Cypher utilizando la cláusula `MERGE` para garantizar la idempotencia y evitar duplicados.

