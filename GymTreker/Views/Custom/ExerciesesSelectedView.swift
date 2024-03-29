import SwiftUI

struct SetsEditView: View {
	@Binding var type: ExerciseModel.Weight
	@Binding var sets: [ExerciseModel.Set]
	@State private var numberFormatter: NumberFormatter = {
		var formatter = NumberFormatter()
		formatter.zeroSymbol = ""
		formatter.numberStyle = .decimal
		return formatter
	}()
	@State private var draggingSetItem: ExerciseModel.Set?

	var body: some View {
		VStack {
			ForEach($sets) { $set in
				if let idx = sets.firstIndex(of: set) {
					SwipeView {
						setEditView(index: idx + 1, weight: $set.weight, repeates: $set.reps)
					} trailingActions: { _ in
						SwipeAction(systemImage: "trash", backgroundColor: .red) {
							withAnimation(.snappy) {
								sets.removeAll { $0 == set }
							}
						}
						.allowSwipeToTrigger(true)
						.font(.title3.weight(.medium))
						.foregroundColor(.white)
					}
					.swipeActionsStyle(.cascade)
					.swipeActionCornerRadius(0)
					.swipeActionsMaskCornerRadius(0)
					.padding(.vertical, 6)
					.padding(.horizontal)
					.onDrag {
						draggingSetItem = set
						return NSItemProvider(contentsOf: URL(string: "\(set.id)"))!
					}
					.onDrop(of: [.item],
							delegate: DropViewDelegate(item: set, items: $sets, draggedItem: $draggingSetItem))
				}
			}
			Button("Add") {
				withAnimation(.snappy) {
					sets.append(.init(reps: sets.last?.reps ?? 0, weight: sets.last?.weight ?? 0))
				}
			}
			.buttonStyle(.secondary, font: .title3)
			.padding(0)
		}
		.background(Color.App.background)
	}

	func move(from source: IndexSet, to destination: Int) {
		sets.move(fromOffsets: source, toOffset: destination)
	}

	@ViewBuilder
	func setEditView(index: Int, weight: Binding<Double>, repeates: Binding<Int>) -> some View {
		HStack {
			Text("\(index)")
				.frame(width: 20, alignment: .leading)
			if type == .free || type == .double || type == .loss {
				TextField("0.0", value: weight, formatter: numberFormatter)
					.keyboardType(.decimalPad)
					.padding(6)
					.background(Color(UIColor.systemGray3))
					.clipShape(.rect(cornerRadius: 6))
					.multilineTextAlignment(.center)
				if type == .double {
					Text("x2")
					Text("kg")
				} else if type == .loss {
					Text("support")
					Text("kg")
				} else {
					Text("kg")
				}

			}
			TextField("0", value: repeates, formatter: numberFormatter)
				.keyboardType(.numberPad)
				.padding(6)
				.background(Color(UIColor.systemGray3))
				.clipShape(.rect(cornerRadius: 6))
				.multilineTextAlignment(.center)
			Text("reps")
		}
	}
}

#Preview {
	VStack {
		SetsEditView(type: .constant(.free), sets: .constant([
			.init(reps: 0, weight: 0),
			.init(reps: 0, weight: 0),
			.init(reps: 0, weight: 0)]))

		SetsEditView(type: .constant(.double), sets: .constant([
			.init(reps: 0, weight: 0),
			.init(reps: 0, weight: 0),
			.init(reps: 0, weight: 0)]))

		SetsEditView(type: .constant(.loss), sets: .constant([
			.init(reps: 0, weight: 0),
			.init(reps: 0, weight: 0),
			.init(reps: 0, weight: 0)]))

		SetsEditView(type: .constant(.own), sets: .constant([
			.init(reps: 0, weight: 0),
			.init(reps: 0, weight: 0),
			.init(reps: 0, weight: 0)]))
	}
}
