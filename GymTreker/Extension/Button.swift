import SwiftUI

extension Button {
	@ViewBuilder
	func buttonStyle(_ style: UiButtonStyle, font: Font = .title) -> some View {
		switch style {
		case .primary:
			buttonStyle(UiMainButtonStyle(font))
		case .secondary:
			buttonStyle(UiSecondaryButtonStyle(font))
		}
	}
}
