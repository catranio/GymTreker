//
//  SwiftUIView.swift
//  GymTreker
//
//  Created by Петр Яскевич on 06.01.2024.
//

import SwiftUI

struct SwiftUIView: View {
	@GestureState private var isTapped = false

	var body: some View {
		SwipeView {
			VStack {
				HStack {
					Text("Some title")
						.font(.title)
					Spacer()
				}
				.contentShape(Rectangle())
				.gesture(DragGesture(minimumDistance: 0).updating($isTapped) { _, isTapped, _ in isTapped = true })
				SwipeViewGroup {
					SwipeView {
						cell(.blue)
					} trailingActions: { _ in
						SwipeAction(systemImage: "trash", backgroundColor: .red) { }
						.allowSwipeToTrigger(true)
						.font(.title3.weight(.medium))
						.foregroundColor(.white)
					}
					.swipeActionCornerRadius(0)

					SwipeView {
						cell(.purple)
					} trailingActions: { _ in
						SwipeAction(systemImage: "trash", backgroundColor: .red) { }
						.allowSwipeToTrigger(true)
						.font(.title3.weight(.medium))
						.foregroundColor(.white)
					}
					.swipeActionsStyle(.cascade)
					.swipeActionsVisibleStartPoint(0)
					.swipeActionsVisibleEndPoint(0)
					.swipeActionCornerRadius(15)
					.swipeActionsMaskCornerRadius(0)

					SwipeView {
						cell(.brown)
					} trailingActions: { _ in
						SwipeAction(systemImage: "trash", backgroundColor: .red) { }
						.allowSwipeToTrigger(true)
						.font(.title3.weight(.medium))
						.foregroundColor(.white)
					}
					.swipeActionsStyle(.mask)
				}
			}
			.padding()
			.background(Color.App.background, in: .rect(cornerRadius: 15))
			.padding()
		} trailingActions: { _ in
			SwipeAction(systemImage: "trash", backgroundColor: .red) { }
			.allowSwipeToTrigger(true)
			.font(.title3.weight(.medium))
			.foregroundColor(.white)
		}
		.swipeActionsStyle(.mask)
		.swipeEnabled(isTapped)
	}

	@ViewBuilder
	func cell(_ color: Color) -> some View {
		HStack {
			Circle()
				.frame(width: 75, height: 75)

			VStack {
				Rectangle()
					.frame(width: 80, height: 6)
				Rectangle()
					.frame(width: 60, height: 6)
			}
			Spacer()
		}
		.padding()
		.background(color, in: .rect(cornerRadius: 15))
	}
}

#Preview {
	SwiftUIView()
}
