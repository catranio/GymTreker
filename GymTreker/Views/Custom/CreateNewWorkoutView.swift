import SwiftUI

struct CreateNewWorkoutView: View {
	@AppStorage("workouts") var saveWorkouts: [WorkoutModel] = []
	@State var workouts: [WorkoutModel] = [] { didSet { saveWorkouts = workouts }}
	@State var draggingWorkoutItem: WorkoutModel?

	@State private var isPresentNewWorkout = false
	@State private var selectedWorout: WorkoutModel?

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
								selectedWorout = workout
							} label: {
								SwipeView {
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
									.clipShape(.rect(cornerRadius: 15))
									.frame(maxWidth: .infinity)
								} trailingActions: { _ in
									SwipeAction(systemImage: "trash", backgroundColor: .red) {
										withAnimation(.snappy) {
											workouts.removeAll { $0 == workout }
										}
									}
									.allowSwipeToTrigger(true)
									.font(.title3.weight(.medium))
									.foregroundColor(.white)
								}
								.swipeActionsStyle(.cascade)
								.swipeActionCornerRadius(15)
								.swipeActionsMaskCornerRadius(0)
								.padding(.vertical, 6)
								.padding(.horizontal)
							}
							.onDrag {
								draggingWorkoutItem = workout
								return NSItemProvider(contentsOf: URL(string: "\(workout.id)"))!
							}
							.onDrop(of: [.workout],
									delegate: DropViewDelegate(item: workout, items: $workouts, draggedItem: $draggingWorkoutItem))
							.sheet(item: $selectedWorout) { workout in
								CreateWorkoutView(title: workout.title, workouts: $workouts)
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
		.onAppear {
			workouts = saveWorkouts
		}
	}
}

#Preview {
	CreateNewWorkoutView()
}
