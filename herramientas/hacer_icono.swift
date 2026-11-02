#!/usr/bin/env swift
// Dibuja el icono de Cartelera por código y arma el .icns.
//
//     swift herramientas/hacer_icono.swift
//
// Igual que en SubFix: nada de recursos externos. Fondo con el degradado morado de
// la app y encima el símbolo de la cabecera (película apilada) en blanco, con dos
// destellos que dicen «ordenado solo».

import AppKit

let lado = 1024.0

func dibujar(_ ctx: CGContext) {
    let espacio = CGColorSpaceCreateDeviceRGB()
    let fondo = CGRect(x: 0, y: 0, width: lado, height: lado).insetBy(dx: lado * 0.08, dy: lado * 0.08)
    let forma = CGPath(roundedRect: fondo, cornerWidth: lado * 0.2237 * 0.84, cornerHeight: lado * 0.2237 * 0.84, transform: nil)

    // Sombra suave bajo el icono, como los del sistema.
    ctx.saveGState()
    ctx.setShadow(offset: CGSize(width: 0, height: -lado * 0.012), blur: lado * 0.03,
                  color: CGColor(red: 0.20, green: 0.05, blue: 0.40, alpha: 0.35))
    ctx.addPath(forma)
    ctx.setFillColor(CGColor(red: 0.49, green: 0.23, blue: 0.93, alpha: 1))
    ctx.fillPath()
    ctx.restoreGState()

    // Degradado índigo → morado → lila, en diagonal como la cabecera.
    ctx.saveGState()
    ctx.addPath(forma)
    ctx.clip()
    let colores = [CGColor(red: 0.39, green: 0.40, blue: 0.95, alpha: 1),
                   CGColor(red: 0.49, green: 0.23, blue: 0.93, alpha: 1),
                   CGColor(red: 0.66, green: 0.33, blue: 0.97, alpha: 1)] as CFArray
    ctx.drawLinearGradient(CGGradient(colorsSpace: espacio, colors: colores, locations: [0, 0.55, 1])!,
                           start: CGPoint(x: fondo.minX, y: fondo.maxY),
                           end: CGPoint(x: fondo.maxX, y: fondo.minY), options: [])
    // Una luz rosada abajo a la izquierda y un brillo arriba, para que no se vea plano.
    let luz = [CGColor(red: 0.93, green: 0.36, blue: 0.71, alpha: 0.45),
               CGColor(red: 0.93, green: 0.36, blue: 0.71, alpha: 0)] as CFArray
    ctx.drawRadialGradient(CGGradient(colorsSpace: espacio, colors: luz, locations: [0, 1])!,
                           startCenter: CGPoint(x: fondo.minX + 120, y: fondo.minY + 100), startRadius: 0,
                           endCenter: CGPoint(x: fondo.minX + 120, y: fondo.minY + 100), endRadius: 520, options: [])
    let brillo = [CGColor(gray: 1, alpha: 0.12), CGColor(gray: 1, alpha: 0)] as CFArray
    ctx.drawLinearGradient(CGGradient(colorsSpace: espacio, colors: brillo, locations: [0, 1])!,
                           start: CGPoint(x: 0, y: fondo.maxY), end: CGPoint(x: 0, y: fondo.midY + 60), options: [])
    ctx.restoreGState()

    // El símbolo, en blanco y con una sombra morada para despegarlo del fondo.
    func simbolo(_ nombre: String, _ puntos: Double, _ centro: CGPoint, _ alfa: Double = 1) {
        let config = NSImage.SymbolConfiguration(pointSize: puntos, weight: .semibold)
            .applying(.init(paletteColors: [NSColor.white.withAlphaComponent(alfa)]))
        guard let img = NSImage(systemSymbolName: nombre, accessibilityDescription: nil)?
                .withSymbolConfiguration(config) else { return }
        let tam = img.size
        let rect = CGRect(x: centro.x - tam.width / 2, y: centro.y - tam.height / 2, width: tam.width, height: tam.height)
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(cgContext: ctx, flipped: false)
        ctx.setShadow(offset: CGSize(width: 0, height: -10), blur: 30,
                      color: CGColor(red: 0.25, green: 0.05, blue: 0.50, alpha: 0.45))
        img.draw(in: rect)
        NSGraphicsContext.restoreGraphicsState()
    }
    simbolo("film.stack.fill", 400, CGPoint(x: lado * 0.49, y: lado * 0.47))
    simbolo("sparkle", 150, CGPoint(x: lado * 0.75, y: lado * 0.74))
    simbolo("sparkle", 80, CGPoint(x: lado * 0.83, y: lado * 0.61), 0.85)
}

func png(_ tamaño: Int) -> Data {
    let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: tamaño, pixelsHigh: tamaño,
                               bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
                               colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
    let ctx = NSGraphicsContext(bitmapImageRep: rep)!.cgContext
    ctx.scaleBy(x: Double(tamaño) / lado, y: Double(tamaño) / lado)
    dibujar(ctx)
    return rep.representation(using: .png, properties: [:])!
}

let raiz = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent()
let juego = FileManager.default.temporaryDirectory.appendingPathComponent("AppIcon.iconset")
try? FileManager.default.removeItem(at: juego)
try! FileManager.default.createDirectory(at: juego, withIntermediateDirectories: true)
for base in [16, 32, 128, 256, 512] {
    try! png(base).write(to: juego.appendingPathComponent("icon_\(base)x\(base).png"))
    try! png(base * 2).write(to: juego.appendingPathComponent("icon_\(base)x\(base)@2x.png"))
}
try! png(1024).write(to: raiz.appendingPathComponent("Resources/icono-1024.png"))
let destino = raiz.appendingPathComponent("Resources/AppIcon.icns")
let proceso = Process()
proceso.executableURL = URL(fileURLWithPath: "/usr/bin/iconutil")
proceso.arguments = ["-c", "icns", juego.path, "-o", destino.path]
try! proceso.run()
proceso.waitUntilExit()
print(proceso.terminationStatus == 0 ? "✓ \(destino.path)" : "✗ iconutil falló")
