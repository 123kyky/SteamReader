Pod::Spec.new do |s|

# Library
#required
s.name = 'SteamReader'
#required
s.version = '0.1.0'
s.cocoapods_version = '1.0.0'
# use s.authors to add more authors
#required
s.author = { 'Kyle Roberts' => '123kyle.roberts@gmail.com' }
s.social_media_url = "https://twitter.com/TheKyKy123"
# use :type, :file, or :text for custom license
#required
s.license = { :type => 'MIT', :file => 'LICENSE' }
#required
s.homepage = 'https://github.com/123kyky/SteamReader'
# can use CocoaPods git keys here
#required
s.source = { :git => 'https://github.com/123kyky/SteamReader.git', :tag => s.version.to_s }
#required
s.summary = 'A simple app to browse and subscribe to Steam game news.'
s.description = <<-DESC
    A simple app to browse and subscribe to Steam game news.
    A simple app to browse and subscribe to Steam game news.
    A simple app to browse and subscribe to Steam game news.
DESC
s.screenshots = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
s.documentation_url = 'https://github.com/123kyky/SteamReader'
# path to bash script
s.prepare_command = <<-CMD
    # write code here
CMD
s.deprecated = false
s.deprecated_in_favor_of = 'SteamReader2'


# Platform
s.platform = :ios, '9.0'
s.deployment_target = '9.0'

# Build Settings
s.dependency = 'Pod', '~> x.x'
s.ios.requires_arc = true
s.ios.frameworks = 'FrameWork'
s.ios.weak_framework = 'FrameWork'
s.ios.libraries = 'library'
s.ios.compiler_flags = '-BOOLflag=true', '-otherFLAG'
s.ios.pod_target_xcconfig = { '-aFlag' => '-aValue' }
s.ios.user_target_xcconfig = { 'SteamReaderSubspec' => 'YES' }
s.ios.prefix_header_contents = 'import CoreData'
s.ios.prefix_header_file = 'path/to/prefix.pch'
s.module_name = 'module_name'
s.ios.header_dir = 'path/to/put/headers'
s.ios.header_mappings_dir = 'path/to/headers'

# Files
s.ios.source_files = 'SteamReader/**/*.swift'
s.ios.public_header_files = 'SteamReader/pub/*.[h,m]'
s.ios.private_header_files = 'SteamReader/pri/*.h'
s.ios.vendored_frameworks = 'path/to/framework.framework'
s.ios.vendored_libraries = 'path/to/library.a'
s.ios.resource_bundles = { 'Assets' => 'path/to/assets/*.{png, jpg}' }
# use resources for multiple
s.ios.resources = 'path/to/resource'
s.ios.exclude_files = 'path/to/excluded'
# use preserved_paths for multiple
s.ios.preserve_path = 'path/to/required'
s.ios.module_map = 'path/to/*.modulemap'

# Subspec
subspec 'Network' do |sub|
    sub.source_files = 'SteamReader/Network/*.swift'
end

subspec 'CoreData' do |sub|
    sub.source_files = 'SteamReader/CoreData'
end

s.default_subspecs = 'CoreData'






  s.ios.deployment_target = '8.0'
  # s.resource_bundles = {
  #   'SteamReader' => ['SteamReader/Assets/*.png']
  # }
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'


end
