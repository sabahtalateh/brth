import SwiftUI

struct Circles: View {
    
    @State private var elapsed: Double = 0
    
    var body: some View {
        VStack {
            GeometryReader { g in
                Circs(size: g.size)
                    .padding()
            }
        }
    }
}

struct Circs: View {
    
    let width = 101
    let gap = 5
    
    let size: CGSize
    
    var mn: Int {
        Int(min(size.width, size.height))
    }
    
    var radius: Int {
        let a = Int(mn) / 2
        return a
    }
    
    var crcs: Int {
        return if radius % width == 0 {
            (radius / (width)) - 1
        } else {
            radius / (width)
        }
    }
    
    var body: some View {
        VStack {
            Text("min = \(mn)\nrad = \(radius)\ncrcs = \(crcs)")
            ZStack{
                ForEach(0..<crcs, id: \.self) { i in
                    Circle()
                        .strokeBorder(.white, lineWidth: Double(width))
                        .padding(Double(i * (width)))
                }
            }
        }
    }
}

#Preview {
    Circles()
        .preferredColorScheme(.dark)
}
