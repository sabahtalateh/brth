import SwiftUI

struct ContentView: View {
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            // SidebarView()
        } detail: {
            // DetailView()
        }
        .navigationSplitViewStyle(.balanced)
        .tint(.primary)
        // .opacity(playStore.hideSidebar ? 0 : 1)
    }
}

#Preview {
    ContentView()
}
