import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published private(set) var entries: [Entry] = []
    @Published var remindersEnabled: Bool = false

    /// Free-tier cap. Deliberately set above the seed-data count so a fresh
    /// install never sees the paywall immediately.
    static let freeLimit = 30

    private let fileName = "wakeword_entries.json"

    private var fileURL: URL {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent(fileName)
    }

    init() {
        load()
        if entries.isEmpty {
            seed()
            save()
        }
    }

    var isAtLimit: Bool {
        entries.count >= Self.freeLimit
    }

    @discardableResult
    func add(_ item: Entry) -> Bool {
        guard !isAtLimit else { return false }
        entries.insert(item, at: 0)
        save()
        return true
    }

    func update(_ item: Entry) {
        guard let idx = entries.firstIndex(where: { $0.id == item.id }) else { return }
        entries[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: Entry) {
        entries.removeAll(where: { $0.id == item.id })
        save()
    }

    private func seed() {
        entries = [
            Entry(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, text: "Sample intention 1"),\nEntry(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, text: "Sample intention 2"),\nEntry(date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, text: "Sample intention 3")
        ]
    }
    private func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        if let decoded = try? JSONDecoder().decode([Entry].self, from: data) {
            entries = decoded
        }
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
