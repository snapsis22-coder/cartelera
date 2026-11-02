// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Cartelera",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "CarteleraKit", targets: ["CarteleraKit"]),
        .library(name: "CarteleraUI", targets: ["CarteleraUI"]),
        .executable(name: "Cartelera", targets: ["Cartelera"]),
        .executable(name: "carteleratests", targets: ["carteleratests"]),
        .executable(name: "cartelerashot", targets: ["cartelerashot"]),
    ],
    targets: [
        // Motor: entender el nombre de una descarga y planear a dónde va.
        // Sin nada de interfaz, para poder probarlo sin ventana.
        .target(name: "CarteleraKit"),

        // Igual que en SubFix: las vistas viven en una librería, no en el
        // ejecutable, porque las previews de SwiftUI no funcionan dentro de un
        // executableTarget.
        .target(name: "CarteleraUI", dependencies: ["CarteleraKit"]),

        .executableTarget(name: "Cartelera", dependencies: ["CarteleraUI"]),
        .executableTarget(name: "carteleratests", dependencies: ["CarteleraKit"]),
        // Retratos de la interfaz a PNG, para revisarla sin permiso de captura.
        .executableTarget(name: "cartelerashot", dependencies: ["CarteleraUI"]),
    ]
)
