platform :ios, '9.0'
inhibit_all_warnings!

target 'Drrrible' do
  use_frameworks!

  # Architecture
  pod 'ReactorKit'

  # DI
  pod 'Swinject'
  pod 'SwinjectAutoregistration'

  # Networking
  pod 'Alamofire'
  pod 'Moya'
  pod 'Moya/RxSwift'
  pod 'MoyaSugar'
  pod 'MoyaSugar/RxSwift'
  pod 'WebLinking', :git => 'https://github.com/kylef/WebLinking.swift',
                    :commit => 'fddbacc30deab8afe12ce1d3b78bd27c593a0c29'
  pod 'Kingfisher'

  # Model
  pod 'ObjectMapper'

  # Rx
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxDataSources'
  pod 'RxOptional'
  pod 'RxKeyboard'
  pod 'RxSwiftUtilities'
  pod 'RxReusable'
  pod 'RxGesture'
  pod 'RxViewController'

  # UI
  pod 'SnapKit'
  pod 'ManualLayout'
  pod 'TTTAttributedLabel'
  pod 'TouchAreaInsets'

  # Logging
  pod 'CocoaLumberjack/Swift'
  pod 'Umbrella'

  # Misc.
  pod 'Then'
  pod 'ReusableKit'
  pod 'CGFloatLiteral'
  pod 'SwiftyColor'
  pod 'SwiftyImage'
  pod 'UITextView+Placeholder'
  pod 'URLNavigator'
  pod 'KeychainAccess'
  pod 'Immutable'
  pod 'Carte'

  # SDK
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'Firebase/Core'

  target 'DrrribleTests' do
    inherit! :complete

    pod 'RxTest'
    pod 'RxExpect'
  end

end

post_install do |installer|
  pods_dir = File.dirname(installer.pods_project.path)
  at_exit { `ruby #{pods_dir}/Carte/Sources/Carte/carte.rb configure` }
end
