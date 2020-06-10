// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by xXxuserxXx on xXxdatexXx.
//  All code (c) xXxyearxXx - present day, xXxownerxXx.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-


import UIKit
import SwiftUI
import Logger
import Combine

#if canImport(SparkleBridgeClient)
import SparkleBridgeClient
#endif

fileprivate extension String {
    static let showInMenuKey = "ShowInMenu"
    static let showInDockKey = "ShowInDock"
}

extension Application {
    class var shared: MobileApplication {
        UIApplication.shared.delegate as! MobileApplication
    }
}

@UIApplicationMain
class MobileApplication: Application {
    var appKitBridge: AppKitBridge? = nil
    var editingSubscriber: AnyCancellable?
    
    #if canImport(SparkleBridgeClient)
    let sparkleEnabled = Bundle.main.hasFramework(named: "SparkleBridgeClient")
    var sparkleBridge: SparkleBridgePlugin? = nil

    override func makeUpdater() -> Updater {
        if sparkleEnabled {
            return SparkleUpdater()
        } else {
            return super.makeUpdater()
        }
    }
    #endif
    
    override func setUp(withOptions options: LaunchOptions) {
        loadSparkle()
        loadBridge()
        
        UserDefaults.standard.register(defaults: [
            .showInMenuKey: true,
            .showInDockKey: true
            ]
        )

        super.setUp(withOptions: options)
    }
    
    override func didSetUp(_ window: UIWindow) {
        if let bridge = appKitBridge {
            bridge.setup(with: self)
        }
        super.didSetUp(window)
    }
    
    override func applySettings() {
        super.applySettings()
        updateBridge()
        
        settingsChannel.log("\(String.showInMenuKey) is \(appKitBridge?.showInMenu ?? false)")
        settingsChannel.log("\(String.showInDockKey) is \(appKitBridge?.showInDock ?? false)")
    }

    fileprivate func updateBridge() {
    }
    
    fileprivate func loadSparkle() {
        #if canImport(SparkleBridgeClient)
        if let updater = updater as? SparkleUpdater {
            let result = SparkleBridgeClient.load(with: updater.driver)
            switch result {
                case .success(let plugin):
                    sparkleBridge = plugin
                    sparkleBridge?.checkForUpdates()
                case .failure(let error):
                    print(error)
                    self.updater = Updater()
            }
        }
        #endif
    }
    
    fileprivate func loadBridge() {
        if let bridgeURL = Bundle.main.url(forResource: "AppKitBridge", withExtension: "bundle"), let bundle = Bundle(url: bridgeURL) {
            if let cls = bundle.principalClass as? NSObject.Type {
                if let instance = cls.init() as? AppKitBridge {
                    #if canImport(SparkleBridgeClient)
                    instance.showUpdates = sparkleEnabled
                    #endif
                    appKitBridge = instance
                }
            }
        }
    }
    
    override func buildMenu(with builder: UIMenuBuilder) {
        super.buildMenu(with: builder)
        
        if builder.system == .main {
            builder.remove(menu: .services)
            builder.remove(menu: .format)
            builder.remove(menu: .toolbar)

            buildCheckForUpdates(with: builder)
            buildShowStatus(with: builder)
        }

        next?.buildMenu(with: builder)
    }
    
    @objc func showHelp(_ sender: Any) {
        if let url = URL(string: "https://xXxprojectLowercasexXx.elegantchaos.com/help") {
            UIApplication.shared.open(url)
        }
    }

    func buildCheckForUpdates(with builder: UIMenuBuilder) {
        #if canImport(SparkleBridgeClient)
        if sparkleEnabled {
            let command = UIKeyCommand(title: "Check For Updates…", image: nil, action: #selector(checkForUpdates), input: "", modifierFlags: [], propertyList: nil)
            builder.replaceChildren(ofMenu: .about) { (children) -> [UIMenuElement] in
                return children + [command]
            }
        }
        #endif
    }

    func buildShowStatus(with builder: UIMenuBuilder) {
        if let bridge = appKitBridge {
            let command = UIKeyCommand(title: "Show Status Window", image: nil, action: bridge.showWindowSelector, input: "0", modifierFlags: .command, propertyList: nil)
            let menu = UIMenu(title: "", image: nil, identifier: UIMenu.Identifier("\(info.id).show"), options: .displayInline, children: [command])
            builder.insertChild(menu, atEndOfMenu: .window)
        }
    }

}

extension MobileApplication: AppKitBridgeDelegate {
    func windowToIntercept() -> String {
        return info.name
    }
    
    func itemCount() -> Int {
        0
    }
    
    func name(forItem item: Int) -> String {
        ""
    }
    
    func status(forItem item: Int) -> ItemStatus {
        .unknown
    }
    
    func selectItem(_ item: Int) {
    }
    
    func addItem() {
    }
    
    func checkForUpdates() {
        #if canImport(SparkleBridgeClient)
        sparkleBridge?.checkForUpdates()
        #endif
    }
    
    func toggleEditing() -> Bool {
        return false
    }
}
