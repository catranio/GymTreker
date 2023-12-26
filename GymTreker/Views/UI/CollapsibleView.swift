import SwiftUI

struct Collapsible<Header: View, Content: View>: View {
	@State var isOpened: Bool = false

	@ViewBuilder var content: Content
	@ViewBuilder var header: Header

	@State private var textSize: CGSize = .zero

	var body: some View {
		VStack {
			Button {
				withAnimation {
					isOpened.toggle()
				}
			} label: {
				HStack {
					header
					Spacer()
					Image(systemName: "chevron.down")
						.rotationEffect(isOpened ? .degrees(180) : .degrees(0))
				}
				.contentShape(Rectangle())
			}
			.buttonStyle(.plain)
			content
				.frame(height: isOpened ? nil : 0, alignment: .top)
				.clipped()
		}
	}
}

#Preview {
	Collapsible {
		VStack {
			ForEach(0 ..< 5, id: \.self) { _ in
				HStack {
					Circle()
						.frame(width: 75, height: 75)

					VStack(alignment: .leading) {
						Rectangle()
							.frame(width: 80, height: 6)
						Rectangle()
							.frame(width: 60, height: 6)
					}
					Spacer()
				}
				.padding()
				.background(.blue.opacity(0.7), in: .rect(cornerRadius: 15))
				.padding()
			}
		}
	} header: {
		HStack {
			Text("Some header")
		}
			.font(.largeTitle)
	}
}
