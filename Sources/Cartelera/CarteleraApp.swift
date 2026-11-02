import CarteleraUI
import SwiftUI

@main
struct CarteleraApp: App {
    var body: some Scene {
        Window("Cartelera", id: "principal") {
            VistaPrincipal()
                .frame(minWidth: 820, minHeight: 560)
        }
        .defaultSize(width: 940, height: 680)
        .windowStyle(.hiddenTitleBar)          // el degradado sube hasta los semáforos
        .windowResizability(.contentMinSize)
        .commands {
            CommandGroup(replacing: .newItem) {}   // no hay documentos que crear
        }
    }
}
