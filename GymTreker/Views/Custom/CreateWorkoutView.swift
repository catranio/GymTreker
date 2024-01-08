import SwiftUI

struct CreateWorkoutView: View, KeyboardReadable {
	@State var title = ""
	@Binding var workouts: [WorkoutModel]

	@State private var isPresentExercieseList = false
	@State private var exercises: [ExerciseModel] = []
	@State private var draggingExercieseItem: ExerciseModel?
	@State private var isExistByTitle: Bool = false
	@State private var isEditMode: Bool = false
	@State private var isKeyboardVisible: Bool = false
	@GestureState private var isPrepareToDelete = false

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
						LazyVStack(spacing: 20) {
							ForEach($exercises) { $exercise in
								ExerciesEditView(exercise: $exercise, exercises: $exercises)
									.onDrag {
										draggingExercieseItem = exercise
										return NSItemProvider(contentsOf: URL(string: "\(exercise.id)"))!
									}
									.onDrop(of: [.exerciese],
											delegate: DropViewDelegate(item: exercise, items: $exercises, draggedItem: $draggingExercieseItem))
									.padding(.horizontal)
							}
							Rectangle()
								.foregroundStyle(.clear)
								.frame(height: 85)
						}
					}
					.overlay(alignment: .bottomTrailing) {
						if !isKeyboardVisible {
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
				}
				if !exercises.isEmpty && !isKeyboardVisible {
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
			.onReceive(keyboardPublisher) { newIsKeyboardVisible in
				withAnimation(.snappy) {
					isKeyboardVisible = newIsKeyboardVisible
				}
			}
		}
	}
}

#Preview {
	CreateWorkoutView(workouts: .constant([]))
}
