import LucideSwift
import SwiftUI

/// Used to display the app
/// settings to the user
struct SettingsView: View {

  @Environment(AppSettings.self)
  private var _appSettings: AppSettings

  @Environment(\.dismiss)
  private var _dismiss: DismissAction

  @State
  private var _isEditingName: Bool = false

  @State
  private var _isEditingTime: Bool = false

  var body: some View {

    @Bindable
    var appSettings = _appSettings

    let version = Bundle.main.appVersion
    let build = Bundle.main.appBuild

    NavigationStack {
      List {
        SectionView(
          title: "General",
          icon: .slidersHorizontal
        ) {
          SettingsRowView(
            title: "Name",
            subtitle: "The name used to greet you"
          ) {
            Button(
              action: {
                self._isEditingName = true
              },
              label: {
                HStack(
                  alignment: .center,
                  spacing: 6
                ) {
                  Text(
                    (self._appSettings.preferredName.isEmpty == true)
                      ? "Add name"
                      : self._appSettings.preferredName
                  )
                  .font(.serif(14, .semibold))

                  LucideIcon(.penLine, size: 14)
                    .foregroundStyle(Color.contentSecondary)
                }
              }
            )
            .buttonStyle(.borderless)
            .sheet(isPresented: self.$_isEditingName) {
              EditNameView(name: self._appSettings.preferredName)
            }
          }

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
                    .font(.serif(14, .semibold))

                  LucideIcon(.chevronsUpDown, size: 16)
                    .foregroundStyle(Color.contentSecondary)
                }
              }
            )
            .tint(.contentPrimary)
          }

          SettingsRowView(
            title: "Date Format",
            subtitle: "Date e.g. \"\(self._appSettings.dateFormat.example)\""
          ) {
            Menu(
              content: {
                Picker("Date Format", selection: $appSettings.dateFormat) {
                  ForEach(DateFormat.allCases) { dateFormat in
                    Label(
                      title: {
                        Text(dateFormat.title)
                      },
                      icon: {
                        Image(
                          lucide: dateFormat.icon,
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
                  Text(self._appSettings.dateFormat.title)
                    .font(.serif(14, .semibold))

                  LucideIcon(.chevronsUpDown, size: 16)
                    .foregroundStyle(Color.contentSecondary)
                }
              }
            )
            .tint(.contentPrimary)
          }

          SettingsRowView(
            title: "Review Tasks",
            subtitle: "Review tasks before they are added"
          ) {
            Toggle("Review Tasks", isOn: $appSettings.isReviewEnabled)
              .labelsHidden()
          }
        }

        SectionView(
          title: "Notifications",
          icon: .bell
        ) {
          SettingsRowView(
            title: "Overdue",
            subtitle: "Daily reminder of overdue tasks"
          ) {
            Toggle("Overdue Notifications", isOn: $appSettings.isOverdueNotificationEnabled)
              .labelsHidden()
          }

          SettingsRowView(
            title: "Due Today",
            subtitle: "Daily reminder of tasks due today"
          ) {
            Toggle("Due Today Notifications", isOn: $appSettings.isDueTodayNotificationEnabled)
              .labelsHidden()
          }

          SettingsRowView(
            title: "Send Time",
            subtitle: "The time notifications are sent"
          ) {
            Button(
              action: {
                self._isEditingTime = true
              },
              label: {
                HStack(
                  alignment: .center,
                  spacing: 4
                ) {
                  Text(self._appSettings.notificationTime, format: .dateTime.hour().minute())
                    .font(.serif(14, .semibold))

                  LucideIcon(.chevronsUpDown, size: 16)
                    .foregroundStyle(Color.contentSecondary)
                }
              }
            )
            .buttonStyle(.borderless)
            .popover(isPresented: self.$_isEditingTime) {
              DatePicker(
                "Notification Time",
                selection: $appSettings.notificationTime,
                displayedComponents: .hourAndMinute
              )
              .frame(width: 210)
              .datePickerStyle(.wheel)
              .labelsHidden()
              .presentationCompactAdaptation(.popover)
            }
          }

          VStack(
            alignment: .center,
            spacing: 6
          ) {
            Text("LONG")
              .font(.logo(52))

            VStack(
              alignment: .center,
              spacing: 4
            ) {
              Text("© 2026 - Liam Hales")
                .font(.serif(12, .regular))

              Text("Version \(version) (build \(build))")
                .foregroundStyle(Color.contentSecondary)
                .font(.mono(10))
            }
          }
          .frame(maxWidth: .infinity)
          .padding(.top, 32)
          .listRowInsets(.vertical, 0)
          .listRowBackground(Color.clear)
          .listRowSeparator(.hidden)
        }
      }
      .toolbarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button(
            role: .close,
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
      .listRowSpacing(10)
      .listSectionSpacing(16)
      .contentMargins(.vertical, 20, for: .scrollContent)
      .scrollContentBackground(.hidden)
      .background(Color.base)
    }
    // This needs to be set as sheets are their own presentation and
    // don't update when the app appearance changes while open
    .preferredColorScheme(self._appSettings.appearance.scheme)
    .frame(idealWidth: 440)
    .presentationBackground(Color.base)
    .presentationSizing(
      .form.fitted(
        horizontal: true,
        vertical: false
      )
    )
  }
}
