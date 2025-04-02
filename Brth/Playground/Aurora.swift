
import SwiftUI

struct Aurora: View {
    
    var body: some View {
        FloatingClouds()
            .preferredColorScheme(.dark)
    }
}

fileprivate var colorSets: [[Color]] = [
    [
        .init(hex: 0x155e89), // blue
        .init(hex: 0x7fc5bd), // green
    ],
    // [
    //     .init(hex: 0xD14009).opacity(0.5), // red
    //     .init(hex: 0xFFE484).opacity(0.4), // yellow
    // ],
]

struct FloatingClouds: View {
    let blur: CGFloat = 0
    
    let colorzzz: [Color] = [
        Color(red: 158/255, green: 75/255, blue: 67/255, opacity: 0.7),
        Color(red: 84/255, green: 137/255, blue: 166/255, opacity: 0.6),
        Color(red: 191/255, green: 121/255, blue: 100/255, opacity: 0.8),
        Color(red: 243/255, green: 190/255, blue: 118/255, opacity: 0.65),
        Color(red: 103/255, green: 159/255, blue: 191/255, opacity: 0.45),
        
        // Color(red: 0.000, green: 0.175, blue: 0.216, opacity: 1),
        // Color(red: 0.408, green: 0.698, blue: 0.420, opacity: 0.61),
        // Color(red: 0.541, green: 0.733, blue: 0.812, opacity: 0.7),
        // Color(red: 0.525, green: 0.859, blue: 0.655, opacity: 0.45),
        
        Color(red: 0.000, green: 0.176, blue: 0.216, opacity: 1),
        Color(red: 0.408, green: 0.698, blue: 0.420, opacity: 0.61),
        Color(red: 0.541, green: 0.733, blue: 0.812, opacity: 0.7),
        Color(red: 0.525, green: 0.859, blue: 0.655, opacity: 0.45)
    ]
    
    @State private var colorSetIndex = 0
    @State private var colorIndex = 2
    @State private var colorChanges = 0
    
    @State var colors = [
        colorSets[0][0],
        colorSets[0][1],
    ]
    
    func changeColor() {
        let duration = Double.random(in: 5..<6)
        
        if colorChanges == 4 {
            colorChanges = 0
            
            colorSetIndex += 1
            
            if colorSetIndex >= colorSets.count {
                colorSetIndex = 0
            }
            
            withAnimation(.easeInOut(duration: duration)) {
                colors[0] = colorSets[colorSetIndex][0]
                colors[1] = colorSets[colorSetIndex][1]
            }
        } else {
            colorIndex += 1
            if colorIndex >= colorSets[colorSetIndex].count {
                colorIndex = 0
            }
            
            withAnimation(.easeInOut(duration: duration)) {
                let _ = colors.remove(at: 0)
                colors.append(colorSets[colorSetIndex][colorIndex])
            }

        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            changeColor()
        }
        
        colorChanges += 1
    }
    
    var body: some View {
        
        GeometryReader { g in
            let filled = 0.3
            let circleSize = g.size.width * 3
            let startRadius = circleSize / 2 - g.size.height * filled
            
            ZStack {
                
                ForEach(0..<3, id: \.self) { _ in
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    Color.clear,
                                    colors[0],
                                    colors[1],
                                    Color.clear
                                ]),
                                center: .center,
                                startRadius: startRadius,
                                endRadius: circleSize / 2
                            )
                        )
                        .frame(width: circleSize, height: circleSize)
                        .offset(
                            // x: (g.size.width - circleSize) / 2,
                            x: (g.size.width - circleSize) / 2,
                            y: (1.1 - filled) * g.size.height
                        )
                        .opacity(0.7)
                        // .blendMode(.plusLighter)
                        .blur(radius: 5)
                }
                
            }
            .blur(radius: 40)
            // .opacity(0.4)
        }
        .onAppear {
            changeColor()
        }
    }
}

struct MovingCircleView: View {
    
    let g: GeometryProxy
    let size: Double
    let color: Color
    let duration: Double
    
    @State private var offset: Double = 0
    
    var body: some View {
        let circleSize = size * g.size.height
        
        ZStack {
            // Circle()
            //     .fill(.thinMaterial)
            //     .frame(width: circleSize*1.1, height: circleSize)
            //     .offset(x: -circleSize, y: g.size.height-circleSize/2)
            //     .offset(x: offset)
            //     // .blur(radius: 40)
            //     // .blendMode(.plusLighter)
            //     .onAppear {
            //         withAnimation(.easeInOut(duration: duration)
            //             .repeatForever(autoreverses: false)
            //         ) {
            //             offset = g.size.width + circleSize
            //         }
            //     }
            
            Circle()
                .fill(color)
                .frame(width: circleSize, height: circleSize)
                .offset(x: -circleSize, y: g.size.height-circleSize/2)
                .offset(x: offset)
               
                // .blendMode(.plusLighter)
                .onAppear {
                    withAnimation(.easeInOut(duration: duration/10)
                        // .repeatForever()
                        // .repeatForever(autoreverses: false)
                    ) {
                        offset = g.size.width + circleSize
                    }
                }
        }
        .blur(radius: 40)
        .blendMode(.plusLighter)
        // .blur(radius: 40)
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

struct Cloud: View {
    @State var move = false
    @State var opacity = 0.8
    
    let proxy: GeometryProxy
    let color: Color
    
    private let frameHeightRatio =  CGFloat.random(in: 0.4..<0.5)
    // private let frameHeightRatio =  CGFloat(0.1)
    private let offset = CGSize(
        width: CGFloat.random(in: -150 ..< -50),
        // width: CGFloat(20),
        height: CGFloat.random(in: -150 ..< -50)
        // height: CGFloat(20)
    )
    
    var body: some View {
        let rotationStart = Double.random(in: 0..<360)
        let rotationDuration = Double.random(in: 20..<60)
        let opacityDuration = Double.random(in: 20..<60)
        
        Circle()
            .fill(color)
            .frame(height: proxy.size.height /  frameHeightRatio)
            .offset(offset)
            // .rotationEffect(.init(degrees: move ? rotationStart : rotationStart + 360))
            .rotationEffect(.init(degrees: move ? 0 : 360))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .opacity(opacity)
            .onAppear {
                withAnimation(Animation
                    .linear(duration: rotationDuration)
                    .repeatForever(autoreverses: false)
                ) {
                    move.toggle()
                }
                
                withAnimation(Animation
                    .linear(duration: opacityDuration)
                    .repeatForever(autoreverses: true)
                ) {
                    // opacity = 0
                }
            }
    }
}

#Preview {
    ZStack {
        Aurora()
        
        // Rectangle()
        //     .fill(.thinMaterial)
    }
    .ignoresSafeArea()
}
