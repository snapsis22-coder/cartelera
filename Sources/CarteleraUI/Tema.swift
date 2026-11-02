import AppKit
import SwiftUI

/// Los colores de Cartelera: morados de sala de cine, con fondo lavanda de día y
/// berenjena de noche, para que nada se vea gris.
public enum Tema {
    static let indigo = Color(red: 0.39, green: 0.40, blue: 0.95)
    static let morado = Color(red: 0.49, green: 0.23, blue: 0.93)
    static let lila = Color(red: 0.66, green: 0.33, blue: 0.97)
    static let rosa = Color(red: 0.93, green: 0.36, blue: 0.71)
    static let cielo = Color(red: 0.24, green: 0.60, blue: 0.98)
    static let verde = Color(red: 0.13, green: 0.70, blue: 0.47)
    static let ambar = Color(red: 0.96, green: 0.62, blue: 0.10)
    static let rojo = Color(red: 0.92, green: 0.28, blue: 0.35)

    static let degradado = LinearGradient(colors: [indigo, morado, lila],
                                          startPoint: .topLeading, endPoint: .bottomTrailing)
    static let degradadoSerie = LinearGradient(colors: [cielo, indigo],
                                               startPoint: .topLeading, endPoint: .bottomTrailing)
    static let degradadoPelicula = LinearGradient(colors: [morado, rosa],
                                                  startPoint: .topLeading, endPoint: .bottomTrailing)

    static let fondo = Color(claro: NSColor(red: 0.965, green: 0.949, blue: 1.0, alpha: 1),
                             oscuro: NSColor(red: 0.082, green: 0.067, blue: 0.122, alpha: 1))
    static let tarjeta = Color(claro: .white,
                               oscuro: NSColor(red: 0.129, green: 0.102, blue: 0.188, alpha: 1))
    static let borde = Color(claro: NSColor(red: 0.906, green: 0.867, blue: 0.984, alpha: 1),
                             oscuro: NSColor(red: 0.200, green: 0.157, blue: 0.290, alpha: 1))
    /// El morado para TEXTO: de noche se aclara, o se pierde sobre el fondo berenjena.
    static let acento = Color(claro: NSColor(red: 0.49, green: 0.23, blue: 0.93, alpha: 1),
                              oscuro: NSColor(red: 0.76, green: 0.60, blue: 1.0, alpha: 1))
    static let acentoSerie = Color(claro: NSColor(red: 0.33, green: 0.34, blue: 0.90, alpha: 1),
                                   oscuro: NSColor(red: 0.62, green: 0.68, blue: 1.0, alpha: 1))
    static let tinta = Color(claro: NSColor(red: 0.16, green: 0.10, blue: 0.30, alpha: 1),
                             oscuro: NSColor(red: 0.95, green: 0.93, blue: 1.0, alpha: 1))
    static let tintaSuave = Color(claro: NSColor(red: 0.42, green: 0.37, blue: 0.55, alpha: 1),
                                  oscuro: NSColor(red: 0.68, green: 0.64, blue: 0.80, alpha: 1))
}

extension Color {
    /// Un color que cambia solo con el modo claro u oscuro del sistema.
    init(claro: NSColor, oscuro: NSColor) {
        self.init(nsColor: NSColor(name: nil) { apariencia in
            apariencia.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua ? oscuro : claro
        })
    }
}

// MARK: - Botones

/// El botón grande de la acción principal: píldora con degradado, sombra morada,
/// se ilumina al pasar el ratón y se hunde un poco al pulsarlo.
struct BotonPrincipal: ButtonStyle {
    var compacto = false

    func makeBody(configuration: Configuration) -> some View {
        Cuerpo(configuration: configuration, compacto: compacto)
    }

    private struct Cuerpo: View {
        let configuration: Configuration
        let compacto: Bool
        @Environment(\.isEnabled) private var activo
        @State private var encima = false

        var body: some View {
            configuration.label
                .font(.system(size: compacto ? 12 : 13.5, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
                .padding(.horizontal, compacto ? 14 : 22)
                .padding(.vertical, compacto ? 7 : 11)
                .background(
                    Capsule().fill(Tema.degradado)
                        .overlay(Capsule().fill(.white.opacity(encima && activo ? 0.12 : 0)))
                        .overlay(Capsule().strokeBorder(.white.opacity(0.25), lineWidth: 1))
                )
                .shadow(color: Tema.morado.opacity(activo ? (encima ? 0.55 : 0.35) : 0), radius: encima ? 14 : 9, y: 4)
                .scaleEffect(configuration.isPressed ? 0.97 : 1)
                .saturation(activo ? 1 : 0.15)
                .opacity(activo ? 1 : 0.55)
                .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
                .animation(.easeOut(duration: 0.15), value: encima)
                .onHover { encima = $0 }
                .contentShape(Capsule())
        }
    }
}

/// El botón de acompañamiento: blanco (o berenjena de noche) con texto morado.
struct BotonSecundario: ButtonStyle {
    var compacto = false

    func makeBody(configuration: Configuration) -> some View {
        Cuerpo(configuration: configuration, compacto: compacto)
    }

    private struct Cuerpo: View {
        let configuration: Configuration
        let compacto: Bool
        @Environment(\.isEnabled) private var activo
        @State private var encima = false

        var body: some View {
            configuration.label
                .font(.system(size: compacto ? 12 : 13, weight: .semibold, design: .rounded))
                .foregroundStyle(Tema.acento)
                .padding(.horizontal, compacto ? 12 : 18)
                .padding(.vertical, compacto ? 6 : 10)
                .background(
                    Capsule().fill(Tema.tarjeta)
                        .overlay(Capsule().fill(Tema.morado.opacity(encima && activo ? 0.10 : 0)))
                        .overlay(Capsule().strokeBorder(Tema.morado.opacity(encima ? 0.55 : 0.30), lineWidth: 1))
                )
                .scaleEffect(configuration.isPressed ? 0.97 : 1)
                .opacity(activo ? 1 : 0.45)
                .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
                .animation(.easeOut(duration: 0.15), value: encima)
                .onHover { encima = $0 }
                .contentShape(Capsule())
        }
    }
}

/// Botón redondo de solo icono, para editar o quitar una fila.
struct BotonIcono: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        Cuerpo(configuration: configuration)
    }

    private struct Cuerpo: View {
        let configuration: Configuration
        @State private var encima = false

        var body: some View {
            configuration.label
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(encima ? Tema.acento : Tema.tintaSuave)
                .frame(width: 28, height: 28)
                .background(Circle().fill(Tema.morado.opacity(encima ? 0.12 : 0.05)))
                .scaleEffect(configuration.isPressed ? 0.92 : 1)
                .animation(.easeOut(duration: 0.12), value: encima)
                .onHover { encima = $0 }
                .contentShape(Circle())
        }
    }
}
