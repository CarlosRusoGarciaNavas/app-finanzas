# App Finanzas

App móvil (Flutter, solo Android en la v1) de finanzas personales y de pareja: gastos e ingresos propios, y un espacio compartido con la pareja (fondo común y balance de gastos). Desarrollador único: Carlos. Primeros usuarios: Carlos y su pareja.

Visión, alcance, hitos y criterio de éxito: @docs/vision-v1.md

## Estado

- Fase actual: entorno preparado y verificación automática en marcha; luego spike, luego hito 1 (personal, local y offline, sin backend).
- El nombre del proyecto y el identificador del paquete Android son provisionales.

## Stack

- Cliente: Flutter (Dart), solo Android en la v1.
- Datos locales y sincronización: SQLite en el dispositivo con PowerSync. Si se usa Drift encima, se decide en el spike.
- Backend (a partir del hito 2): Supabase (Postgres, autenticación, almacenamiento de fotos), región UE, plan gratuito para empezar.
- No hay backend propio (Spring Boot) en la v1.
- Arquitectura de la app y gestor de estado: pendientes de decidir en el spike. No introducir un patrón nuevo sin proponerlo antes.

## Comandos

- Analizar: `flutter analyze`
- Tests: `flutter test` (mientras se trabaja, preferir ejecutar solo el fichero afectado)
- Formato: `dart format .`
- Comprobar formato sin modificar: `dart format --output=none --set-exit-if-changed .`
- Ejecutar: `flutter run`

Antes de dar una tarea por terminada, `flutter analyze` y `flutter test` deben pasar sin errores. El hook local (solo Windows) formatea los `.dart` que Claude edita; la CI, en cada pull request hacia `main`, comprueba formato, análisis y tests.

## Reglas de dominio (no negociables)

- Importes: enteros en unidades menores (céntimos). Nunca `double` para dinero.
- Cada transacción guarda su moneda. En la v1 solo hay EUR, pero el campo existe.
- IDs: UUID v7, generados en el cliente.
- Toda tabla sincronizable lleva `updated_at` y borrado lógico (`deleted_at`).
- Los saldos y balances se calculan a partir de las transacciones. Nunca se almacenan.
- Todo dato pertenece a un espacio: personal o de pareja (`couple`). Los datos de un espacio personal no deben llegar nunca al dispositivo de la pareja.
- La cuenta conjunta pertenece al espacio de pareja, no a una persona.
- Las aportaciones a la cuenta conjunta son transferencias, no gastos.
- Un gasto pagado desde la cuenta conjunta se reparte 50/50 en las vistas personales y no genera deuda entre ellos.
- Un gasto pagado por una persona con su propia tarjeta se reparte 50/50 y genera deuda del otro en el balance neto único. Existe la opción de liquidar explícitamente.
- El reparto de céntimos sobrantes usa una regla fija y determinista (se define en la especificación del hito 2 y los tests deben cubrirla).
- La lógica de dominio (balances, repartos, redondeos) es Dart puro, sin importar Flutter, y tiene tests unitarios.

## Fuera de alcance de la v1

Multimoneda, lectura automática de tickets, conexión al banco, grupos de amigos, integración con Bizum, iOS y web. Si una tarea lo requiere, parar y preguntar.

## Seguridad y privacidad

- Nunca escribir claves, tokens ni credenciales en el repositorio. La configuración de Supabase va en ficheros locales ignorados por git.
- No registrar en logs importes ni datos personales.
- Toda tabla de Supabase tiene RLS activado y una política explícita.
- No modificar migraciones ya aplicadas: crear una nueva.
- Las fotos de tickets son privadas. Nunca URLs públicas.

## Calidad de código

- El dominio no depende de Flutter, Supabase ni PowerSync. Las dependencias apuntan siempre hacia el dominio.
- El acceso a datos va detrás de interfaces (repositorios), para poder probar el dominio con implementaciones en memoria.
- Toda regla de dominio tiene test unitario. Un bug se arregla escribiendo primero el test que lo reproduce.
- El analizador debe quedar sin warnings. No usar `// ignore` sin justificarlo en un comentario.
- Sin código muerto ni TODO sin issue asociado.
- Preferir la solución más simple que cumpla la especificación: no añadir abstracciones para casos que aún no existen.

## Convenciones

- Código, identificadores y mensajes de commit en inglés. Textos de la interfaz en español, sin cadenas fijas dentro de los widgets (preparado para más idiomas).
- Commits pequeños y descriptivos. Una rama por funcionalidad y pull request hacia `main`.
- Los cambios que afectan a varios ficheros o al modelo de datos: proponer un plan antes de implementar.
- Este fichero se revisa como código: añadir aquí lo que Claude se equivoque repetidamente y eliminar lo que ya haga bien sin la instrucción.
