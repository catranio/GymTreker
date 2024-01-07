import SwiftUI

struct ExerciesEditView: View {
	@Binding var exercise: ExerciseModel
	@Binding var exercises: [ExerciseModel]
	@State private var isOpened: Bool = true
	@GestureState private var isTappedHeader: Bool = false

	var body: some View {
		SwipeView {
			LazyVStack(spacing: 0) {
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
				.gesture(DragGesture(minimumDistance: 0)
					.updating($isTappedHeader) { _, isTappedHeader, _ in isTappedHeader = true }
					.onEnded({ _ in
						withAnimation {
							isOpened.toggle()
						}
					})
				)

				SetsEditView(type: $exercise.weight, sets: $exercise.sets)
					.frame(height: isOpened ? nil : 0, alignment: .top)
					.padding(.top, isOpened ? nil : 0)
					.clipped()
			}
			.padding()
			.frame(maxWidth: .infinity)
			.background(Color.App.background)
			.clipShape(.rect(cornerRadius: 15))
		} trailingActions: { _ in
			SwipeAction(systemImage: "trash", backgroundColor: .red) {
				withAnimation(.snappy) {
					exercises.removeAll { $0 == exercise }
				}
			}
			.allowSwipeToTrigger(true)
			.font(.title3.weight(.medium))
			.foregroundColor(.white)
		}
		.swipeActionsStyle(.cascade)
		.swipeActionCornerRadius(15)
		.swipeActionsMaskCornerRadius(0)
		.swipeEnabled(isTappedHeader)
	}
}

#Preview {
	ExerciesEditView(exercise: .constant(
		ExerciseModel(title: "Жим лежа", tags: ["Грудь", "Спина"], weight: .free, sets: [.init(reps: 0, weight: 0.0)])),
					 exercises: .constant([])
	)
}
