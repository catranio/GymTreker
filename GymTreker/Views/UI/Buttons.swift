import SwiftUI

enum UiButtonStyle {
	case primary, secondary
}

struct UiMainButtonStyle: ButtonStyle {
	let font: Font

	init(_ font: Font = .title) {
		self.font = font
	}

	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.font(font)
			.fontWeight(.bold)
			.textCase(.uppercase)
			.frame(maxWidth: .infinity)
			.padding()
			.background(
				LinearGradient(colors: [
					Color.App.blue,
					Color.App.purple
				], startPoint: .leading, endPoint: .trailing))
			.foregroundStyle(.white)
			.clipShape(.rect(cornerRadius: 15))
			.scaleEffect(configuration.isPressed ? 0.95 : 1)
			.opacity(configuration.isPressed ? 0.8 : 1)
			.animation(.linear(duration: 0.2).delay(0), value: configuration.isPressed)
	}
}

struct UiSecondaryButtonStyle: ButtonStyle {
	let font: Font

	init(_ font: Font = .title) {
		self.font = font
	}

	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.font(font)
			.fontWeight(.bold)
			.frame(maxWidth: .infinity)
			.foregroundStyle(Color.App.blue)
			.opacity(configuration.isPressed ? 0.8 : 1)
			.animation(.linear(duration: 0.01).speed(0), value: configuration.isPressed)
	}
}
