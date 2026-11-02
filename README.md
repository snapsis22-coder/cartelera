# Cartelera

> **Esta app ya no se mantiene por separado.** Desde la versión 1.5.0 vive dentro de [SubFix](https://github.com/snapsis22-coder/subfix), como la pestaña **Organizar**. Este repositorio queda como archivo de la versión independiente.

App de macOS que ordena las películas y series que descargas en la estructura que entienden Jellyfin y Plex.

## Qué hace

Le señalas tu carpeta de descargas y, para cada cosa que encuentra, lee el título, el año y el `S01E02` del nombre del archivo o de su carpeta, y te muestra a dónde va antes de mover nada:

```
Películas/Título (Año)/Título (Año).mkv
Series/Serie/Season 01/Serie S01E02.mkv
```

- Una película suelta se lleva sus `.srt` y `.nfo` del mismo nombre; una carpeta de película se renombra entera.
- Un capítulo entra en su temporada; una carpeta con varios capítulos de la misma serie y temporada se toma como temporada completa.
- Si lee mal un nombre, lo corriges con el lápiz.
- **Nunca sobrescribe:** si el destino ya existe, lo marca y no lo toca.
- **Deshacer** devuelve el último lote a su sitio.
- **Automático** repasa la carpeta cada 30 segundos, solo mueve lo que dejó de crecer (nada de `.part` ni `.crdownload`) y avisa con una notificación.

## Compilar

Necesitas macOS 14 o posterior y las herramientas de línea de comandos de Xcode.

```sh
./build_app.sh                 # compila, firma e instala en /Applications
swift run carteleratests       # 31 pruebas con nombres de archivo reales
```

`build_app.sh` firma con una identidad local llamada `snapsis-dev`. Si no la tienes, cae a firma ad-hoc y funciona igual.

## Licencia

[MIT](LICENSE).
