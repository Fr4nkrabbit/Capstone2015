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
class InstrumentsViewController: UIViewController, WKScriptMessageHandler, UITableViewDataSource, UITableViewDelegate{
    
    var theWebView:WKWebView?
    var MidiArg = ""

    
    @IBOutlet var myTableView: UITableView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return instruLists.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("HEY YO")
        let myCell:UITableViewCell = (myTableView.dequeueReusableCellWithIdentifier("prototype1", forIndexPath: indexPath) as? UITableViewCell)!
        
        myCell.textLabel?.text = instruLists[indexPath.row]
        myCell.imageView?.image = UIImage(named: "unchecked_checkbox")
        
        return myCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("You selected cell number: \(indexPath.row)!")
        print("yo ")
        //self.performSegueWithIdentifier("yourIdentifier", sender: self)
    }
    
    
    @IBAction func GoBack(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //var instruLists = [String]()
    var instruLists = ["", "loading", ""]
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let songDetailViewController = segue.destinationViewController as! SongViewController
            
            // Get the cell that generated this segue.
            if let selectedInstrumentCell = sender as? UITableViewCell {
                let indexPath = myTableView.indexPathForCell(selectedInstrumentCell)!
                let selectedInstrument = instruLists[indexPath.row]
                songDetailViewController.instruments = selectedInstrument
                songDetailViewController.songName = something
            }
        }
    }
    
    func loadInstruments(){
        
    }
    
    @IBOutlet weak var songTitle: UINavigationItem!
    

    var song: Song?
    var something = ""
    var id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        something = song!.name
        
        print(something)
        print("PRINT")
        print(id)
        
        /*if let song = song {
            print(song.name)
            
        }*/
        
        songTitle.title = something
        
        let webstring = "http://people.eecs.ku.edu/~sbenson/grabMidi.php?title=" + song!.name
        //let webstring = "http://people.eecs.ku.edu/~sxiao/grabMidi.php/?id=" + id

        
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
        
        let rect = CGRect(
                origin: CGPoint(x: 0, y: 0),
                size: UIScreen.mainScreen().bounds.size)
        
        /////////////////////////////////////////
        //kyles' stuff
        let path = NSBundle.mainBundle().pathForResource("index",
            ofType: "html")
        let url = NSURL(fileURLWithPath: path!)
        let request = NSURLRequest(URL: url)
        
        let theConfiguration = WKWebViewConfiguration()
        theConfiguration.userContentController.addScriptMessageHandler(self,
            name: "native")
        
        theWebView = WKWebView(frame: rect, configuration: theConfiguration)
        theWebView!.loadRequest(request)
        self.view.addSubview(theWebView!)
        
        print("hello")
        
        myTableView.dataSource = self
        
        
    }
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        //print(MidiArg)
        print("hello")
        
        let sentData = message.body as! NSDictionary
        
        var response = Dictionary<String,AnyObject>()
        
        let callbackString = sentData["callbackFunc"] as? String
        
        theWebView!.evaluateJavaScript("test1()",completionHandler: nil)
        //print(MidiArg)
        let quote="\""
        print(quote)
        var index1 = MidiArg.startIndex.advancedBy(MidiArg.characters.count-1)
        var substring1 = MidiArg.substringToIndex(index1)
        var js = "parseMidi('\(substring1)')" as String
        
        //print(js)
        theWebView!.evaluateJavaScript(js){(JSReturnValue:AnyObject?, error:NSError?) in
            if let errorDescription = error?.description{
                print("returned value: \(errorDescription)")
                self.instruLists=["failed"]
            }
            else if JSReturnValue != nil{
                print("returned value: \(JSReturnValue!)")
                let instListAsString = JSReturnValue!
                self.instruLists = instListAsString.componentsSeparatedByString(",")
                print(self.instruLists)
                self.myTableView.reloadData()
                print(self.song!.name)
                
            }
            else{
                print("no return from JS")
            }
        }
        
    }
}
