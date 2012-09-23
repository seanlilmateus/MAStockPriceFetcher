class MAViewController < UIViewController
  def title
    "First Example"
  end

  def layout_contrains
    views_dict = { "title_label" => @title_label, "subtitle_label" => @subtitle_label, "button_action" => @button_action, "text_field" => @text_field, "info_label" => @info_label }
    metrics = {"width" => 100, "height"=> 80, "title_height" => @title_height }
    # First row with the title_label
    self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[title_label]-|", 
                                                                    options: 0, 
                                                                    metrics: nil, 
                                                                      views: views_dict))
    # second row with the subtitle_label
    self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[subtitle_label]-|", 
                                                                    options: 0, 
                                                                    metrics: nil, 
                                                                      views: views_dict))
    # third row with an infolabel centered
    self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[info_label]-|", 
                                                                    options: 0, 
                                                                    metrics: nil, 
                                                                      views: views_dict))
    # vertical aligment: text_field has an NSSPace of 103 from the top of the self.view and the info_label is direct attached to the text_field. info_label has a height on 80
    # the info_label height is a priority of 1000 which happens to be the biggest priority
    self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[title_label(title_height@1000)]-(-10)-[subtitle_label]-[text_field(>=43)]", 
                                                                    options: 0, 
                                                                    metrics: metrics, 
                                                                      views: views_dict))
    # third row with the input text_field and  action_button with a NSSpace of 5 between both elements    
    self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[text_field]-5-[button_action]-|", 
                                                                    options: 0, 
                                                                    metrics: metrics, 
                                                                      views: views_dict))
    self.view.addConstraint(NSLayoutConstraint.constraintWithItem(@button_action,
                                                        attribute: NSLayoutAttributeWidth,
                                                        relatedBy: NSLayoutRelationEqual,
                                                           toItem: @text_field,
                                                        attribute: NSLayoutAttributeWidth,
                                                       multiplier: 0.5,
                                                         constant: 1.0))
                                                         
    self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[info_label(==height@1000)]-5-|", 
                                                                      options: 0, 
                                                                      metrics: metrics, 
                                                                        views: views_dict))
    self.view.addConstraint(NSLayoutConstraint.constraintWithItem(@button_action,
                                                        attribute: NSLayoutAttributeCenterY,
                                                        relatedBy: NSLayoutRelationEqual,
                                                           toItem: @text_field,
                                                        attribute: NSLayoutAttributeCenterY,
                                                       multiplier: 1.0,
                                                         constant: 0))
    NSLog("constraints: %@", self.view.constraints)
  end
  
  def viewDidLoad
    self.view.backgroundColor = UIColor.whiteColor #UIColor.underPageBackgroundColor


    @title_label = UILabel.alloc.initWithFrame([[0, 0], [20, 30]]).tap do |label|
      label.translatesAutoresizingMaskIntoConstraints = false
      color = UIColor.clearColor #greenColor
      # new attributed strings
      style = Hash[
        NSForegroundColorAttributeName, UIColor.redColor,
        NSBackgroundColorAttributeName, color,
        NSFontAttributeName, UIFont.fontWithName("Zapfino", size:22.0)
      ]
      attr_str = NSAttributedString.alloc.initWithString("Price 📈Fetcher", attributes:style)
      @title_height = attr_str.size.height
      label.attributedText = attr_str
      label.textAlignment = UITextAlignmentCenter
      label.backgroundColor = color
      self.view.addSubview(label)
    end


    @subtitle_label = UILabel.alloc.initWithFrame([[0, 0], [280, 30]]).tap do |label|
      label.translatesAutoresizingMaskIntoConstraints = false
      label.text = "Enter a Symbol"
      label.font = UIFont.systemFontOfSize(18)
      label.textColor = UIColor.blackColor
      label.backgroundColor = UIColor.clearColor #cyanColor
      label.textAlignment = UITextAlignmentCenter
      self.view.addSubview(label)
    end


    @text_field = UITextField.alloc.initWithFrame([[0, 0],[182, 30]]).tap do |text_field|
      text_field.translatesAutoresizingMaskIntoConstraints = false
      text_field.borderStyle = UITextBorderStyleRoundedRect
      text_field.placeholder = "Stock Symbol"
      text_field.font = UIFont.systemFontOfSize(20)
      text_field.backgroundColor = UIColor.clearColor #redColor
      text_field.contentVerticalAlignment   = UIControlContentVerticalAlignmentCenter
      text_field.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft 
      self.view.addSubview(text_field)
    end


    @button_action = UIButton.buttonWithType(UIButtonTypeRoundedRect).tap do |button|
      button.translatesAutoresizingMaskIntoConstraints = false
      button.font  = UIFont.boldSystemFontOfSize(15)
      button.setTitle("Get Price", forState:UIControlStateNormal)
      button.frame.size = [90, 30]
      self.view.addSubview(button)
      button.enabled = false
      
      button.when(UIControlEventTouchUpInside) do
        @text_field.resignFirstResponder
        @text_field.text =  "AAPL"  if @text_field.text.empty? 
        @symbol = @text_field.text.upcase
        self.fetcher.request_qoute_for_symbol(@symbol) do |successful, price|          
          NSOperationQueue.mainQueue.addOperationWithBlock -> do
            @subtitle_label.text =  successful ? ("%s lastest price: %.2f" % [@symbol, price]) : "Unable to fetch price. Try again."
          end
        end
      end
    end


    @info_label = UILabel.alloc.initWithFrame([[20, 134], [280, 80]]).tap do |label|
      label.translatesAutoresizingMaskIntoConstraints = false
      label.text =  "This application is for sample purposes only. Prices are not guartanteed to be correct. Do not base any investment or other decisions on the information it provides."
      label.lineBreakMode = UILineBreakModeTailTruncation
      label.numberOfLines = 0
      label.sizeToFit
      label.font = UIFont.systemFontOfSize(10)
      label.textAlignment = UITextAlignmentCenter
      label.backgroundColor = UIColor.clearColor #blueColor
      label.textColor = UIColor.colorWithHue(0.0, saturation:0.0, brightness:0.40, alpha:1.0)
      self.view.addSubview(label)
    end
    
    NSNotificationCenter.defaultCenter.addObserverForName(UITextFieldTextDidChangeNotification, object:@text_field, queue:NSOperationQueue.mainQueue, usingBlock:lambda do |note| 
      text_field = note.object
      @button_action.enabled = (text_field.text.nil? or text_field.text.strip.empty?) ? false : true
      @subtitle_label.text = "Enter a Symbol" if text_field.text.strip.empty?
    end)

    layout_contrains
  end
    
  def viewDidAppear(animated)
    super
    self.becomeFirstResponder
    @text_field.becomeFirstResponder
  end
  
  def viewDidDisappear(animated)
    self.becomeFirstResponder
  end
  
  def canBecomeFirstResponder
    true
  end
  
  def motionEnded(motion, withEvent:event)
    if event.subtype == UIEventSubtypeMotionShake
      puts :shake
    end
    super
  end
  
  def fetcher
    MAPriceFetcher.instance
  end
end