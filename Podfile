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
  pod 'WebLinking', :git => 'https://github.com/devxoul/WebLinking.swift', :branch => 'swift-4.0'
  pod 'Kingfisher'

  # Rx
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxCodable'
  pod 'RxDataSources'
  pod 'Differentiator'
  pod 'RxOptional'
  pod 'RxKeyboard'
  pod 'RxGesture'
  pod 'RxViewController'
  pod 'SectionReactor'

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
