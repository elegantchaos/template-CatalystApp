// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by xXxuserxXx on xXxdatexXx.
//  All code (c) xXxyearxXx - present day, xXxownerxXx.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

class Updater: ObservableObject {
    @Published var progress: Double = 0
    @Published var status: String = ""
    @Published var hasUpdate: Bool = false

    func installUpdate() { }
    func skipUpdate() { }
    func ignoreUpdate() { }
}

