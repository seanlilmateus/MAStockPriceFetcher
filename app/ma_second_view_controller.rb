class MASecondViewController < UIViewController
  def title
    "Second Example"
  end
  
  def layout_contrains
    views_dict = { "tram_stop_label" => @tram_stop_label, "text_field" => @text_field, "button_action" => @button_action }
    
    self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[tram_stop_label]-[text_field(<=tram_stop_label)]-|", 
                                                                                 options: NSLayoutAttributeCenterX, 
                                                                                 metrics: nil, 
                                                                                   views: views_dict))
    
    self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[button_action]-|", 
                                                                    options: 0, 
                                                                    metrics: nil, 
                                                                      views: views_dict))
    
  self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[text_field]-[button_action]", 
                                                                  options: 0, 
                                                                  metrics: nil, 
                                                                    views: views_dict))
  end
  
  def viewDidLoad
    self.view.backgroundColor = UIColor.whiteColor #UIColor.underPageBackgroundColor
    
    @tram_stop_label = UILabel.alloc.initWithFrame([[0, 0], [280, 30]]).tap do |label|
      label.translatesAutoresizingMaskIntoConstraints = false
      label.text = NSLocalizedString("Tram Stop")
      label.font = UIFont.systemFontOfSize(18)
      label.textColor = UIColor.blackColor
      label.backgroundColor = UIColor.clearColor #cyanColor
      label.textAlignment = UITextAlignmentCenter
      self.view.addSubview(label)
    end
    
    @text_field = UITextField.alloc.initWithFrame([[0, 0],[182, 30]]).tap do |text_field|
      text_field.translatesAutoresizingMaskIntoConstraints = false
      text_field.borderStyle = UITextBorderStyleRoundedRect
      text_field.placeholder = NSLocalizedString("Enter tram Stop")
      text_field.font = UIFont.systemFontOfSize(20)
      text_field.backgroundColor = UIColor.clearColor #redColor
      text_field.contentVerticalAlignment   = UIControlContentVerticalAlignmentCenter
      text_field.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft 
      self.view.addSubview(text_field)
    end
    
    @button_action = UIButton.buttonWithType(UIButtonTypeRoundedRect).tap do |button|
      button.translatesAutoresizingMaskIntoConstraints = false
      button.font  = UIFont.boldSystemFontOfSize(15)
      button.setTitle(NSLocalizedString("Maps"), forState:UIControlStateNormal)
      button.frame.size = [90, 30]
      button.enabled = true
      
      button.when(UIControlEventTouchUpInside) do
        @text_field.text = NSLocalizedString("nothing")
      end
      self.view.addSubview(button)
    end
    layout_contrains
  end
end