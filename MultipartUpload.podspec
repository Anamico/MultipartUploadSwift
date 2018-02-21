#
# Be sure to run `pod lib lint MultipartUpload.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MultipartUpload'
  s.version          = '0.1.0'
  s.summary          = 'MultipartUpload is designed to simplify large file background upload for iOS'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  			Multipart upload handles the complexity in cutting up large files, queuing and background uploading them for you.

			It requires a sibling implementation on the server end to accept the multipart upload and stitch it together.

			For example: https://github.com/Anamico/S3StreamThru
			Which is a node express middleware that handles streaming the upload directly to an S3 bucket server side before the
			completed file URL on S3 is passed on to the express route as a completed upload for processing by the server.
                       DESC

  s.homepage         = 'https://github.com/anamico/MultipartUploadSwift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'macinspak' => 'roo@roo.emu.id.au' }
  s.source           = { :git => 'https://github.com/anamico/MultipartUploadSwift.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'MultipartUpload/Classes/**/*'
  
  # s.resource_bundles = {
  #   'MultipartUpload' => ['MultipartUpload/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
