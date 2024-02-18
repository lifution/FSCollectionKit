Pod::Spec.new do |s|
  s.name     = 'FSCollectionKit'
  s.version  = '1.0.5'
  s.summary  = 'A data-driven UICollectionView framework.'
  s.homepage = 'https://github.com/lifution/FSCollectionKit'
  s.license  = { :type => 'MIT', :file => 'LICENSE' }
  s.author   = 'Sheng'
  s.source   = {
    :git => 'https://github.com/lifution/FSCollectionKit.git',
    :tag => s.version.to_s
  }
  
  s.requires_arc = true
  s.swift_version = '5'
  s.ios.deployment_target = '11.0'
  
  s.frameworks = 'UIKit', 'Foundation'
  s.source_files = 'Sources/Classes/**/*'
  s.resource_bundles = {
    'FSCollectionKit' => ['Sources/Assets/*.xcassets']
  }
end
