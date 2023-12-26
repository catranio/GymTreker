import SwiftUI

struct WorkoutsEditDropViewDelegate: DropDelegate {
	let item: WorkoutModel
	@Binding var items: [WorkoutModel]
	@Binding var draggedItem: WorkoutModel?

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

struct CreateNewWorkoutView: View {
	@AppStorage("workouts") var workouts: [WorkoutModel] = []
	@State var draggedWorkout: WorkoutModel?

	@State private var isPresentNewWorkout = false
	@State private var selectEditWorkoutTitle: String?
	@State private var isPresentEditWorkout = false

	var body: some View {
		VStack {
			if workouts.isEmpty {
				Image("Dumbbell")
					.resizable()
					.frame(width: 180, height: 120)
				Text("Create your first custom workout")
					.font(.largeTitle)
					.fontWeight(.bold)
					.padding()
					.multilineTextAlignment(.center)
				Text("Do only the exercises you need to do")
					.multilineTextAlignment(.center)
					.padding(.horizontal)
				Button("Create") {
					isPresentNewWorkout.toggle()
				}
				.buttonStyle(.primary)
				.padding()
				.sheet(isPresented: $isPresentNewWorkout) {
					CreateWorkoutView(workouts: $workouts)
				}
				.padding(.horizontal)
				.padding(.top)
			} else {
				VStack {
					ScrollView {
						ForEach(workouts) { workout in
								Button {
									selectEditWorkoutTitle = workout.title
									isPresentEditWorkout = true
								} label: {
									SwipeAction(cornerRadius: 15) {
										HStack {
											Image("Dumbbell")
												.resizable()
												.frame(width: 75 * 0.7, height: 50 * 0.7)
											VStack(alignment: .leading) {
												Text(workout.title)
													.font(.title3)
													.fontWeight(.bold)
													.frame(maxWidth: .infinity, alignment: .leading)
													.multilineTextAlignment(.leading)
													.lineLimit(2)
													.foregroundColor(Color(UIColor.label))
												ForEach(workout.exercises) { exercise in
													Text("\u{2022} " + exercise.title)
														.frame(maxWidth: .infinity, alignment: .leading)
														.lineLimit(1)
														.foregroundColor(Color(UIColor.secondaryLabel))
												}
											}
											.padding(.horizontal)
											.frame(maxWidth: .infinity)
										}
										.padding()
										.background(Color.App.background)
										.clipShape(.rect(cornerRadius: 0))
										.frame(maxWidth: .infinity)
									} actions: {
										Action(tint: .red, icon: "trash") {
											withAnimation(.snappy) {
												workouts.removeAll { $0 == workout }
											}
										}
									}
									.padding(.vertical, 6)
									.padding(.horizontal)
								}
								.onDrag {
									draggedWorkout = workout
									return NSItemProvider(contentsOf: URL(string: "\(workout.id)"))!
								}
								.onDrop(of: [.item], delegate:
											WorkoutsEditDropViewDelegate(item: workout, items: $workouts, draggedItem: $draggedWorkout))
								.sheet(isPresented: $isPresentEditWorkout) {
									if selectEditWorkoutTitle != nil {
										CreateWorkoutView(title: selectEditWorkoutTitle!, workouts: $workouts)
									}
								}
						}
					}
					Spacer()
					Button("Create") {
						isPresentNewWorkout.toggle()
					}
					.buttonStyle(.primary)
					.padding()
					.sheet(isPresented: $isPresentNewWorkout) {
						CreateWorkoutView(workouts: $workouts)
					}
					.padding(.horizontal)
					.padding(.top)
				}
			}
		}
	}
}

#Preview {
	CreateNewWorkoutView()
}
