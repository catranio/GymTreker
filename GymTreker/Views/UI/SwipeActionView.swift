import SwiftUI

enum SwipeDirection {
	case leading, trailing

	var alignment: Alignment {
		switch self {
		case .leading:
			return .leading
		case .trailing:
			return .trailing
		}
	}
}

struct SwipeAction<Content: View>: View {
	var cornerRadius: CGFloat = 0
	var direction: SwipeDirection = .trailing
	@ViewBuilder var content: Content
	@ActionBuilder var actions: [Action]
	let viewId = UUID()
	@State private var isEnabled = true

	var body: some View {
		ScrollViewReader { scrollProxy in
			ScrollView(.horizontal) {
				LazyHStack(spacing: 0) {
					content
						.containerRelativeFrame(.horizontal)
						.background {
							if let action = actions.first {
								Rectangle()
									.fill(action.tint)
							}
						}
						.id(viewId)
						.transition(.identity)

					actionButtons {
						withAnimation(.snappy) {
							scrollProxy.scrollTo(viewId, anchor: direction == .trailing ? .topLeading : .topTrailing)
						}
					}
				}
				.scrollTargetLayout()
				.visualEffect { content, geometryProxy in
					content.offset(x: scrollOffset(geometryProxy))
				}
			}
			.scrollIndicators(.hidden)
			.scrollTargetBehavior(.viewAligned)
			.background {
				if let action = actions.last {
					Rectangle()
						.fill(action.tint)
				}
			}
			.clipShape(.rect(cornerRadius: cornerRadius))
		}
		.allowsHitTesting(isEnabled)
	}

	@ViewBuilder
	func actionButtons(resetPosition: @escaping () -> Void) -> some View {
		Rectangle()
			.fill(.clear)
			.frame(width: actions.reduce(0) { $0 + $1.iconWidth })
			.overlay(alignment: direction.alignment) {
				HStack(spacing: 0) {
					ForEach(actions) { button in
						Button(action: {
							Task {
								isEnabled = false
								resetPosition()
								try? await Task.sleep(for: .seconds(0.25))
								button.action()
								try? await Task.sleep(for: .seconds(0.1))
								isEnabled = true
							}
						}, label: {
							Image(systemName: button.icon)
								.font(button.iconFont)
								.foregroundStyle(button.iconTint)
								.frame(width: button.iconWidth)
								.frame(maxHeight: .infinity)
								.contentShape(.rect)
						})
						.buttonStyle(.plain)
						.background(button.tint)
					}
				}
			}
	}

	func scrollOffset(_ proxy: GeometryProxy) -> CGFloat {
		let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
		return direction == .trailing ? (minX > 0 ? -minX : 0) : (minX < 0 ? -minX : 0)
	}
}

struct Action: Identifiable {
	private(set) var id: UUID = .init()
	var tint: Color
	var icon: String
	var iconWidth: CGFloat = 100
	var iconFont: Font = .title
	var iconTint: Color = .white
	var isEnabled: Bool = true
	var action: () -> Void
}

@resultBuilder
struct ActionBuilder {
	static func buildBlock(_ components: Action...) -> [Action] {
		components
	}
}

#Preview {
	SwipeAction {
		Text("some")
	} actions: {
		Action(tint: .red, icon: "trash") {

		}
	}
}
