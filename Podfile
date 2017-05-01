platform :ios, '9.0'
inhibit_all_warnings!

target 'Drrrible' do
  use_frameworks!

  # Architecture
  pod 'ReactorKit'

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

  # UI
  pod 'SnapKit'
  pod 'ManualLayout'
  pod 'TTTAttributedLabel'
  pod 'TouchAreaInsets'

  # Logging
  pod 'CocoaLumberjack/Swift'

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
