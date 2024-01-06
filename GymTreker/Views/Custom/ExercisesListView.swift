import SwiftUI

struct ExercisesListView: View {
	@Binding var selectedExercises: [ExerciseModel]
	@State var readJsonExercises = ReadJsonFile<ExerciseModel>(path: "exercises").data
	@State private var searchText = ""
	@State private var selection = Set<UUID>()
	@Environment(\.presentationMode) var presentationMode

	var body: some View {
		NavigationView {
			VStack {
				ScrollView {
					VStack {
						ForEach(readJsonExercises) { exercise in
							if isFindSerachText(exercise) {
								Button {
									if selection.contains(exercise.id) {
										selection.remove(exercise.id)
									} else {
										selection.insert(exercise.id)
									}
								} label: {
									cellView(exercise)
								}
								.buttonStyle(.plain)
							}
						}
					}
					.onAppear {
						for exercise in selectedExercises {
							selection.insert(exercise.id)
						}
					}
				}
				.searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic))
				.onAppear {
					UISearchBar.appearance().tintColor = UIColor(Color.App.blue)
				}

				Button("Add exercieses") {
					let filterExerciese = readJsonExercises.filter { selection.contains($0.id) }
					for item in filterExerciese where !selectedExercises.contains(where: { $0.title == item.title }) {
						selectedExercises.append(item)
					}
					for item in selectedExercises where !filterExerciese.contains(where: { $0.title == item.title }) {
						selectedExercises.removeAll { $0.id == item.id }
					}
					presentationMode.wrappedValue.dismiss()
				}
				.buttonStyle(UiMainButtonStyle(.title2))
				.padding()
			}
			.navigationTitle("Exercises")
			.navigationBarTitleDisplayMode(.automatic)
		}
	}

	@ViewBuilder
	func cellView(_ exercise: ExerciseModel) -> some View {
		HStack {
			Image("Dumbbell")
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: 65)

			VStack {
				Text(exercise.title)
						.font(.title3)
						.fontWeight(.bold)
						.frame(maxWidth: .infinity, alignment: .leading)
						.multilineTextAlignment(.leading)
						.lineLimit(2)
						.foregroundColor(Color(UIColor.label))
					Text(exercise.tags.map { String($0).capitalized }.joined(separator: ", "))
						.frame(maxWidth: .infinity, alignment: .leading)
						.lineLimit(2)
						.foregroundColor(Color(UIColor.secondaryLabel))
			}
			Spacer()
		}
		.padding()
		.background(selection.contains(exercise.id) ? Color.App.selected : Color.App.background)
		.clipShape(.rect(cornerRadius: 15))
		.frame(maxWidth: .infinity)
		.padding(.vertical, 6)
		.padding(.horizontal)
		.animation(.linear(duration: 0.1), value: selection.contains(exercise.id))
	}

	func isFindSerachText(_ exercise: ExerciseModel) -> Bool {
		if searchText.isEmpty || exercise.title.lowercased().contains(searchText.lowercased()) {
			return true
		}

		for tag in exercise.tags where tag.lowercased().contains(searchText.lowercased()) {
			return true
		}

		return false
	}
}

#Preview {
	ExercisesListView(selectedExercises: .constant([]))
}
