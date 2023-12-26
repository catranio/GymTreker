import Foundation
import SwiftUI

struct ExerciseCellModel: Identifiable, Codable {
	private enum CodingKeys: String, CodingKey { case title, tags, weight, image }

	enum Weight: String, Codable {
		case free
		case double
		case own
		case loss
	}

	var id = UUID()
	var title: String
	var tags: [String]
	var weight: Weight
	var image: String?

	init(title: String, tags: [String], weight: Weight, image: String? = nil) {
		self.title = title
		self.tags = tags
		self.weight = weight
		self.image = image
	}
}
