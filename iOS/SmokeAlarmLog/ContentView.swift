import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showingAdd = false
    @State private var showingSettings = false
    @State private var editingEntry: DetectorEntry?

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.entries) { entry in
                    Button {
                        editingEntry = entry
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(entry.location.isEmpty ? "Untitled" : entry.location)
                                .font(Theme.headingFont)
                                .foregroundStyle(.primary)
                            Text(entry.lastTested)
                                .font(Theme.bodyFont)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .accessibilityIdentifier("entryRow_\(entry.id)")
                }
                .onDelete { offsets in
                    store.delete(at: offsets)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Smoke Alarm Log")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAdd = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .accessibilityIdentifier("addEntryButton")
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddEntrySheet(isPresented: $showingAdd)
            }
            .sheet(item: $editingEntry) { entry in
                AddEntrySheet(isPresented: .constant(true), editing: entry)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .sheet(isPresented: $store.showPaywall) {
                PaywallView()
            }
            .overlay {
                if store.entries.isEmpty {
                    ContentUnavailableView("No detectors yet", systemImage: "tray", description: Text("Tap + to add your first detector."))
                }
            }
        }
        .tint(Theme.primary)
    }
}

struct AddEntrySheet: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) private var dismiss
    @Binding var isPresented: Bool
    var editing: DetectorEntry?

    @State private var location: String = ""
    @State private var lastTested: String = ""
    @State private var batteryType: String = ""
    @State private var notes: String = ""

    init(isPresented: Binding<Bool>, editing: DetectorEntry? = nil) {
        self._isPresented = isPresented
        self.editing = editing
        if let e = editing { _location = State(initialValue: e.location) }
        if let e = editing { _lastTested = State(initialValue: e.lastTested) }
        if let e = editing { _batteryType = State(initialValue: e.batteryType) }
        if let e = editing { _notes = State(initialValue: e.notes) }
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("Location", text: $location)
                    .accessibilityIdentifier("addLocationField")
                TextField("Last tested", text: $lastTested)
                    .accessibilityIdentifier("addLastTestedField")
                TextField("Battery type", text: $batteryType)
                    .accessibilityIdentifier("addBatteryTypeField")
                TextField("Notes", text: $notes)
                    .accessibilityIdentifier("addNotesField")
            }
            .navigationTitle(editing == nil ? "Add Detector" : "Edit Detector")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isPresented = false; dismiss() }
                        .accessibilityIdentifier("addCancelButton")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if var e = editing {
                            e.location = location
                            e.lastTested = lastTested
                            e.batteryType = batteryType
                            e.notes = notes
                            store.update(e)
                        } else {
                            let entry = DetectorEntry(location: location, lastTested: lastTested, batteryType: batteryType, notes: notes)
                            let added = store.add(entry, isPro: purchases.isPro)
                            if !added { return }
                        }
                        isPresented = false
                        dismiss()
                    }
                    .accessibilityIdentifier("addSaveButton")
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
