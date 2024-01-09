import Foundation

struct ExerciseModel: Identifiable, Codable, Equatable {
	private enum CodingKeys: String, CodingKey {
		case title, tags, weight, sets
	}

	struct Set: Identifiable, Codable, Equatable {
		private (set) var id = UUID()
		var reps: Int
		var weight: Double
	}

	enum Weight: String, Codable, CaseIterable {
		case free
		case double
		case own
		case loss
	}

	private (set) var id = UUID()
	var title: String
	var tags: [String]
	var weight: Weight
	var sets: [Set]

	init(title: String, tags: [String], weight: Weight, sets: [Set] = [Set(reps: 0, weight: 0)]) {
		self.title = title
		self.tags = tags
		self.weight = weight
		self.sets = sets
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		title = try container.decode(String.self, forKey: .title)
		tags = try container.decode([String].self, forKey: .tags)
		weight = try container.decode(Weight.self, forKey: .weight)
		do { sets = try container.decode([Set].self, forKey: .sets) } catch { sets = [Set(reps: 0, weight: 0)] }
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(title, forKey: .title)
		try container.encode(tags, forKey: .tags)
		try container.encode(weight, forKey: .weight)
		try container.encode(sets, forKey: .sets)
	}
}
