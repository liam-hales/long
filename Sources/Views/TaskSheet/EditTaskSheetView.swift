import LucideSwift
import SwiftUI

/// Used to display the edit view which allows
/// the user to update task sheet details
struct EditTaskSheetView: View {
  private static let _maxNameLength = 24
  private static let _maxTaglineLength = 32

  private static let _icons: [LucideIconName] = [
    .notebook, .briefcaseBusiness, .house, .shoppingCart, .wallet, .piggyBank,
    .heart, .star, .flag, .target, .trophy, .lightbulb,
    .computer, .monitor, .laptop, .tabletSmartphone, .smartphone, .phone,
    .appWindowMac, .squareTerminal, .codeXml, .bug, .gitBranch, .database,
    .bookOpen, .graduationCap, .wrench, .hammer, .paintbrush, .camera,
    .dumbbell, .bike, .utensils, .coffee, .pill, .stethoscope,
    .plane, .car, .tent, .mountain, .globe, .mapPin,
    .users, .baby, .dog, .cat, .leaf, .gift,
  ]

  private let _sheet: TaskSheetModel

  @Environment(\.displayScale)
  private var _displayScale: CGFloat

  @State
  private var _name: String

  @State
  private var _tagline: String

  @State
  private var _icon: LucideIconName

  private var _trimmedName: String {
    self._name.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  private var _trimmedTagline: String {
    self._tagline.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  private var _hasChanges: Bool {
    (
      self._trimmedName != self._sheet.name ||
      self._trimmedTagline != self._sheet.tagline ||
      self._icon != self._sheet.icon
    )
  }

  private var _isValid: Bool {
    (
      self._trimmedName.isEmpty == false &&
      self._trimmedName.count <= Self._maxNameLength &&
      self._trimmedTagline.count <= Self._maxTaglineLength
    )
  }

  /// Initialises the view with the
  /// task `sheet` to edit
  init(sheet: TaskSheetModel) {
    self._sheet = sheet

    self.__name = State(initialValue: sheet.name)
    self.__tagline = State(initialValue: sheet.tagline)
    self.__icon = State(initialValue: sheet.icon)
  }

  var body: some View {
    EditView(
      subject: "task sheet",
      height: 700,
      hasChanges: self._hasChanges,
      isValid: self._isValid,
      onSave: {
        self._sheet.update(
          name: self._trimmedName,
          tagline: self._trimmedTagline,
          icon: self._icon
        )
      },
      content: {
        VStack(
          alignment: .leading,
          spacing: 0
        ) {
          HStack(
            alignment: .center,
            spacing: 12
          ) {
            TextField(
              "Name",
              text: self.$_name,
              prompt: Text("Untitled")
                .foregroundStyle(Color.contentSecondary)
            )
            .font(.serif(20, .semibold))
            .submitLabel(.done)

            // Display the current name character
            // count so the user knows not to go over
            Text("\(self._trimmedName.count) / \(Self._maxNameLength)")
              .foregroundStyle(
                (self._trimmedName.count > Self._maxNameLength)
                  ? Color.contentError
                  : Color.contentSecondary
              )
              .font(.mono(11))
          }
          .padding(.horizontal, 20)
          .padding(.vertical, 16)

          Rectangle()
            .fill(Color.outline)
            .frame(height: 2 / self._displayScale)
            .allowsHitTesting(false)

          HStack(
            alignment: .center,
            spacing: 12
          ) {
            TextField(
              "Tagline",
              text: self.$_tagline,
              prompt: Text("Add a tagline")
                .foregroundStyle(Color.contentSecondary)
            )
            .font(.serif(16, .regular))
            .submitLabel(.done)

            // Display the current tagline character
            // count so the user knows not to go over
            Text("\(self._trimmedTagline.count) / \(Self._maxTaglineLength)")
              .foregroundStyle(
                (self._trimmedTagline.count > Self._maxTaglineLength)
                  ? Color.contentError
                  : Color.contentSecondary
              )
              .font(.mono(11))
          }
          .padding(.horizontal, 20)
          .padding(.vertical, 16)
        }
        .background(
          RoundedRectangle(cornerRadius: 14)
            .fill(Color.surfaceHigh)
            .strokeBorder(Color.outline, lineWidth: 1)
        )

        LazyVGrid(
          columns: Array(
            repeating: GridItem(.flexible(), spacing: 8),
            count: 6
          ),
          spacing: 8
        ) {
          ForEach(Self._icons, id: \.self) { icon in
            let isSelected = (self._icon == icon)

            Button(
              action: {
                self._icon = icon
              },
              label: {
                ZStack(alignment: .center) {
                  if (isSelected == true) {
                    Circle()
                      .fill(Color.accent)
                  }

                  LucideIcon(
                    icon,
                    size: 22,
                    color: (isSelected == true)
                      ? .white
                      : .contentPrimary
                  )
                }
                .frame(
                  width: 44,
                  height: 44
                )
                .contentShape(.circle)
              }
            )
            .buttonStyle(.plain)
          }
        }
        .padding(12)
        .background(
          RoundedRectangle(cornerRadius: 14)
            .fill(Color.surfaceHigh)
            .strokeBorder(Color.outline, lineWidth: 1)
        )
      }
    )
  }
}
