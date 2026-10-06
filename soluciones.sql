-- ══════════════════════════════════════════
-- RetailChain — UNION y UNION ALL
-- Autor: Rodrigo Gabarain
-- Fecha: 06/10/2026
-- ══════════════════════════════════════════

-- ── CONSULTA 1: UNION ────────────────────
-- Reporte de Catálogo Unificado para el área comercial.
-- Pregunta de negocio: ¿Qué productos únicos comercializa la empresa en toda su red?
-- Nota: Para obtener productos únicos a nivel de catálogo sin duplicar por diferencias de stock,
-- seleccionamos solo id_producto, nombre_producto y categoria.
SELECT 
    id_producto,
    nombre_producto,
    categoria
FROM inventario_sucursal_norte

UNION

SELECT 
    id_producto,
    nombre_producto,
    categoria
FROM inventario_sucursal_sur
ORDER BY id_producto;


-- ── CONSULTA 2: UNION ALL ────────────────
-- Auditoría de Stock Total para el área de operaciones.
-- Pregunta de negocio: ¿Cuántos registros físicos de stock existen en total entre ambas sucursales?
-- Conserva la totalidad de los registros de ambas tablas, incluyendo duplicados y métricas físicas por sucursal.
SELECT 
    id_producto,
    nombre_producto,
    categoria,
    stock
FROM inventario_sucursal_norte

UNION ALL

SELECT 
    id_producto,
    nombre_producto,
    categoria,
    stock
FROM inventario_sucursal_sur
ORDER BY id_producto;


-- ── CONSULTA 3: COMPARACIÓN DE RESULTADOS ─
-- Conteo de filas devueltas por cada operador para evidenciar la eliminación de duplicados.

SELECT COUNT(*) AS filas_union FROM (
    SELECT id_producto, nombre_producto, categoria FROM inventario_sucursal_norte
    UNION
    SELECT id_producto, nombre_producto, categoria FROM inventario_sucursal_sur
) AS resultado_union;

SELECT COUNT(*) AS filas_union_all FROM (
    SELECT id_producto, nombre_producto, categoria, stock FROM inventario_sucursal_norte
    UNION ALL
    SELECT id_producto, nombre_producto, categoria, stock FROM inventario_sucursal_sur
) AS resultado_union_all;