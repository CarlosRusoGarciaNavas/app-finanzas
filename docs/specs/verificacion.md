# Especificación: verificación automática

Rama: `chore/verification`. Se entrega mediante pull request hacia `main`.

## Objetivo

Que ningún cambio se dé por bueno sin pasar formato, análisis estricto y tests, de forma automática y sin depender de que alguien se acuerde: en local, mientras Claude Code edita, y en remoto, en cada pull request.

## Entregables

### 1. Analizador estricto

- Mantener `include: package:flutter_lints/flutter.yaml` en `analysis_options.yaml`.
- Activar los tres modos de lenguaje estrictos del analizador: `strict-casts`, `strict-inference` y `strict-raw-types`.
- Proponer un conjunto pequeño de reglas de lint adicionales, cada una con una línea que justifique su valor para este proyecto (dominio de dinero, lógica testeable, código simple). Evitar reglas que choquen entre sí o con el formato de `dart format`.
- No anticipar exclusiones para código generado que todavía no existe.
- Comprobar y documentar cómo se comporta el código de salida de `flutter analyze` ante infos, warnings y errores. Debe fallar ante cualquier incidencia.

### 2. Hook local de formato

- Evento `PostToolUse` con matcher sobre las herramientas de edición y escritura de ficheros (`Edit|Write`).
- Solo actúa sobre ficheros `.dart`. Ejecuta `dart format` sobre el fichero editado.
- Debe funcionar en Windows con PowerShell, que es el entorno de trabajo. No asumir que existen `jq` ni `bash`. Verificar en la documentación oficial de hooks cómo elegir el intérprete y cómo se recibe el JSON de entrada.
- Si el formateo falla (por ejemplo, un error de sintaxis en el fichero), el error debe llegar a Claude. No enmascarar fallos con un `true` final.
- Vive en `.claude/settings.json` (compartido y versionado) y, si hace falta un script, en `.claude/hooks/`.
- Los hooks se ejecutan con los permisos completos del usuario y sin sandbox: el script debe ser mínimo, legible y sin acceso a red.

### 3. Hook de parada (a valorar en el plan, no obligatorio)

- Evento `Stop` que ejecute `flutter analyze` y bloquee el cierre del turno si falla.
- Debe incluir una protección contra bucles infinitos.
- El plan debe decir si compensa en tiempo, y por qué se incluye o se deja fuera. Los tests quedan fuera de este hook: los ejecuta la CI.

### 4. Integración continua

- Fichero `.github/workflows/ci.yml`.
- Se ejecuta en `pull_request` hacia `main` y en `push` a `main`.
- `ubuntu-latest`, con `actions/checkout` y `subosito/flutter-action@v2`, canal `stable`, con la versión de Flutter fijada a la que se usa en local, con caché activada. Consultar el README oficial de ambas acciones para las versiones actuales.
- Pasos, en este orden: `flutter pub get`, comprobación de formato con `dart format --output=none --set-exit-if-changed .`, `flutter analyze` y `flutter test`.
- Permisos mínimos del token (`contents: read`).

### 5. Finales de línea

- Añadir `.gitattributes` para normalizar a LF y evitar el ruido de avisos LF/CRLF en Windows. Los ficheros binarios (`.png`) se marcan como tales.
- Si hace falta renormalizar los ficheros existentes, hacerlo en un commit aparte.

### 6. Documentación

- Actualizar la sección Comandos de `CLAUDE.md` con el comando de comprobación de formato y una nota breve sobre qué comprueban el hook y la CI.
- Actualizar el estado de `CLAUDE.md`: entorno preparado y verificación automática en marcha.
- No añadir nada más a `CLAUDE.md`.

## Fuera de alcance

- Tests de dominio, cobertura, compilación del APK en CI, protección de rama y hooks de seguridad sobre ficheros con secretos (llegarán con Supabase).

## Criterios de aceptación

1. `flutter analyze` pasa sin incidencias con la nueva configuración.
2. Introduciendo a propósito una violación (por ejemplo, un cast implícito), `flutter analyze` falla. Después se revierte.
3. Si Claude Code edita un `.dart` mal formateado, queda formateado sin intervención.
4. Un pull request de prueba con un fichero mal formateado falla en el paso de formato de la CI. Con el fichero corregido, pasa en verde.
5. Todo el trabajo va en una rama y un pull request. Nada se sube directamente a `main`.

## Forma de trabajo

1. Empezar en modo plan. El plan se revisa antes de implementar.
2. Commits pequeños y separados: configuración del analizador, hook, CI, `.gitattributes` y documentación.
3. Al terminar, ejecutar `flutter analyze` y `flutter test` y mostrar la salida.
