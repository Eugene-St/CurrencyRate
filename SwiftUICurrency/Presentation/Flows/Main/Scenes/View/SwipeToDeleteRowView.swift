import SwiftUI

struct SwipeCardRow<Content: View>: View {
    let content: () -> Content
    let onDelete: () -> Void
    
    @State private var dragOffset: CGFloat = 0
    @State private var offsetX: CGFloat = 0
    @State private var isSwiping = false
    
    private let maxSwipe: CGFloat = -80
    private let visibleDeleteGap: CGFloat = 20
    
    var body: some View {
        ZStack {
            ZStack(alignment: .trailing) {
                Color.orange
                    .cornerRadius(16)
                
                Button(action: {
                    withAnimation(.easeInOut) {
                        onDelete()
                    }
                }) {
                    Image(systemName: "trash.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold))
                        .padding(.trailing, 12)
                        .contentShape(Rectangle())
                }
                .padding(.trailing, 8)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            
            // MARK: - Main swipable content
            content()
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .offset(x: adjustedOffset)
                .simultaneousGesture(
                    DragGesture()
                        .onChanged { value in
                            if !isSwiping {
                                if abs(value.translation.width) > abs(value.translation.height) {
                                    isSwiping = true
                                } else {
                                    return
                                }
                            }
                            
                            let total = offsetX + value.translation.width
                            guard total <= 0 else { return }
                            if total > (maxSwipe + visibleDeleteGap) {
                                dragOffset = total
                            }
                        }
                        .onEnded { value in
                            let predictedEnd = offsetX + value.predictedEndTranslation.width
                            let final = predictedEnd.clamped(to: (maxSwipe + visibleDeleteGap)...0)
                            let revealThreshold = maxSwipe * 0.5
                            
                            withAnimation(.interpolatingSpring(stiffness: 200, damping: 25)) {
                                if final < revealThreshold {
                                    offsetX = maxSwipe + visibleDeleteGap
                                } else {
                                    offsetX = 0
                                }
                                dragOffset = 0
                                isSwiping = false
                            }
                        },
                    including: .gesture
                )
                .highPriorityGesture(
                    TapGesture()
                        .onEnded {
                            if offsetX != 0 {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    offsetX = 0
                                }
                            }
                        }
                )
        }
        .clipped()
        .animation(.easeInOut(duration: 0.25), value: offsetX)
    }
    
    private var adjustedOffset: CGFloat {
        dragOffset == 0 ? offsetX : dragOffset
    }
}

// MARK: - Comparable
extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}

