/*
The MIT License (MIT)
Copyright (c) 2015 Lee Barney
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/


import UIKit
import WebKit
class SongViewController: UIViewController, WKScriptMessageHandler {
    
    var theWebView:WKWebView?
    @IBAction func GoBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    var instruments: String = ""
    var songName: String = ""
    var MidiArg = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        print("songviewstuff")
        
        
        print(instruments)
        
        
        print(songName)
        
        let rect = CGRect(
            origin: CGPoint(x: 0, y: 35),
            size: UIScreen.mainScreen().bounds.size)
        
        let path = NSBundle.mainBundle().pathForResource("index",
            ofType: "html")
        let url = NSURL(fileURLWithPath: path!)
        let request = NSURLRequest(URL: url)
        
        let theConfiguration = WKWebViewConfiguration()
        theConfiguration.userContentController.addScriptMessageHandler(self,
            name: "native")
        
        theWebView = WKWebView(frame: rect,
            configuration: theConfiguration)
        theWebView!.loadRequest(request)
        self.view.addSubview(theWebView!)
        let webstring = "http://people.eecs.ku.edu/~sbenson/grabMidi.php?title=" + songName
        
        if let url = NSURL(string: webstring) {
            do {
                
                let something = try NSString(contentsOfURL: url, usedEncoding: nil)
                let songListAsString = something as String
                MidiArg = songListAsString as String
                
            } catch {
                print("contents bad yo")
            }
        } else {
            print("bad url")
        }
        print("hello")
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        print("hello")
        let sentData = message.body as! NSDictionary
        
        var response = Dictionary<String,AnyObject>()
        
        let callbackString = sentData["callbackFunc"] as? String
        
        var index1 = MidiArg.startIndex.advancedBy(MidiArg.characters.count-1)
        var substring1 = MidiArg.substringToIndex(index1)
        var js = "parseMidi('\(substring1)')" as String
        
        theWebView!.evaluateJavaScript(js,completionHandler: nil)
        theWebView!.evaluateJavaScript("createSheetMusic('\(instruments)')",completionHandler: nil)

        
    }
}
