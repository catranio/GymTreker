import SwiftUI

struct SetsEditView: View {
	@Binding var type: ExerciseModel.Weight
	@Binding var sets: [ExerciseModel.Set]
	private let rowHeight: CGFloat = 40
	@State private var numberFormatter: NumberFormatter = {
		var formatter = NumberFormatter()
		formatter.zeroSymbol = ""
		formatter.numberStyle = .decimal
		return formatter
	}()

    var body: some View {
		VStack {
			List {
				ForEach($sets) { $set in
					if let idx = sets.firstIndex(of: set) {
						setEditView(index: idx + 1, weight: $set.weight, repeates: $set.reps)
							.listRowSeparator(.hidden)
							.listRowBackground(Color.App.background)
							.listRowInsets(EdgeInsets())
							.frame(maxHeight: rowHeight)
					}
				}
				.onDelete { indexSet in
					withAnimation(.snappy) {
						sets.remove(atOffsets: indexSet)
					}
				}
				.onMove { indices, newOffset in
					sets.move(fromOffsets: indices, toOffset: newOffset)
				}
			}
			.background(Color.App.background)
			.scrollContentBackground(.hidden)
			.listStyle(.inset)
			.frame(height: CGFloat(sets.count) * rowHeight)
			.scrollDisabled(true)
			.environment(\.defaultMinListRowHeight, rowHeight)

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
