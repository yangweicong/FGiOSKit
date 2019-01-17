#
#  Be sure to run `pod spec lint FGiOSKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name         = "FGiOSKit"
  spec.version      = "0.0.7"
  spec.summary      = "FGiOSKit"

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  spec.description  = "火鹰信息科技有限公司"

  spec.homepage     = "https://github.com/yangweicong/FGiOSKit"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See https://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  # spec.license      = "MIT (example)"
  spec.license      = { :type => "MIT", :file => "LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  spec.author             = { "figo_ywc" => "yangwc@figo.cn" }
  # Or just: spec.author    = "figo_ywc"
  # spec.authors            = { "figo_ywc" => "yangwc@figo.cn" }
  # spec.social_media_url   = "https://twitter.com/figo_ywc"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  # spec.platform     = :ios
  spec.platform     = :ios, "9.0"

  #  When using multiple platforms
  spec.ios.deployment_target = "9.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  spec.source       = { :git => "https://github.com/yangweicong/FGiOSKit.git", :tag => spec.version }


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  spec.framework  = "UIKit"
  # spec.frameworks = "SomeFramework", "AnotherFramework"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # spec.dependency "AFNetworking"
  # spec.dependency "AliyunOSSiOS"
  # spec.dependency "MJExtension"
  # spec.dependency "MBProgressHUD"

  # spec.dependency "EasyNavigation"
  # spec.dependency "MJRefresh"
  # spec.dependency "Masonry"
  # spec.dependency "TPKeyboardAvoiding"
  # spec.dependency "ReactiveObjC"
  # spec.dependency "UITableView+FDTemplateLayoutCell"
  # # spec.dependency "WMPageController"
  # spec.dependency "JKCategories"
  # spec.dependency "TZImagePickerController"

  # spec.dependency "SDCycleScrollView"
  # spec.dependency "YYKit"
  # spec.dependency 'PYPhotoBrowser'
  # spec.dependency 'SDWebImage'  ,'< 4.3.0'
  # spec.dependency 'AlipaySDK-iOS'  
  # spec.dependency 'WechatOpenSDK'  
  # spec.dependency 'UMCCommon'  
  # spec.dependency 'UMCAnalytics'
  # spec.dependency 'UMCShare/UI'  
  # spec.dependency 'UMCShare/Social/ReducedWeChat'  
  # spec.dependency 'UMCShare/Social/QQ'    
  # spec.dependency 'UMCShare/Social/Sina'    

# ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  spec.source_files  = "FGiOSKit/FGiOSKit.h"
  # spec.exclude_files = "FGiOSKit/APPConfig.h"
  spec.public_header_files = "FGiOSKit/FGiOSKit.h"

#iOSKit
  spec.subspec 'iOSKit' do |ioskit|
#      ioskit.source_files = 'JKCategories/Foundation/**/*.{h,m}'
#      ioskit.source_files = 'JKCategories/Foundation/**/*.{h,m}'
#     ioskit.public_header_files = 'FGiOSKit/Foundation/JKFoundation.h'
      ioskit.source_files = 'FGiOSKit/iOSKit/*.{h,m'
      # ioskit.frameworks = 'Foundation','UIKit'

      #三级
      ioskit.subspec 'BaseClass' do |baseclass|
          baseclass.source_files = 'FGiOSKit/iOSKit/BaseClass/*.{h,m}'
      end
      # ioskit.subspec 'Category' do |category|
      #     category.source_files = 'FGiOSKit/iOSKit/Category/*.{h,m}'
      # end
      # ioskit.subspec 'Helper' do |helper|
      #     helper.source_files = 'FGiOSKit/iOSKit/Helper/*.{h,m}'
      # end
      # ioskit.subspec 'WraperView' do |wraperView|
      #     wraperView.source_files = 'FGiOSKit/iOSKit/WraperView/*.{h,m}'
      # end

      # ioskit.subspec 'Component' do |component|
          
      #     #四级
      #     component.subspec 'AdvertiseHelper' do |advertiseHelper|
      #         advertiseHelper.source_files = 'FGiOSKit/iOSKit/Component/AdvertiseHelper/*.{h,m}'
      #     end
      #     component.subspec 'AliyunOSS' do |aliyunoss|
      #         aliyunoss.source_files = 'FGiOSKit/iOSKit/Component/AliyunOSS/*.{h,m}'
      #     end
      #     component.subspec 'AppStoreVersion' do |appstoreversion|
      #         appstoreversion.source_files = 'FGiOSKit/iOSKit/Component/AppStoreVersion/*.{h,m}'
      #     end
      #     component.subspec 'ImagePickerController' do |imagepickercontroller|
      #         imagepickercontroller.source_files = 'FGiOSKit/iOSKit/Component/ImagePickerController/*.{h,m}'
      #     end
      #     component.subspec 'MapManager' do |mapmanager|
      #         mapmanager.source_files = 'FGiOSKit/iOSKit/Component/MapManager/*.{h,m}'
      #     end
      #     component.subspec 'Pay' do |pay|
      #         pay.source_files = 'FGiOSKit/iOSKit/Component/Pay/*.{h,m}'
      #     end
      #     component.subspec 'UmengAnalytics' do |umenganalytics|
      #         umenganalytics.source_files = 'FGiOSKit/iOSKit/Component/UmengAnalytics/*.{h,m}'
      #     end
      #     component.subspec 'UMshare' do |umshare|
      #         umshare.source_files = 'FGiOSKit/iOSKit/Component/UMshare/*.{h,m}'
      #     end
      #     component.subspec 'WebView' do |webView|
      #         webView.source_files = 'FGiOSKit/iOSKit/Component/WebView/*.{h,m}'
      #     end
      # end
  end

end
