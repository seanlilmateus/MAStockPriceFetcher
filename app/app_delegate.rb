class AppDelegate
  def application(app, didFinishLaunchingWithOptions:launchOptions)
    app.applicationSupportsShakeToEdit = true  
      
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds).tap do |win|
      win.rootViewController = UITabBarController.alloc.init.tap do |tab_vc|
        tab_vc.view.frame = CGRectMake(0, 0, 320, 460)
        tab_vc.viewControllers = [MAViewController.alloc.init, MASecondViewController.alloc.init]
        #.map { |vc| UINavigationController.alloc.initWithRootViewController(vc) }
        tab_vc.selectedIndex = 0
      end
      
      win.rootViewController.wantsFullScreenLayout = true
      win.makeKeyAndVisible
    end
    true
  end
end