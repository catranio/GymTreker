import SwiftUI

enum Tab: String, CaseIterable, Identifiable {
	case report
	case workout
	case custom

	var id: Self { self }
}

struct MainView: View {
	@AppStorage("workouts") var workouts: [WorkoutModel] = []
	@State private var tab: Tab = .workout

	private let tabColor = Color.App.purple

	var body: some View {
		TabView(selection: $tab) {
			Color(.lightGray)
				.tabItem {
					Label("Report", systemImage: "chart.bar.fill")
				}
				.tag(Tab.report)
			Color(.lightGray)
				.tabItem {
					Label("Workout", systemImage: "dumbbell.fill")
				}
				.tag(Tab.workout)
			CustomView()
				.tabItem {
					Label("Castom", systemImage: "pencil.and.list.clipboard")
				}
				.tag(Tab.custom)
		}
		.accentColor(Color.App.blue)
		.onAppear {
			tab = workouts.isEmpty ? .custom : .workout
		}
	}
}

#Preview {
	MainView()
}
