# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'SZDFavourites' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SZDFavourites
  $commonsLocal = { :path => '~/Documents/sanzapps/My Apps/SZDCommons' }
  $commonsGit = { :git => 'git@github.com:sanzoid/SZDCommons.git', :branch => 'master' }

  pod 'SZDCommons', $commonsLocal 
  #pod 'SZDCommons', $commonsGit 

  pod 'Google-Mobile-Ads-SDK'

  target 'SZDFavouritesTests' do
    inherit! :search_paths
    # Pods for testing
  end

end
