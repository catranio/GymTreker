import SwiftUI

struct ExercieseEditDropViewDelegate: DropDelegate {
	let item: ExerciseModel
	@Binding var items: [ExerciseModel]
	@Binding var draggedItem: ExerciseModel?

	func performDrop(info: DropInfo) -> Bool {
		true
	}

	func dropEntered(info: DropInfo) {
		guard let draggedItem = self.draggedItem else {
			return
		}

		if draggedItem != item {
			let from = items.firstIndex(of: draggedItem)!
			let to = items.firstIndex(of: item)!
			withAnimation(.default) {
				self.items.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? to + 1 : to)
			}
		}
	}
}

struct CreateWorkoutView: View {
	@State var title = ""
	@Binding var workouts: [WorkoutModel]

	@State private var isPresentExercieseList = false
	@State private var exercises: [ExerciseModel] = []
	@State private var draggedExerciese: ExerciseModel?
	@State private var isExistByTitle: Bool = false
	@State private var isEditMode: Bool = false

	@Environment(\.presentationMode) var presentationMode

	var body: some View {
		NavigationView {
			VStack {
				if exercises.isEmpty {
					VStack {
						Spacer()
						Image("Dumbbell")
							.resizable()
							.frame(width: 180, height: 120)
							.opacity(0.4)

						Spacer()

						Button("Add exercises") {
							isPresentExercieseList = true
						}
						.buttonStyle(exercises.isEmpty ? .primary : .secondary, font: .title2)
						.padding()
						.sheet(isPresented: $isPresentExercieseList) {
							ExercisesListView(selectedExercises: $exercises)
						}
					}
				} else {
					ScrollView {
						VStack {
							ForEach($exercises) { $exercise in
								ExerciesEditView(exercise: $exercise)
									.onDrag {
										draggedExerciese = exercise
										return NSItemProvider(contentsOf: URL(string: "\(exercise.id)"))!
									}
									.onDrop(of: [.item], delegate: ExercieseEditDropViewDelegate(item: exercise, items: $exercises, draggedItem: $draggedExerciese))
									.padding(.horizontal)
									.padding(.top)
							}
							Rectangle()
								.foregroundStyle(.clear)
								.frame(height: 85)
						}
					}
					.overlay(alignment: .bottomTrailing) {
						Button {
							isPresentExercieseList = true
						} label: {
							Image(systemName: "plus")
						}
						.foregroundStyle(.white)
						.buttonStyle(.plain)
						.frame(width: 65, height: 65)
						.font(.system(size: 36))
						.fontWeight(.bold)
						.background(
							LinearGradient(colors: [
								Color.App.blue,
								Color.App.purple
							], startPoint: .leading, endPoint: .trailing))
						.clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
						.padding()
						.sheet(isPresented: $isPresentExercieseList) {
							ExercisesListView(selectedExercises: $exercises)
						}
					}
				}
				if !exercises.isEmpty {
					Button("Save") {
						if !workouts.contains(where: { $0.title == title }) || isEditMode {
							workouts.removeAll { $0.title == title }
							workouts.append(.init(title: title, exercises: exercises))
							presentationMode.wrappedValue.dismiss()
						} else {
							isExistByTitle = true
						}
					}
					.buttonStyle(.primary, font: .title2)
					.alert("Exerciese with title \"\(title)\" already exist. Rewrite it?", isPresented: $isExistByTitle) {

						Button("Rewrite", role: .destructive) {
							isExistByTitle = false
							workouts.removeAll { $0.title == title }
							workouts.append(.init(title: title, exercises: exercises))
							presentationMode.wrappedValue.dismiss()
						}

						Button("Cancel", role: .cancel) { isExistByTitle = false }
					}
					.padding(.horizontal)
					.padding(.bottom)
				}
			}
			.navigationTitle($title)
			.navigationBarTitleDisplayMode(.inline)
			.onTapGesture {
				UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
			}
			.onAppear {
				if title.isEmpty {
					title = "Workout"
					exercises = []
				} else {
					exercises = workouts.first { $0.title == title }?.exercises ?? []
					isEditMode = true
				}
			}
			.onDisappear {
				title = ""
				exercises = []
				isEditMode = false
			}
		}
	}
}

#Preview {
	CreateWorkoutView(workouts: .constant([]))
}
