class MAPriceFetcher
  YS_QUOTE_API_FORMAT_STRING  = "l1"
  YS_QUOTE_APIURL = "http://download.finance.yahoo.com/d/quotes.csv"
  
  def self.instance
    Dispatch.once { @instance ||= new }
    @instance
  end
  
  def request_qoute_for_symbol(symbol, &block)
    url = NSURL.URLWithString("#{YS_QUOTE_APIURL}?s=#{symbol}&f=#{YS_QUOTE_API_FORMAT_STRING}")
    req = NSURLRequest.requestWithURL(url)
    queue = NSOperationQueue.alloc.init
    queue.name = "Price Fetcher Queue"
    
    NSURLConnection.sendAsynchronousRequest(req, queue:queue, completionHandler:-> response, data, error {
      if (response and response.statusCode == 200)
        price = data.to_str.to_f
        block.call(true, price)
      else
        block.call(false, nil)
      end
    })
  end
  
  private_class_method :new  
end