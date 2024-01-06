import SwiftUI

struct ExerciesEditView: View {
	@Binding var exercise: ExerciseModel

	@State private var isOpened: Bool = true

	var body: some View {
		LazyVStack(spacing: 0) {
			Button {
				withAnimation {
					isOpened.toggle()
				}
			} label: {
				HStack {
					Text(exercise.title)
						.font(.headline)
						.fontWeight(.bold)
						.frame(maxWidth: .infinity, alignment: .leading)
						.multilineTextAlignment(.leading)
						.lineLimit(2)
						.foregroundColor(Color(UIColor.label))
					Spacer()
					Image(systemName: "chevron.down")
						.rotationEffect(isOpened ? .degrees(180) : .degrees(0))
						.font(.headline)
						.fontWeight(.bold)
				}
				.contentShape(Rectangle())
			}
			.buttonStyle(.plain)

			SetsEditView(type: $exercise.weight, sets: $exercise.sets)
				.frame(height: isOpened ? nil : 0, alignment: .top)
				.padding(.top, isOpened ? nil : 0)
				.clipped()
		}
		.padding()
		.frame(maxWidth: .infinity)
		.background(Color.App.background)
		.clipShape(.rect(cornerRadius: 15))
	}
}

#Preview {
	ExerciesEditView(exercise: .constant(
		ExerciseModel(title: "Жим лежа", tags: ["Грудь", "Спина"], weight: .free, sets: [.init(reps: 0, weight: 0.0)]
					 )))
}
