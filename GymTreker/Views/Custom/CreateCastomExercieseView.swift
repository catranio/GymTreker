import SwiftUI

struct CreateCastomExercieseView: View {
	@State private var title: String = ""
	@State private var tag: String = ""
	@State private var tags: [String] = []

	var body: some View {
		NavigationView {
			ScrollView {
				VStack(alignment: .leading) {
					Text("Title")
					TextField("title", text: $title, prompt: Text("Title"))
						.padding(.horizontal)
						.padding(.vertical, 10)
						.background(Color(UIColor.systemGray3))
						.clipShape(.rect(cornerRadius: 6))

					Text("Added tags")
						.padding(.top)
					HStack {
						TextField("tag", text: $tag, prompt: Text("Tag"))
							.padding(.horizontal)
							.padding(.vertical, 10)
							.background(Color(UIColor.systemGray3))
							.clipShape(.rect(cornerRadius: 6))

						Button {
							withAnimation(.snappy) {
								if !tag.isEmpty {
									tags.append(tag)
								}
							}
							tag = ""
						} label: {
							Text("Add")
								.foregroundStyle(.white)
						}
						.padding(.horizontal)
						.padding(.vertical, 10)
						.background(Color.App.blue)
						.clipShape(.rect(cornerRadius: 6))
					}

					ChipsStack {
						ForEach(tags, id: \.self) { tag in
							Text(tag)
								.padding(.horizontal)
								.padding(.vertical, 10)
								.background(Color(UIColor.systemGray3))
								.clipShape(.rect(cornerRadius: 6))
								.transition(AnyTransition.scale)
								.onTapGesture {
									withAnimation(.snappy) {
										tags.removeAll(where: { $0 == tag })
									}
								}
						}
					}
					.padding(.top)

					Spacer()
				}
			}
			.navigationTitle("New exerciese")
			.padding()
			.onTapBackground(enabled: true) {
//				UIApplication.shared.endEditing()
			}
		}
	}
}

#Preview {
	CreateCastomExercieseView()
}
