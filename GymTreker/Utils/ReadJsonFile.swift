import Foundation

class ReadJsonFile<T: Decodable>: ObservableObject {
	@Published var data = [T]()
	private var path: String

	init(path: String) {
		self.path = path
		loadData()
	}

	private func loadData() {
		guard let url = Bundle.main.url(forResource: path, withExtension: "json") else { return }

		do {
			let jsonData = try Data(contentsOf: url)
			let decoded = try JSONDecoder().decode([T].self, from: jsonData)
			self.data = decoded
		} catch {
			print(error)
		}
	}
}
