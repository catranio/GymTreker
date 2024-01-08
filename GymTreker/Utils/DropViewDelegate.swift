import SwiftUI

struct DropOutsideDelegate<Item: Equatable>: DropDelegate {
	@Binding var current: Item?

	func performDrop(info: DropInfo) -> Bool {
		current = nil
		return true
	}
}

struct DropViewDelegate<Item: Equatable>: DropDelegate {
	let item: Item
	@Binding var items: [Item]
	@Binding var draggedItem: Item?

	func performDrop(info: DropInfo) -> Bool {
		self.draggedItem = nil
		return true
	}

	func dropEntered(info: DropInfo) {
		guard let draggedItem = self.draggedItem else { return }

		if draggedItem != item, let from = items.firstIndex(of: draggedItem),
		   let to = items.firstIndex(of: item) {
				withAnimation(.default) {
					self.items.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? to + 1 : to)
				}
		}
	}

	func dropUpdated(info: DropInfo) -> DropProposal? {
		DropProposal(operation: .move)
	}
}
