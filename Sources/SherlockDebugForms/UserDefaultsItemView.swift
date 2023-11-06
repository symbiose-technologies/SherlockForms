import SwiftUI

extension View {
    
    func navBarInline(_ isInline: Bool = true) -> some View {
    #if os(iOS)
        self
            .navigationBarTitleDisplayMode(isInline ?  .inline : .large)
    #else
        self
    #endif
    }
    
    
    /// Set the keyboard type for the view. No-op on macOS
    func defaultKeyboard() -> some View {
        #if os(iOS)
        self
            .keyboardType(.default)
        #else
        self
        #endif
    }
    
    /// Set the keyboard type for the view. No-op on macOS
    func numberKeyboard() -> some View {
        #if os(iOS)
        self
            .keyboardType(.numberPad)
        #else
        self
        #endif
    }
    
    
    
    /// Set the keyboard type for the view. No-op on macOS
    func decimalKeyboard() -> some View {
        #if os(iOS)
        self
            .keyboardType(.numberPad)
        #else
        self
        #endif
    }
    
}

extension ToolbarItemPlacement {
    
    static func navBarTrail() -> ToolbarItemPlacement {
        #if os(iOS)
        return .navigationBarTrailing
        #else
        return .navigation
        #endif
    }
    
    
    static func btmBar() -> ToolbarItemPlacement {
        #if os(iOS)
        return .bottomBar
        #else
        return .primaryAction
        #endif
    }
}

/// Single key-value pair viewer for `UserDefaults`.
struct UserDefaultsItemView: View, SherlockView
{
    // TODO: Add custom filtering to search per line.
    @State var searchText: String = ""

    @State private var canEditAsString: Bool = false

    // TODO: Replace with `\.dismiss` for iOS 15.
    @Environment(\.presentationMode) private var presentationMode

    private let key: String
    private let value: Any
    private var editableString: AppStorage<String>

    init(key: String, value: Any, userDefaults: UserDefaults = .standard)
    {
        self.key = key
        self.value = value

        if let value = value as? String {
            self.editableString = AppStorage(wrappedValue: value, key, store: userDefaults)
            self.canEditAsString = true
        }
        else {
            self.editableString = AppStorage(wrappedValue: "\(value)", key, store: userDefaults)
            self.canEditAsString = false
        }
    }

    var body: some View
    {
        NavigationView {
            SherlockForm(searchText: $searchText) {
                _body(canEditAsString: canEditAsString)
            }
            .formCellCopyable(true)
            .navigationTitle(key)
            .navBarInline()
            
            .toolbar {
                ToolbarItemGroup(placement: .navBarTrail()) {
                    Button(action: { presentationMode.wrappedValue.dismiss() }, label: {
                        Image(systemName: "xmark")
                    })
                }

                ToolbarItemGroup(placement: .btmBar()) {
                    if !canEditAsString {
                        Spacer()
                        Button(action: { canEditAsString = true }, label: {
                            Image(systemName: "exclamationmark.triangle")
                            Text("Edit as String (Unsafe)")
                        })
                        Spacer()
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func _body(canEditAsString: Bool) -> some View
    {
        Section {
            textCell(title: "\(key)")
        } header: {
            Text("Key")
        }

        Section {
            textCell(title: "\(type(of: value))")
        } header: {
            Text("Type")
        }

        Section {
            textEditorCell(value: editableString.projectedValue, modify: { textEditor in
                textEditor
                    .padding(canEditAsString ? 8 : 0)
                    .disabled(!canEditAsString)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(canEditAsString ? 0.25 : 0), lineWidth: 0.5)
                    )
                    .onChange(of: canEditAsString, perform: { canEditAsString in
                        // NOTE:
                        // Set the `editableString.wrappedValue` to tell `textEditor`
                        // to update its scroll content.
                        if canEditAsString {
                            editableString.wrappedValue = editableString.wrappedValue
                        }
                    })
            })
        } header: {
            Text("Value")
        } footer: {
            if !canEditAsString {
                Text("""
                    Note:
                    Smart type recognition is not supported yet. To (unsafely) edit value as string, tap bottom button.
                    """)
                    .padding(.top, 16)
            }
        }
    }

    typealias KeyValue = UserDefaultsListSectionsView.KeyValue
}
