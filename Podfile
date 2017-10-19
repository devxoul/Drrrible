platform :ios, '9.0'
inhibit_all_warnings!

target 'Drrrible' do
  use_frameworks!

  # Architecture
  pod 'ReactorKit'

  # Networking
  pod 'Alamofire'
  pod 'Moya', '10.0.0-beta.1'
  pod 'Moya/RxSwift', '10.0.0-beta.1'
  pod 'MoyaSugar', '1.0.0-beta.1'
  pod 'MoyaSugar/RxSwift', '1.0.0-beta.1'
  pod 'WebLinking', :git => 'https://github.com/devxoul/WebLinking.swift', :branch => 'swift-4.0'
  pod 'Kingfisher'

  # Rx
  pod 'RxSwift', '4.0.0-rc.0'
  pod 'RxCocoa', '4.0.0-rc.0'
  pod 'RxCodable', '0.3.0'
  pod 'RxDataSources', '3.0.0-rc.0'
  pod 'Differentiator', '3.0.0-rc.0'
  pod 'RxOptional'
  pod 'RxKeyboard'
  pod 'RxGesture', :git => 'https://github.com/RxSwiftCommunity/RxGesture.git', :branch => 'swift-4'
  pod 'RxViewController'
  pod 'SectionReactor', :git => 'https://github.com/devxoul/SectionReactor.git', :branch => 'swift-4.0'

  # UI
  pod 'SnapKit'
  pod 'ManualLayout'
  pod 'TTTAttributedLabel'
  pod 'TouchAreaInsets'
  pod 'UICollectionViewFlexLayout'

  # Logging
  pod 'CocoaLumberjack/Swift'
  pod 'Umbrella'
  pod 'Umbrella/Firebase'

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
    pod 'Stubber'
    pod 'Quick'
    pod 'Nimble'
  end

end

post_install do |installer|
  pods_dir = File.dirname(installer.pods_project.path)
  at_exit { `ruby #{pods_dir}/Carte/Sources/Carte/carte.rb configure` }
end
