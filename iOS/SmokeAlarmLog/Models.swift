import Foundation

struct DetectorEntry: Identifiable, Codable, Equatable {
    let id: UUID
    var location: String
    var lastTested: String
    var batteryType: String
    var notes: String
    var createdAt: Date

    init(id: UUID = UUID(), location: String = "", lastTested: String = "", batteryType: String = "", notes: String = "", createdAt: Date = Date()) {
        self.id = id
        self.location = location
        self.lastTested = lastTested
        self.batteryType = batteryType
        self.notes = notes
        self.createdAt = createdAt
    }
}
