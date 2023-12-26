import SwiftUI

struct CustomView: View {
	var body: some View {
		NavigationView {
			VStack {
				Spacer()
				CreateNewWorkoutView()
				Spacer()
			}
		}
	}
}

#Preview {
	CustomView()
}
