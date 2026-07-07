import SwiftUI

/// slate-gray night tones with an alarm-red accent
enum Theme {
    static let primary = Color(red: 0.227, green: 0.247, blue: 0.345)
    static let accent = Color(red: 0.949, green: 0.329, blue: 0.357)
    static let background = Color(.systemBackground)
    static let cardBackground = Color(.secondarySystemBackground)
    static let titleFont = Font.system(.largeTitle, design: .rounded).weight(.bold)
    static let headingFont = Font.system(.headline, design: .rounded).weight(.semibold)
    static let bodyFont = Font.system(.body, design: .rounded)
}
