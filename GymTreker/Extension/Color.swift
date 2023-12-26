import Foundation

import SwiftUI

extension Color {
	public init?(hex: String) {
			let red, green, blue, alpha: CGFloat

			if hex.hasPrefix("#") {
				let start = hex.index(hex.startIndex, offsetBy: 1)
				let hexColor = String(hex[start...])

				if hexColor.count == 8 {
					let scanner = Scanner(string: hexColor)
					var hexNumber: UInt64 = 0

					if scanner.scanHexInt64(&hexNumber) {
						red = CGFloat((hexNumber & 0xff000000) >> 24) / 255
						green = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
						blue = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
						alpha = CGFloat(hexNumber & 0x000000ff) / 255

						self.init(red: red, green: green, blue: blue, opacity: alpha)
						return
					}
				}
			}

			return nil
		}

	struct App {
		public static let background = Color(UIColor.systemGray5)
		public static let selected = Color("selected")
		public static let blue = Color(red: 75 / 255, green: 89 / 255, blue: 255 / 255)
		public static let purple = Color(red: 171 / 255, green: 47 / 255, blue: 255 / 255)
	}
}
