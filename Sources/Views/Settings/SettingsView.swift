import LucideSwift
import SwiftUI

/// Used to display the app
/// settings to the user
struct SettingsView: View {

  @Environment(AppSettings.self)
  private var _appSettings: AppSettings

  @Environment(\.dismiss)
  private var _dismiss: DismissAction

  var body: some View {

    @Bindable
    var appSettings = _appSettings

    let version = Bundle.main.appVersion
    let build = Bundle.main.appBuild

    NavigationStack {
      List {
        Section {
          SettingsRowView(
            title: "Appearance",
            subtitle: "The preferred app appearance"
          ) {
            Menu(
              content: {
                Picker("Appearance", selection: $appSettings.appearance) {
                  ForEach(AppAppearance.allCases) { appearance in
                    Label(
                      title: {
                        Text(appearance.title)
                      },
                      icon: {
                        Image(
                          lucide: appearance.icon,
                          size: .init(width: 22, height: 22)
                        )
                      }
                    )
                  }
                }
                .pickerStyle(.inline)
              },
              label: {
                HStack(
                  alignment: .center,
                  spacing: 4
                ) {
                  Text(self._appSettings.appearance.title)
                    .font(.serif(16, .semibold))

                  LucideIcon(.chevronsUpDown, size: 16)
                    .foregroundStyle(Color.contentSecondary)
                }
              }
            )
            .tint(.contentPrimary)
          }
        }

        Section {
          VStack(
            alignment: .center,
            spacing: 6
          ) {
            Text("LONG")
              .font(.logo(60))
            Text("Created by Liam Hales")
              .font(.serif(14, .regular))
            Text("Version \(version) (build \(build))")
              .foregroundStyle(Color.contentSecondary)
              .font(.mono(12))
          }
        }
        .frame(maxWidth: .infinity)
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .listRowInsets(.horizontal, 0)
      }
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button(
            action: {
              self._dismiss()
            },
            label: {
              LucideIcon(.x, size: 22)
            }
          )
        }
      }
      .listStyle(.plain)
      .navigationTitle("Settings")
      .navigationBarTitleDisplayMode(.inline)
      .listRowSpacing(10)
      .listSectionSpacing(40)
      .contentMargins(.vertical, 20, for: .scrollContent)
      .scrollContentBackground(.hidden)
      .background(Color.base)
    }
    // This needs to be set as sheets are their own presentation and
    // don't update when the app appearance changes while open
    .preferredColorScheme(self._appSettings.appearance.scheme)
    .presentationBackground(Color.base)
    .presentationDetents([
      .height(460)
    ])
  }
}
