import Foundation

struct WorkoutModel: Codable, Equatable, Identifiable {
	private (set) var id = UUID()
	var title: String
	var exercises: [ExerciseModel]
}
