# App Finanzas: ficha de la v1

Última actualización: 20 de septiembre de 2026
Estado: idea, alcance y stack cerrados; entorno de desarrollo preparado. Pendientes: forma de trabajo con Claude Code (reglas, skills, subagentes, hooks) y spike técnico.

## 1. Problema y propuesta

Llevar en un solo sitio las finanzas propias y las de pareja, de forma sencilla, visual y agradable, cuidando el detalle.

Puntos de dolor detectados:

- **Fricción al registrar.** El modelo de referencia es un Excel manual con tickets guardados y pasados cada fin de semana. La app debe hacer que registrar un gasto cueste segundos.
- **Estética y experiencia.** Settle Up cumple para gastos compartidos, pero no resulta agradable de usar.
- **Lo personal y lo compartido, por separado.** Hoy van por herramientas distintas.

## 2. Usuarios de la v1

Carlos y su pareja. Ellos son los primeros usuarios y la vara de medir: si dejan de usarla, algo falla.

## 3. Cómo gestiona la pareja sus gastos (caso de uso real)

1. **Fondo común.** A principio de mes, cada uno aporta la misma cantidad (por ejemplo 300 €) a una cuenta conjunta. De ahí se pagan alimentación, facturas, etc.
   - La aportación es una **transferencia**, no un gasto.
   - Cada gasto que sale de la cuenta conjunta se reparte **50/50** y no genera deuda.
   - En la vista personal de cada uno aparece **su mitad** de esos gastos.
2. **Gastos pagados por uno.** Compras extraordinarias, o gastos del hogar pagados con la tarjeta personal.
   - Reparto 50/50 y **balance corriente único** entre los dos.
   - Se compensa con el siguiente gasto pagado por el otro.
   - Debe existir la opción de **liquidar** explícitamente (Bizum, efectivo).

## 4. Alcance de la v1

### Imprescindible

- **Registro:** entrada rápida, foto de ticket adjunta (sin lectura automática), notas y recurrentes (nómina, alquiler, suscripciones).
- **Acceso rápido para añadir gasto.**
- **Cuentas:** varias cuentas, cuenta conjunta y transferencias entre cuentas.
- **Reparto:** partes iguales 50/50.
- **Pareja:** vinculación, balance neto, liquidar y barra de "cuánto queda del fondo del mes".
- **Análisis:** totales por categoría y periodo, y evolución mensual.
- **Transversales:** funcionamiento offline y copia de seguridad.

### Deseable (entra si hay hueco)

- Plantillas y favoritos para gastos repetidos.
- Etiquetas.
- Reparto por importes o porcentajes.
- Presupuestos por categoría.
- Exportar a CSV/Excel.
- Bloqueo biométrico.
- Modo oscuro.
- Preparación para más idiomas (español primero).

### Fuera de la v1

- Multimoneda.
- Lectura automática de tickets (OCR).
- Conexión al banco e importación de movimientos.
- Grupos de amigos y viajes (invitados sin cuenta, simplificación de deudas).
- Repartos por partes, por ingresos o por líneas del ticket, y varios pagadores.
- Integración con Bizum (registrar la liquidación a mano sí entra).
- Alertas y detección de suscripciones.
- Widgets más allá del de añadir gasto.

## 5. Hitos

1. **Personal:** cuentas, categorías, registro rápido con foto y notas, recurrentes, totales y evolución. Local y offline, sin backend.
2. **Pareja:** vinculación, sincronización, cuenta conjunta con barra del fondo del mes, balance neto y liquidar.
3. **Acceso rápido y pulido:** widget y lo que salga de usar la app.

## 6. Privacidad (v1)

- Cifrado estándar en tránsito y en el servidor.
- Servidores en la UE.
- Fotos de tickets privadas, accesibles solo para el espacio al que pertenecen.
- Exportar y borrar los datos de un usuario.
- Sin publicidad ni rastreadores de terceros.
- Bloqueo biométrico (deseable).
- La app registra y calcula, pero no da asesoramiento financiero.

## 7. Criterio de éxito de la v1

- **Uso real:** los dos la usan durante unos 2 meses seguidos sin volver a Settle Up para los gastos compartidos.
- **Rapidez:** registrar un gasto habitual cuesta menos de unos 10 segundos.
- **Fiabilidad:** el balance entre los dos cuadra siempre y no se pierden datos, tampoco sin conexión.
- **Experiencia:** ninguno de los dos siente pereza al abrirla.

## 8. Aplazado, con fecha límite: antes de abrir la app a terceros

- Modelo de negocio (qué es gratis y qué es de pago).
- Cifrado de extremo a extremo.
- RGPD: política de privacidad, base legal y contratos con proveedores.
- Validar que la idea interesa a gente ajena al proyecto (por ejemplo, personas que hoy usan un Excel para controlar sus gastos).
- No prometer "gratis para siempre" a terceros hasta tener el modelo decidido.
- Nombre definitivo de la app, con comprobación de dominios y marcas antes de publicar. Nombre técnico provisional: `app-finanzas` (repositorio) y `dev.appfinanzas.app_finanzas` (identificador Android). Descartado tras comprobarlo: Qadra, por existir una empresa fintech con ese nombre.

## 9. Stack de la v1 (cerrado, a confirmar con el spike)

- **Cliente:** Flutter (Dart), solo Android en la v1. iOS y web quedan abiertos para más adelante.
- **Datos locales y sincronización:** SQLite en el móvil con PowerSync. Drift como capa opcional, a decidir en el spike.
- **Backend (a partir del hito 2):** Supabase (Postgres, autenticación, almacenamiento de fotos), con el plan gratuito para empezar.
- **Sin backend propio (Spring Boot) en la v1.**
- **Coste de arranque:** 0 €. El plan gratuito de Supabase pausa el proyecto tras una semana sin actividad y no incluye copias de seguridad; con datos reales conviene el plan de pago (unos 25 $/mes según fuentes de terceros, a verificar en la web oficial).
- **Pendiente de verificar:** región de la UE en Supabase y PowerSync Cloud; encaje de Drift con PowerSync; que el hito 1 use ya la misma base de datos local que luego sincronizará; widget de añadir gasto en Android con Flutter.

## 10. Notas técnicas de diseño

Se derivan de los requisitos de la ficha y hay que respetarlas en el diseño:

- **Offline como imprescindible:** condiciona la arquitectura; añadirlo después es muy caro.
- **Sincronización entre dos usuarios** desde el hito 2, con datos compartidos entre dos cuentas.
- **Fotos como archivos:** decidir dónde se guardan y cómo se sincronizan. Guardarlas comprimidas y con su tamaño registrado, para poder medir y limitar por espacio de pareja.
- **Widget de añadir gasto:** exige código nativo de cada plataforma. Es la parte más costosa del acceso rápido, por eso va al final. Abrir directamente en "nuevo gasto" o un atajo en el icono es barato.
- **Moneda guardada en cada transacción** desde el principio, aunque la multimoneda quede fuera.
- **Las cuentas no siempre pertenecen a una persona:** la cuenta conjunta pertenece al espacio de pareja.
- **Los saldos y balances se derivan**, no se almacenan.
- **Importes en céntimos** (enteros), nunca decimales.
- **Servidores en la UE.**
- Un solo desarrollador, con desarrollo asistido por Claude Code.

El borrador de modelo de datos discutido al principio de la conversación es **provisional** y se rehará con estas notas y con el resultado del spike.

## 11. Referencias de mercado consultadas (septiembre de 2026)

Las fuentes son mayoritariamente comparativas de apps competidoras: sirven para ver el mapa, no para dar por buenos precios ni límites exactos. Conviene verificarlas usando las apps.

- **Gastos compartidos:** Splitwise, Tricount, Settle Up, Splid.
- **Control personal:** YNAB, Monarch, Spendee, Wallet, Money Manager, Monefy.
- **España:** Fintonic (agregador bancario) y la app de BBVA (reparto de gastos con Bizum).
- **Prueba práctica pendiente:** contar toques y segundos para registrar un gasto en 3 o 4 de estas apps, como vara de medir de la rapidez.
