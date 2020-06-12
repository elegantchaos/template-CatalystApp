// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by xXxuserxXx on xXxdatexXx.
//  All code (c) xXxyearxXx - present day, xXxownerxXx.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import ApplicationExtensions
import Logger
import SwiftUI
import SwiftUIExtensions
import Files

let settingsChannel = Channel("Settings")

class Application: BasicApplication {
    
    #if DEBUG
    let stateKey = "StateDebug"
    #else
    let stateKey = "State"
    #endif
    
    lazy var updater: Updater = makeUpdater()
    
    var rootController: UIViewController?
    var settingsObserver: Any?
    var viewState = ViewState()
    var model = makeModel()
    let sheetController = SheetController()
    
    func makeUpdater() -> Updater {
        return Updater()
    }
    
    @objc func changed() {
        restoreState()
    }
    
    class func makeModel() -> Model {
        Model()
    }
    
    override func setUp(withOptions options: BasicApplication.LaunchOptions) {
        super.setUp(withOptions: options)
        
        sheetController.environmentSetter = { view in AnyView(self.applyEnvironment(to: view)) }
        
        UserDefaults.standard.register(defaults: [:])
        
        restoreState()
    }
    
    override func tearDown() {
        if let observer = settingsObserver {
            NotificationCenter.default.removeObserver(observer, name: UserDefaults.didChangeNotification, object: nil)
        }
    }
    
    func didSetUp(_ window: UIWindow) {
        applySettings()
        settingsObserver = NotificationCenter.default.addObserver(forName: UserDefaults.didChangeNotification, object: nil, queue: nil) { notification in
            self.applySettings()
        }
    }
    
    func applySettings() {
    }
  
    func applyEnvironment<T>(to view: T) -> some View where T: View {
        return view
            .environmentObject(viewState)
            .environmentObject(model)
            .environmentObject(updater)
            .environmentObject(sheetController)
    }

    func stateWasEdited() {
        saveState()
    }
    
    func saveState() {
    }
    
    func restoreState() {
    }
    
}
