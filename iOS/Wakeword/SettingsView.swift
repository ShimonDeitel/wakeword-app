import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) private var dismiss
    @State private var showPaywall = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Pro") {
                    if purchases.isPro {
                        Label("Searchable archive and monthly recap view", systemImage: "checkmark.seal.fill")
                            .foregroundStyle(Theme.accent)
                    } else {
                        Button("Unlock Pro") { showPaywall = true }
                            .accessibilityIdentifier("unlockProButton")
                    }
                }

                Section("Preferences") {
                    Toggle("Daily Reminder", isOn: $store.remindersEnabled)
                        .accessibilityIdentifier("remindersToggle")
                    Toggle("iCloud Sync (Coming Soon)", isOn: .constant(false))
                        .disabled(true)
                }

                Section("About") {
                    Link("Privacy Policy", destination: URL(string: "https://shimondeitel.github.io/wakeword-app/privacy.html")!)
                    Link("Terms of Use", destination: URL(string: "https://shimondeitel.github.io/wakeword-app/terms.html")!)
                    Button("Restore Purchases") {
                        Task { await purchases.restore() }
                    }
                    .accessibilityIdentifier("settingsRestoreButton")
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                        .accessibilityIdentifier("settingsDoneButton")
                }
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
        }
    }
}
