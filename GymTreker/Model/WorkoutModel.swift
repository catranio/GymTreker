import Foundation
import SwiftUI

struct WorkoutModel: Codable, Equatable, Identifiable, Transferable {
	static var transferRepresentation: some TransferRepresentation {
		CodableRepresentation(for: WorkoutModel.self, contentType: .item)
	}

	private (set) var id = UUID()
	var title: String
	var exercises: [ExerciseModel]
}
