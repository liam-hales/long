import LucideSwift
import SwiftUI

/// Used to display a form which allows the
/// user to create and edit task sheets
struct TaskSheetFormView: View {

  /// Describes the mode the form is in, either creating
  /// a new task sheet or editing an existing one
  private enum Mode {
    case create(_ onCreate: (_ name: String, _ tagline: String, _ icon: LucideIconName) -> Void)
    case edit(_ sheet: TaskSheetModel)
  }

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

  private let _mode: Mode

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

  private var _title: String {
    switch self._mode {
      case .create: "New task sheet"
      case .edit: "Edit task sheet"
    }
  }

  private var _subtitle: String {
    switch self._mode {
      case .create: "Create a new empty task sheet"
      case .edit: "Update your task sheet details"
    }
  }

  private var _confirmText: String {
    switch self._mode {
      case .create: "Create"
      case .edit: "Save"
    }
  }

  private var _hasChanges: Bool {
    switch self._mode {

      // A new task sheet has changes once any of
      // its details differ from the defaults
      case .create:
        return (
          self._trimmedName.isEmpty == false ||
          self._trimmedTagline.isEmpty == false ||
          self._icon != .notebook
        )

      case .edit(let sheet):
        return (
          self._trimmedName != sheet.name ||
          self._trimmedTagline != sheet.tagline ||
          self._icon != sheet.icon
        )
    }
  }

  private var _isValid: Bool {
    (
      self._trimmedName.isEmpty == false &&
      self._trimmedName.count <= Self._maxNameLength &&
      self._trimmedTagline.count <= Self._maxTaglineLength
    )
  }

  /// Initialises the view to
  /// create a new task sheet
  init(onCreate: @escaping (_ name: String, _ tagline: String, _ icon: LucideIconName) -> Void) {
    self._mode = .create(onCreate)

    self.__name = State(initialValue: "")
    self.__tagline = State(initialValue: "")
    self.__icon = State(initialValue: .notebook)
  }

  /// Initialises the view to update
  /// an existing task sheet
  init(sheet: TaskSheetModel) {
    self._mode = .edit(sheet)

    self.__name = State(initialValue: sheet.name)
    self.__tagline = State(initialValue: sheet.tagline)
    self.__icon = State(initialValue: sheet.icon)
  }

  /// Used to confirm the form and either create
  /// a new task sheet or update an existing one
  private func _confirm() -> Void {
    switch self._mode {

      case .create(let onCreate):
        onCreate(self._trimmedName, self._trimmedTagline, self._icon)

      case .edit(let sheet):
        sheet.update(
          name: self._trimmedName,
          tagline: self._trimmedTagline,
          icon: self._icon
        )
    }
  }

  var body: some View {
    FormView(
      title: self._title,
      subtitle: self._subtitle,
      confirmText: self._confirmText,
      height: 700,
      hasChanges: self._hasChanges,
      isValid: self._isValid,
      onConfirm: self._confirm
    ) {
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
            prompt: Text("Name")
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
  }
}
