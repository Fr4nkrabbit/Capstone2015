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

class SongViewController: UIViewController, WKScriptMessageHandler, UIGestureRecognizerDelegate {
    
    var followBool = true
    

    @IBAction func followSong(sender: AnyObject) {
        if followBool{
            print("getting hit yo")
            basicFollow(globalTempo)
        }
        else {
            print("ehhh")
            stopFollow()
        }
        followBool = !followBool
    }

    var theWebView:WKWebView?

    var instruments: String = ""
    var id: String = ""
    var songName: String = ""
    var MidiArg = ""
    
    var song: Song?
    var flip = false
    var measuresShown = UILabel()
    //var followLabel = UILabel()
    
    //let u = SomeStructure.storedTypeProperty
    
    //var structData:GlobalStruct;
    
    func loadSmartFeatures(){
        let smartFeatures = SmartFeatures()
        //view.addSubview(smartFeatures)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        showMeasure()
        
        //loadSmartFeatures()
        
        //view.backgroundColor = UIColor(red: 255/256, green: 255/256, blue: 240/256, alpha: 1)

        
        /*let smartFeatureBool = UIButton(frame: CGRectMake(0,0,100,100))
        let buttonWidth = screenWidth * 0.9
        smartFeatureBool.center = CGPointMake(buttonWidth, 67)
        smartFeatureBool.setTitle("Smart Features", forState: UIControlState.Normal)
        view.addSubview(smartFeatureBool)*/
        
        
        //print(song?.name)
        songName = (song?.name)!
        print(songName)
        self.navigationItem.title = songName
        
        //let webstring = "http://people.eecs.ku.edu/~sbenson/grabMidi.php?title=" + songName
        //loads the midi file from the database
        loadMidi(id)
        //loads the actual sheet music
        load()
        
        pageTurnButtonLoad()
    
        let rightArrowName = "Right_Arrow.png"
        let rightImage = UIImage(named: rightArrowName)
        let rightArrowView = UIImageView(image: rightImage!)
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width * 0.5
        let rightWidth = screenWidth + 50
        rightArrowView.frame = CGRect(x: rightWidth, y: 15, width: 47, height: 26)
        view.addSubview(rightArrowView)
        
        let leftArrowName = "Left_Arrow.png"
        let leftImage = UIImage(named: leftArrowName)
        let leftArrowView = UIImageView(image: leftImage!)
        let leftWidth = screenWidth - 90
        leftArrowView.frame = CGRect(x: leftWidth, y: 15, width: 47, height: 26)
        view.addSubview(leftArrowView)
        
        
        //To change the note down
        leftArrowView.userInteractionEnabled = true
        let tapPrev: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(didTapPrev1))
        leftArrowView.addGestureRecognizer(tapPrev)
        
        //To change the note down
        rightArrowView.userInteractionEnabled = true
        let tapNext: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(didTapNext1))
        rightArrowView.addGestureRecognizer(tapNext)
        
        tapPrev.delegate = self
        tapNext.delegate = self

        /*let labelScreenSize: CGRect = UIScreen.mainScreen().bounds
        let screenHeight = labelScreenSize.height * 0.65
        
        let darkLine = UILabel(frame:CGRectMake(0, screenHeight, 10, labelScreenSize.width))
        darkLine.backgroundColor = UIColor.blackColor()
        self.view.addSubview(darkLine)*/
        
        /*followLabel = UILabel(frame: CGRectMake(0, 0, 100, 100))
        //let screenSize: CGRect = UIScreen.mainScreen().bounds
        let labelWidth = screenSize.width * 0.9
        followLabel.center = CGPointMake(screenWidth, 67)
        followLabel.textAlignment = NSTextAlignment.Center
        followLabel.text = "measures"
        self.view.addSubview(followLabel)*/
        
    }
    
    func pageTurnButtonLoad(){
        let rightArrowName = "Right_Arrow.png"
        let rightImage = UIImage(named: rightArrowName)
        let rightArrowView = UIImageView(image: rightImage!)
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width * 0.5
        let rightWidth = screenWidth + 50 + 40
        rightArrowView.frame = CGRect(x: rightWidth, y: 15, width: 47, height: 26)
        view.addSubview(rightArrowView)
        
        let leftArrowName = "Left_Arrow.png"
        let leftImage = UIImage(named: leftArrowName)
        let leftArrowView = UIImageView(image: leftImage!)
        let leftWidth = screenWidth - 90 - 40
        leftArrowView.frame = CGRect(x: leftWidth, y:  15, width: 47, height: 26)
        view.addSubview(leftArrowView)
        
        //To change the note down
        leftArrowView.userInteractionEnabled = true
        let tapPrev: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(didTapPrev))
        leftArrowView.addGestureRecognizer(tapPrev)
        
        //To change the note down
        rightArrowView.userInteractionEnabled = true
        let tapNext: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(didTapNext))
        rightArrowView.addGestureRecognizer(tapNext)
        
        tapPrev.delegate = self
        tapNext.delegate = self
    }
    func loadMidi(Int: AnyObject){
        print("what is id?")
        print(id)
        let webstring = "http://people.eecs.ku.edu/~sxiao/grabMidi.php/?id=" + id
        
        
        if let url = NSURL(string: webstring) {
            do {
                
                let something = try NSString(contentsOfURL: url, usedEncoding: nil)
                let songListAsString = something as String
                MidiArg = songListAsString as String
                // print(MidiArg)
            } catch {
                print("contents bad yo")
            }
        } else {
            print("bad url")
        }
    }
    func showMeasure(){
        //measuresShown.textAlignment = NSTextAlignment.Center
        measuresShown = UILabel(frame: CGRectMake(0, 0, 100, 100))
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width * 0.5
        measuresShown.center = CGPointMake(screenWidth, 25)
        measuresShown.textAlignment = NSTextAlignment.Center
        measuresShown.text = "measures"
        self.view.addSubview(measuresShown)
    }
    func didTapPrev(sender: UITapGestureRecognizer){
        print("i got tapped")
        print(globalTempo)
        backPage()
        let d = "120"
        //followAlong()
    }
    func didTapNext(sender: UITapGestureRecognizer){
        print("i got tapped-right")
        nextPage()
    }
    func didTapPrev1(sender: UITapGestureRecognizer){
        print("left new")
        //print(globalTempo)
        backLine()
    }
    func didTapNext1(sender: UITapGestureRecognizer){
        //print("right new")
        nextLine()
    }
    
    /*@IBAction func smartFeaturesBool(sender: AnyObject) {
        if (flip){
            load()
        }else {
            loadModify()
        }
    }*/
    
    @IBAction func changePage() {
        
        print("i got tapped")
        //theWebView?.evaluateJavaScript("turnPage(1)", completionHandler: nil)
        flip = !flip
        if(flip){
            nextMeasure()
        }else{
            backMeasure()
        }
        /*if (flip){
            //self.view.willRemoveSubview(theWebView!)
            print("flip is true")
            load()
            flip = !flip
        }
        else{
            print("flip is false")
            //self.view.willRemoveSubview(theWebView!)
            loadModify()
            flip = !flip
        }*/
    }
    
    //call the javascript that will increament which line we are on and then redraw the music with new lines
    // this will move forward number of lines * measures per line
    func nextPage(){
        theWebView?.evaluateJavaScript("turnPage(1)", completionHandler: nil)
        
    }
    // this does the opposite of next page so just moves back a page
    func backPage(){
        theWebView?.evaluateJavaScript("turnPage(-1)", completionHandler: nil)
        
    }
    
    func nextMeasure(){
        theWebView?.evaluateJavaScript("singleMeasure(1)", completionHandler: nil)
        
    }
    // this does the opposite of next page so just moves back a page
    func backMeasure(){
        theWebView?.evaluateJavaScript("singleMeasure(-1)", completionHandler: nil)
        
    }

    
    func nextLine(){
        theWebView?.evaluateJavaScript("singleLine(1)", completionHandler: nil)
        
    }
    // this does the opposite of next page so just moves back a page
    func backLine(){
        theWebView?.evaluateJavaScript("singleLine(-1)", completionHandler: nil)
        
    }
    
    func goToMeasure(measure: String){
        
        theWebView?.evaluateJavaScript("goToMeasure("+measure+")", completionHandler: nil)
        
    }
    func setMeasuresPerLine(num: String){
        
        theWebView?.evaluateJavaScript("setMeasurePerLine("+num+")", completionHandler: nil)
        
    }
    
    func setLineCount(num: String){
        
        theWebView?.evaluateJavaScript("setLineCount("+num+")", completionHandler: nil)
        
    }
    

    
    //this will start off the follow along at a flat tempo
    func basicFollow(tempo: String){
        print("ai yo")
        print(tempo)
        theWebView?.evaluateJavaScript("startBasicFollow("+tempo+")", completionHandler: nil)
        
        
    }
    
    //this will stop any follow along we have going
    func stopFollow(){
        
        theWebView?.evaluateJavaScript("stopTimer()", completionHandler: nil)

        
    }
    func loadwebview(){
        let index1 = MidiArg.startIndex.advancedBy(MidiArg.characters.count-1)
        let substring1 = MidiArg.substringToIndex(index1)
        let js = "stringParseMidi('\(substring1)')" as String
        theWebView?.evaluateJavaScript(js,completionHandler: nil)
    }
    
    
    func load(){
        //let rect = CGRect(
        //  origin: CGPoint(x: 0, y: 45),
        //size: UIScreen.mainScreen().bounds.size)
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        let screenHeight = screenSize.height * 0.8
        let screenWidth = screenSize.width
        
        let rect = CGRect(x: 0, y: 38, width: screenWidth, height: screenHeight)
        
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
        loadwebview()
        
        
        
        
    }
    
    func loadModify(){
        //print("loadmodify")
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let rect = CGRect(x: 0, y: 87, width: screenWidth, height: screenHeight)
        
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
        for view in self.view.subviews{
            print(view)
            //view.removeFromSuperview()
        }
        //self.view.addSubview(theWebView!)
        
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
        
        
        let callback = sentData["callback"] as? String
        print(callback)
        
        if(callback=="start"){
            //passes the Midi file to javasript
            print("started")
            let index1 = MidiArg.startIndex.advancedBy(MidiArg.characters.count-1)
            let substring1 = MidiArg.substringToIndex(index1)
            let js = "stringParseMidi('\(substring1)')" as String
            print(js)
            theWebView!.evaluateJavaScript(js,completionHandler: nil)
            
        }else if(callback=="measures"){
            //this will update the measureShown lable with new values from the javascript
            let aCount:Int = Int(sentData["start"] as! NSNumber) + 1
            let anotherCount:Int = Int(sentData["end"] as! NSNumber)
            
            let start = String(aCount)
            let end = String(anotherCount)
            
            print(aCount)
            print(anotherCount)
            //let newStart = sentData["start"].length.stringValue
            //print(newStart)
            //let newEnd = sentData["end"] as! String
            measuresShown.text = start + " - " + end
        }
        
        
        
    }
    
    /*override func viewDidLoad() {
        super.viewDidLoad()
        print("songviewstuff")
        
        songTitle.title = songName
        
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
        print(MidiArg)
        var index1 = MidiArg.startIndex.advancedBy(MidiArg.characters.count-1)
        var substring1 = MidiArg.substringToIndex(index1)
        var js = "parseMidi('\(substring1)')" as String
        
        theWebView!.evaluateJavaScript(js,completionHandler: nil)
      //  theWebView!.evaluateJavaScript("createSheetMusic('\(instruments)')",completionHandler: nil)

        
    }*/
}
