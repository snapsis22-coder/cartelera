import CarteleraKit
import SwiftUI

/// Pantallas con datos de muestra, para `cartelerashot`.
@MainActor
public enum Retratos {

    public static func vacia() -> some View {
        let modelo = Modelo(demo: true)
        modelo.entrada = URL(fileURLWithPath: "/Users/snapsis/Downloads")
        modelo.peliculas = URL(fileURLWithPath: "/Volumes/DATOS/Peliculas")
        modelo.series = URL(fileURLWithPath: "/Volumes/DATOS/Series")
        return Pantalla(modelo: modelo)
    }

    public static func conDescargas(automatico: Bool = false) -> some View {
        let modelo = Modelo(demo: true)
        let raiz = URL(fileURLWithPath: "/tmp/cartelera-demo-\(UUID().uuidString)")
        modelo.entrada = raiz.appendingPathComponent("Downloads")
        modelo.peliculas = raiz.appendingPathComponent("Peliculas")
        modelo.series = raiz.appendingPathComponent("Series")

        let nombres = [
            "Verity.2026.REPACK.2160p.AMZN.WEB-DL.DDP5.1.Atmos.DV.HDR.H.265-BYNDR.mkv",
            "Tulsa King S04E02 Blind Rooster 2160p ATV WEB-DL DDP5 1 Atmos DV HDR H 265-FLUX.mkv",
            "Send Help (2026) [2160p] [4K] [BluRay] [5.1] [YTS.BZ]",
            "Ted Lasso (2022) Season 4",
            "Solo.Mio.1080p.WEB-DL.HEVC.x265.mkv",
            "THE.INVITE.2026.1080p.AMZN.WEB-DL.DUAL.DDP5.1.H.264-ONIROS.mkv",
        ]
        modelo.filas = nombres.map { nombre in
            let origen = modelo.entrada!.appendingPathComponent(nombre)
            var lectura = Analizador.leer(nombre)
            if nombre.hasPrefix("Ted") { lectura = .serie(nombre: "Ted Lasso", temporada: 4, episodio: nil) }
            return Fila(examen: Examen(origen: origen, forma: .archivo(video: origen, acompañantes: []), lectura: lectura))
        }
        modelo.filas[5].resultado = .hecho
        modelo.automatico = automatico
        return Pantalla(modelo: modelo, sinScroll: true)
    }

    public static func editor() -> some View {
        Editor(lectura: .pelicula(titulo: "Solo Mio", año: nil), guardar: { _ in }, cancelar: {})
            .background(Tema.tarjeta)
    }
}
