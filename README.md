# RetailChain — Consolidación de Inventarios con UNION y UNION ALL

Este repositorio contiene la solución a la práctica de consolidación de fuentes de datos para RetailChain, orientada a generar reportes unificados de catálogo y auditorías de inventario mediante los operadores UNION y UNION ALL.

---

## Estructura del Repositorio

union-retailchain/
├── schema.sql
├── soluciones.sql
└── README.md

---

## Preguntas de Documentación Técnica

### 1. ¿Cuántas filas devuelve cada consulta y por qué son distintas? Explicá con ejemplos concretos de los datos qué filas se eliminaron con UNION.
* Consulta 1 (UNION): Devuelve 10 filas únicas de catálogo.
* Consulta 2 (UNION ALL): Devuelve 14 filas en total (7 registros de la Sucursal Norte + 7 registros de la Sucursal Sur).

La diferencia radica en que UNION realiza un filtrado de duplicados completos en el conjunto de atributos seleccionados (id_producto, nombre_producto, categoria), mientras que UNION ALL apila incondicionalmente todos los registros de ambas fuentes.

Ejemplos concretos de deduplicación:
* Los productos con id_producto 103 (Monitor 4K 27"), 104 (Teclado Mecánico) y 106 (SSD Externo 1TB) existen en ambas sucursales con idénticos nombres y categorías. Al ejecutar UNION en el catálogo, estas coincidencias se reducen a una sola fila por producto.
* Nota sobre la Webcam: La Webcam de Norte (id_producto 107) y la de Sur (id_producto 111) no se eliminaron en UNION porque poseen distinto id_producto, demostrando que UNION evalúa la fila completa proyectada y no solo el nombre.

---

### 2. ¿Por qué UNION ALL es más eficiente que UNION? ¿Qué operación adicional realiza UNION internamente que consume más recursos?
UNION ALL es significativamente más eficiente porque limita su trabajo a concatenar directamente los conjuntos de datos recibidos de cada consulta parcial, sin inspeccionar el contenido de las filas.

Por el contrario, el operador UNION debe garantizar la unicidad del resultado final. Para lograr esto, el motor de la base de datos debe ejecutar internamente un algoritmo de ordenamiento o una tabla Hash (Sort / Distinct Hash) sobre el resultado combinado para comparar cada columna de cada fila contra todas las demás y eliminar las duplicadas. Esta operación adicional incrementa el consumo de memoria RAM y el tiempo de CPU, volviéndose muy costosa en volúmenes masivos de datos.

---

### 3. ¿En qué casos de negocio usarías cada uno? Dá al menos dos ejemplos reales distintos a los del ejercicio.

Casos para UNION (Consolidación y Unicidad):
1. Padrón Único de Clientes: Consolidar la lista de clientes de dos sistemas de gestión distintos (ejemplo: CRM Web y CRM Tienda Física) para enviar una campaña masiva por email sin duplicar destinatarios.
2. Catálogo Unificado de Proveedores: Crear un listado maestro de proveedores combinando las bases de datos de distintas filiales regionales para homologar condiciones comerciales.

Casos para UNION ALL (Auditoría, Volumen y Métricas Históricas):
1. Histórico Transaccional Consolidado: Unir las tablas mensuales de ventas (ventas_enero, ventas_febrero, etc.) para calcular la facturación total anual. Si usáramos UNION, eliminaríamos ventas legítimas que coincidan en monto, fecha y cliente.
2. Auditoría Logística de Trazabilidad: Consolidar los registros de entradas y salidas de múltiples depósitos centrales para auditar el volumen total de movimientos físicos realizados por el personal.

---

### 4. ¿Qué pasa si las columnas de ambas consultas no coinciden en número o tipo? ¿Qué error genera SQL?
Para que los operadores UNION y UNION ALL funcionen correctamente, ambas sentencias SELECT deben cumplir estrictamente dos reglas de compatibilidad estructural:
1. Mismo número de columnas en el mismo orden.
2. Tipos de datos compatibles en cada posición correspondiente.

Si las columnas no coinciden:
* En número de columnas: SQL interrumpe la ejecución y arroja un error de sintaxis, como ERROR: EACH UNION QUERY MUST HAVE THE SAME NUMBER OF COLUMNS (en PostgreSQL) o ALL QUERIES COMBINED USING A UNION, INTERSECT OR EXCEPT OPERATOR MUST HAVE AN EQUAL NUMBER OF EXPRESSIONS IN THEIR TARGET LISTS (en SQL Server).
* En tipos de datos incompatibles: Si intentamos unir una columna de tipo VARCHAR con una de tipo INTEGER en la misma posición, el motor devolverá un error de conversión/coerción de tipos, por ejemplo: ERROR: UNION TYPES VARCHAR AND INTEGER CANNOT BE MATCHED.
