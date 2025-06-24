import SwiftUI

struct CardStackView: View {
    @Binding var places: [Place]
    @Binding var currentIndex: Int
    @State private var dragOffset: CGFloat = 0

    var body: some View {
        ZStack {
            ForEach(visibleIndices(), id: \.self) { idx in
                PlaceCardView(place: places[idx])
                    .offset(y: offset(for: idx) + (idx == currentIndex ? dragOffset : 0))
                    .scaleEffect(scale(for: idx))
                    .animation(.spring(), value: currentIndex)
                    .zIndex(Double(visibleIndices().count - (idx - currentIndex)))
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in dragOffset = value.translation.height }
                .onEnded { value in
                    if value.translation.height < -80 {
                        currentIndex = (currentIndex + 1) % places.count
                    } else if value.translation.height > 80 {
                        currentIndex = (currentIndex - 1 + places.count) % places.count
                    }
                    dragOffset = 0
                }
        )
    }

    private func visibleIndices() -> [Int] {
        guard !places.isEmpty else { return [] }
        let count = min(4, places.count)
        return (0..<count).map { (currentIndex + $0) % places.count }.reversed()
    }

    private func offset(for idx: Int) -> CGFloat {
        let pos = (idx - currentIndex + places.count) % places.count
        switch pos {
        case 0: return 0
        case 1: return -15
        case 2: return -30
        case 3: return -45
        default: return -45
        }
    }

    private func scale(for idx: Int) -> CGFloat {
        1
    }
}
