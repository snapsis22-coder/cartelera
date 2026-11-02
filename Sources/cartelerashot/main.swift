import AppKit
import CarteleraUI
import SwiftUI

/// Renderiza la interfaz a PNG sin abrir ventana, para poder revisarla sin
/// depender del permiso de grabación de pantalla del sistema.
///
///     swift run cartelerashot <carpeta-de-salida>
///
/// ⚠ Igual que en SubFix: `List`, `Form` y los campos de texto son AppKit y salen
/// en blanco. Por eso la lista de Cartelera es un ScrollView propio.

@MainActor
func retratar<V: View>(_ vista: V, _ nombre: String, en carpeta: URL,
                       ancho: CGFloat = 940, alto: CGFloat = 680, oscuro: Bool = false) {
    let renderizador = ImageRenderer(content:
        vista.frame(width: ancho, height: alto)
            .environment(\.colorScheme, oscuro ? .dark : .light)
    )
    renderizador.scale = 2
    guard let imagen = renderizador.nsImage,
          let tiff = imagen.tiffRepresentation,
          let mapa = NSBitmapImageRep(data: tiff),
          let png = mapa.representation(using: .png, properties: [:]) else {
        print("  ✗ no se pudo renderizar \(nombre)")
        return
    }
    let destino = carpeta.appendingPathComponent("\(nombre).png")
    try? png.write(to: destino)
    print("  ✓ \(destino.path)")
}

guard let salida = CommandLine.arguments.dropFirst().first.map({ URL(fileURLWithPath: $0) }) else {
    print("uso: cartelerashot <carpeta-de-salida>")
    exit(1)
}
try? FileManager.default.createDirectory(at: salida, withIntermediateDirectories: true)

let app = NSApplication.shared
app.setActivationPolicy(.accessory)

MainActor.assumeIsolated {
    retratar(Retratos.vacia(), "1-vacia", en: salida)
    retratar(Retratos.conDescargas(), "2-descargas", en: salida)
    NSApp.appearance = NSAppearance(named: .darkAqua)
    retratar(Retratos.conDescargas(automatico: true), "3-descargas-oscuro", en: salida, oscuro: true)
    NSApp.appearance = NSAppearance(named: .aqua)
    retratar(Retratos.editor(), "4-editor", en: salida, ancho: 320, alto: 330)
}
