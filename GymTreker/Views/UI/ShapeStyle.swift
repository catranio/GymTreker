import SwiftUI

struct CardShapeStyle: ShapeStyle {
	func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
		Rectangle()
			.fill(Color.App.background)
	}
}

#Preview {
	VStack {
		Text("hellow")
			.background(CardShapeStyle())
	}
}
