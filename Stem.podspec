Pod::Spec.new do |s|
  s.name             = 'Stem'
  s.version          = '0.0.4'
  s.summary          = 'A set of useful categories for Foundation and UIKit.'
  
  
  s.homepage         = 'https://github.com/linhay/Stem.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lin' => 'is.linhay@outlook.com' }
  s.source = { :git => 'https://github.com/linhay/Stem.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '8.0'
  s.swift_version = '4.2'
  
  s.frameworks = ['UIKit']
  s.requires_arc = true
  
  dict = {
    'Core' => [],
    'Foundation' => ['Stem/Core'],
    'CALayer' => ['Stem/Core'],
    'CGRect' => ['Stem/Core'],
    'TableView' => ['Stem/Core'],
    'Color' => ['Stem/Core'],
    'Label' => ['Stem/Core'],
    'Font' => ['Stem/Core'],
    'Image' => ['Stem/Core'],
    'ImageView' => ['Stem/Core', 'Stem/Image'],
    'Control' => ['Stem/Core'],
    'NSLayoutConstraint' => ['Stem/Core'],
    'Application' => ['Stem/Core'],
    'Storyboard' => ['Stem/Core'],
    'NavigationBar' => ['Stem/Core'],
    'TextField' => ['Stem/Core'],
    'ViewController' => ['Stem/Core'],
    'View' => ['Stem/Core'],
    'Cell' => ['Stem/Core'],
    'GestureRecognizer' => ['Stem/Core'],
    'Button' => ['Stem/Core', 'Stem/Control']
  }
  
  dict.each { |key, value|
    s.subspec key do |ss|
      ss.source_files = 'Sources/' + key + '/**'
      for name in value
        ss.dependency name
      end
    end
  }
  
end
