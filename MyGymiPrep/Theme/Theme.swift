// This File belongs to MyGymiPrep
// Copyright © 2026 Thomas Kausch.
// All Rights Reserved.

import SwiftUI

struct Theme {
    let accent: Color = .indigo
    let deutsch: Color = .teal
    let mathematik: Color = .orange
    let done: Color = .green
    let bookmarked: Color = .indigo
    let starFilled: Color = .yellow
}

private struct ThemeKey: EnvironmentKey {
    static let defaultValue = Theme()
}

extension EnvironmentValues {
    var theme: Theme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}
