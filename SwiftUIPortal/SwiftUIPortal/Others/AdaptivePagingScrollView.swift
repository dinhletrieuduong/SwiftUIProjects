//
//  AdaptivePagingScrollView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 26/02/2024.
//

import SwiftUI

struct AdaptivePagingScrollView: View {
    
    private let items: [AnyView]
    private let itemPadding: CGFloat
    private let itemSpacing: CGFloat
    private let itemScrollableSide: CGFloat
    private let itemsAmount: Int
    private let visibleContentLength: CGFloat
    
    private let initialOffset: CGFloat
    private let scrollDampingFactor: CGFloat = 0.66
    private let orientation: Orientation
    
    @Binding var currentPageIndex: Int
    
    @State private var currentScrollOffset: CGFloat = 0
    @State private var gestureDragOffset: CGFloat = 0
    
    private func countOffset(for pageIndex: Int) -> CGFloat {
        
        let activePageOffset = CGFloat(pageIndex) * (itemScrollableSide + itemPadding)
        return initialOffset - activePageOffset
    }
    
    private func countPageIndex(for offset: CGFloat) -> Int {
        
        guard itemsAmount > 0 else { return 0 }
        
        let offset = countLogicalOffset(offset)
        let floatIndex = (offset)/(itemScrollableSide + itemPadding)
        
        var index = Int(round(floatIndex))
        if max(index, 0) > itemsAmount {
            index = itemsAmount
        }
        
        return min(max(index, 0), itemsAmount - 1)
    }
    
    private func countCurrentScrollOffset() -> CGFloat {
        return countOffset(for: currentPageIndex) + gestureDragOffset
    }
    
    private func countLogicalOffset(_ trueOffset: CGFloat) -> CGFloat {
        return (trueOffset-initialOffset) * -1.0
    }
    
    private func changeFocus() {
        withAnimation {
            currentScrollOffset = countOffset(for: currentPageIndex)
        }
    }
    
    init<A: View>(currentPageIndex: Binding<Int>,
                  itemsAmount: Int,
                  itemScrollableSide: CGFloat,
                  itemPadding: CGFloat,
                  visibleContentLength: CGFloat,
                  orientation: Orientation,
                  @ViewBuilder content: () -> A) {
        
        let views = content()
        self.items = [AnyView(views)]
        
        self._currentPageIndex = currentPageIndex
        
        self.itemsAmount = itemsAmount
        self.itemSpacing = itemPadding
        self.itemScrollableSide = itemScrollableSide
        self.itemPadding = itemPadding
        self.visibleContentLength = visibleContentLength
        self.orientation = orientation
        
        let itemRemain = (visibleContentLength-itemScrollableSide-2*itemPadding)/2
        self.initialOffset = itemRemain + itemPadding
    }
    
    @ViewBuilder
    func contentView() -> some View {
        switch orientation {
            case .horizontal:
                HStack(alignment: .center, spacing: itemSpacing) {
                    ForEach(items.indices, id: \.self) { itemIndex in
                        items[itemIndex].frame(width: itemScrollableSide)
                    }
                }
            case .vertical:
                VStack(alignment: .leading, spacing: itemSpacing) {
                    ForEach(items.indices, id: \.self) { itemIndex in
                        items[itemIndex].frame(height: itemScrollableSide)
                    }
                }
        }
    }
    
    var body: some View {
        GeometryReader { _ in
            contentView()
        }
        .onAppear {
            currentScrollOffset = countOffset(for: currentPageIndex)
        }
        .background(Color.black.opacity(0.00001)) // hack - this allows gesture recognizing even when background is transparent
        .frameModifier(visibleContentLength, currentScrollOffset, orientation)
        .simultaneousGesture(
            DragGesture(minimumDistance: 1, coordinateSpace: .local)
                .onChanged { value in
                    switch orientation {
                        case .horizontal:
                            gestureDragOffset = value.translation.width
                        case .vertical:
                            gestureDragOffset = value.translation.height
                    }
                    currentScrollOffset = countCurrentScrollOffset()
                }
                .onEnded { value in
                    let cleanOffset: CGFloat
                    switch orientation {
                        case .horizontal:
                            cleanOffset = (value.predictedEndTranslation.width - gestureDragOffset)
                        case .vertical:
                            cleanOffset = (value.predictedEndTranslation.height - gestureDragOffset)
                    }
                    let velocityDiff = cleanOffset * scrollDampingFactor
                    
                    var newPageIndex = countPageIndex(for: currentScrollOffset + velocityDiff)
                    
                    let currentItemOffset = CGFloat(currentPageIndex) * (itemScrollableSide + itemPadding)
                    
                    if currentScrollOffset < -(currentItemOffset),
                       newPageIndex == currentPageIndex {
                        newPageIndex += 1
                    }
                    
                    gestureDragOffset = 0
                    
                    withAnimation(.interpolatingSpring(mass: 0.1,
                                                       stiffness: 20,
                                                       damping: 1.5,
                                                       initialVelocity: 0)) {
                        self.currentPageIndex = newPageIndex
                        self.currentScrollOffset = self.countCurrentScrollOffset()
                    }
                }
        )
        .contentShape(Rectangle())
        .onChange(of: currentPageIndex, perform: { _ in changeFocus() })
    }
}


struct OnboardingCard: Codable, Identifiable, Equatable {
    
    var id: UUID
    var title: String
    var subTitle: String
    var image: String
}

class OnboardingCardsData: ObservableObject {
    
    let cards: [OnboardingCard]
    
    var primary: OnboardingCard {
        cards.first!
    }
    
    init() {
        cards = Bundle.main.decode([OnboardingCard].self, from: "cards.json")
    }
}

extension Bundle {
    
    func decode<T: Decodable>(_ type: T.Type,
                              from file: String,
                              dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                              keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> T {
        
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Failed to decode \(file) from bundle due to type mismatch – \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing \(type) value – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON")
        } catch {
            fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
        }
    }
}


struct PagingOnboardingView: View {
    
    let onboardData = OnboardingCardsData()
    
    @State private var scrollEffectValue: Double = 13
    @State private var activePageIndex: Int = 0
    @Binding var isPresented: Bool
    
    let itemWidth: CGFloat = 260
    let itemPadding: CGFloat = 20
    
    var body: some View {
        ZStack{
            VStack(alignment: .center, spacing: 25) {
                HStack {
                    PagingPageControl(numberOfPages: self.onboardData.cards.count,
                                currentPage: $activePageIndex)
                    .foregroundColor(Color.nightBlue)
                    .aspectRatio(3 / 2, contentMode: .fit)
                    .frame(width: 165, height: 42)
                    Spacer()
                }
                GeometryReader { geometry in
                    AdaptivePagingScrollView(currentPageIndex: self.$activePageIndex,
                                             itemsAmount: self.onboardData.cards.count - 1,
                                             itemScrollableSide: self.itemWidth,
                                             itemPadding: self.itemPadding,
                                             visibleContentLength: geometry.size.width,
                                             orientation: .horizontal) {
                        ForEach(onboardData.cards) { card in
                            GeometryReader { screen in
                                OnbardingCardView(card: card)
                                    .rotation3DEffect(Angle(degrees: (Double(screen.frame(in: .global).minX) - 20) / -15),
                                                      axis: (x: 0, y: 90.0, z: 0))
                                
                                    .scaleEffect(activePageIndex == onboardData.cards.firstIndex(of: card) ?? 0 ? 1.05 : 1)
                            }
                            .frame(width: self.itemWidth, height: 600)
                        }
                    }
                }
                
                Spacer()
                
                OnboardingContinueButton(
                    isReadyToContinue: .constant(onboardData.cards.count - 1 == activePageIndex),
                    isPresented: $isPresented
                )
            }
        }
        .background(Color.black)
    }
}

struct OnboardingContinueButton: View {
    
    @Binding var isReadyToContinue: Bool
    @Binding var isPresented: Bool
    @State private var animateGradient = false
    
    var body: some View {
        Button(action: { isPresented = false }) {
            
            let buttonTitle = isReadyToContinue ? "Let's continue" : "Skip"
            let buttonImage = isReadyToContinue ? "location.fill" : "location"
            let gradientColors = isReadyToContinue ? [Color.purple, Color.nightBlue] : [Color.purple, Color.black]
            
            HStack {
                Image(systemName: buttonImage)
                    .foregroundColor(Color.white)
                    .frame(width: 20, height: 20)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                Text(buttonTitle)
                    .font(.bold(.subheadline)())
                    .foregroundColor(Color.white)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 40))
                
            }
            .padding(5)
            .background(
                LinearGradient(colors: gradientColors,
                               startPoint: animateGradient ? .topLeading : .bottomLeading,
                               endPoint: animateGradient ? .bottomTrailing : .topTrailing)
                .ignoresSafeArea()
            )
            .cornerRadius(15)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 2.0).repeatForever(autoreverses: true)) {
                animateGradient.toggle()
            }
        }
    }
}

struct OnbardingCardView: View {
    
    var card: OnboardingCard
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            Text(card.title.capitalized)
                .colorInvert()
                .font(.system(size: 48, weight: .bold, design: .rounded))
            VStack(alignment: .leading, spacing: 25) {
                Text(card.subTitle)
                    .colorInvert()
                    .font(.bold(.headline)())
                    .lineLimit(3)
                    .frame(width: 200)
                    .fixedSize()
                    .padding()
                Image(card.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220, height: 200, alignment: .center)
            }
            .padding(20)
            .background(Color.nightBlue)
            .cornerRadius(25)
        }
    }
}


struct PagingPageControl: UIViewRepresentable {
    
    var numberOfPages: Int
    @Binding var currentPage: Int
    
    func makeCoordinator() -> PagingCoordinator {
        PagingCoordinator(self)
    }
    
    func makeUIView(context: Context) -> UIPageControl {
        
        let control = UIPageControl()
        control.numberOfPages = numberOfPages
        control.addTarget(context.coordinator,
                          action: #selector(Coordinator.updateCurrentPage(sender:)),
                          for: .valueChanged)
        return control
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
    }
    
    class PagingCoordinator: NSObject {
        
        var control: PagingPageControl
        
        init(_ control: PagingPageControl) {
            self.control = control
        }
        
        @objc
        func updateCurrentPage(sender: UIPageControl) {
            control.currentPage = sender.currentPage
        }
    }
}

extension Color {
    static var nightBlue = Color(UIColor(red: 0.216, green: 0.196, blue: 0.812, alpha: 1))
}


enum Orientation {
    case horizontal, vertical
}

struct FrameModifier: ViewModifier {
    let contentLength: CGFloat
    let currentScrollOffset: CGFloat
    let orientation: Orientation
    
    init (contentLength: CGFloat,
          visibleContentLength: CGFloat,
          currentScrollOffset: CGFloat,
          orientation: Orientation) {
        self.contentLength = contentLength
        self.currentScrollOffset = currentScrollOffset
        self.orientation = orientation
    }
    
    func body(content: Content) -> some View {
        switch orientation {
            case .horizontal:
                return content
                    .frame(width: contentLength)
                    .offset(x: self.currentScrollOffset, y: 0)
            case .vertical:
                return content
                    .frame(height: contentLength)
                    .offset(x: 0, y: self.currentScrollOffset)
        }
    }
}

extension View {
    func frameModifier(_ contentLength: CGFloat,
                       _ currentScrollOffset: CGFloat,
                       _ orientation: Orientation) -> some View {
        modifier(
            FrameModifier(
                contentLength: contentLength,
                visibleContentLength: contentLength,
                currentScrollOffset: currentScrollOffset,
                orientation: orientation
            )
        )
    }
}


#Preview {
    PagingOnboardingView(isPresented: .constant(true))
}

