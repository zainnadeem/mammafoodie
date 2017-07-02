import XCTest
import UIKit

@testable import mammafoodie

class DatabaseGatewayTests: XCTestCase {
    
    let videoPath = Bundle.main.path(forResource: "video", ofType: "mp4")
    let image = UIImage.init(named: "image.jpg")
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}

// MARK: - Upload Video on Firebase
extension DatabaseGatewayTests {
    
    func testSaveVideo() {
        if let filePath = self.videoPath {
            let expectationaSaveVideo = expectation(description: "Save Video")
            let fileURL = URL.init(fileURLWithPath: filePath)
            DatabaseGateway.sharedInstance.save(video: fileURL, at: "test.\(fileURL.pathExtension)", completion: { (downloadUrl, error) in
                print("Error: \(error?.localizedDescription ?? "No Error")")
                print("Download URL : \(downloadUrl?.absoluteString ?? "not found")")
                expectationaSaveVideo.fulfill()
            })
            waitForExpectations(timeout: 240) { (error) in
                print("Completed")
            }
        } else {
            print("Video not Found")
            XCTAssertFalse(true)
        }
    }
    
    
}

// MARK: - Upload Image on Firebase
extension DatabaseGatewayTests {
    func testSaveImage() {
        if let img = self.image {
            let expectationaSaveImage = expectation(description: "Save Image")
            DatabaseGateway.sharedInstance.save(image: img, at: "/test/image.jpg", completion: { (downloadUrl, error) in
                print("Error: \(error?.localizedDescription ?? "No Error")")
                print("Download URL : \(downloadUrl?.absoluteString ?? "not found")")
                expectationaSaveImage.fulfill()
            })
            waitForExpectations(timeout: 240) { (error) in
                print("Completed: \(String(describing: error?.localizedDescription))")
            }
        } else {
            print("Image not Found")
            XCTAssertFalse(true)
        }
    }
}


// MARK: - Live streams
extension DatabaseGatewayTests {
    
    func testGetStreamWithId() {
        let expectationGetLiveStreamList = expectation(description: "Live stream list")
        DatabaseGateway.sharedInstance.getLiveStream(with: "stream1", { (liveStream) in
            print(liveStream?.id ?? "Akshit")
            expectationGetLiveStreamList.fulfill()
        })
        waitForExpectations(timeout: 20) { (error) in
            print("Completed")
        }
    }
    
    func testLiveStreamsList() {
        let expectationLiveStreamList = expectation(description: "Live stream list")
        DatabaseGateway.sharedInstance.getLiveStreams { (liveStreams) in
            print(liveStreams.first?.id ?? "Name")
            expectationLiveStreamList.fulfill()
        }
        waitForExpectations(timeout: 20) { (error) in
            print("Completed")
        }
    }
    
    func testCreateLiveStreamModel() {
        let streamName: String = "streamTest"
        let streamId: String = "testId"
        let liveStream: MFMedia? = DatabaseGateway.sharedInstance.createLiveStreamModel(from: streamName, id: streamId)
        XCTAssertEqual(streamId, liveStream?.id)
    }
    
    //    func testPublishLiveStream() {
    //        let expectationPublishLiveStreamList = expectation(description: "Live stream list")
    //        DatabaseGateway.sharedInstance.publishNewLiveStream(with: "Test stream 2") { (newLiveStream) in
    //            expectationPublishLiveStreamList.fulfill()
    //        }
    //        waitForExpectations(timeout: 20) { (error) in
    //            print("Completed")
    //        }
    //    }
    //
    //    func testUnpublishLiveStream() {
    //        let expectationUnpublishLiveStreamList = expectation(description: "Live stream list")
    //
    //        var stream = MFMedia()
    //        stream.id = "stream2"
    //
    //        DatabaseGateway.sharedInstance.unpublishLiveStream(stream) {
    //            expectationUnpublishLiveStreamList.fulfill()
    //        }
    //        waitForExpectations(timeout: 20) { (error) in
    //            print("Completed")
    //        }
    //    }
}

// MARK: - LiveVideoGatewayAccountDetails
extension DatabaseGatewayTests {
    func testLiveVideoGatewayAccountDetail() {
        let expectationLiveVideoAccountDetails = expectation(description: "Live video account details")
        let observer = DatabaseGateway.sharedInstance.getLiveVideoGatewayAccountDetails(frequency: .realtime, { (liveVideoAccountDetails) in
            XCTAssertNotNil(liveVideoAccountDetails)
            expectationLiveVideoAccountDetails.fulfill()
        })
        waitForExpectations(timeout: 20) { (error) in
            observer?.stop()
            print("Completed")
        }
    }
    
    //    func testCreateLiveVideoGatewayAccountDetailsModel() {
    //        let rawData: [String:AnyObject] = [
    //            "hostIPAddress": "192.192.192.192" as AnyObject,
    //            "port": 100 as AnyObject,
    //            "sdkKey": "some key here" as AnyObject,
    //            "name": "name of the provider" as AnyObject
    //        ]
    //        let accountDetails: MFLiveVideoGatewayAccountDetails? = DatabaseGateway.sharedInstance.createLiveVideoGatewayAccountDetailsModel(from: rawData)
    //        XCTAssertNotNil(accountDetails)
    //        XCTAssertEqual(accountDetails!.host, rawData["hostIPAddress"] as! String)
    //        XCTAssertEqual(accountDetails!.port, Int32(rawData["port"] as! Int))
    //        XCTAssertEqual(accountDetails!.sdkKey, rawData["sdkKey"] as! String)
    //        XCTAssertEqual(accountDetails!.serviceProviderName, rawData["name"] as! String)
    //    }
}

// MARK: - Conversation
extension DatabaseGatewayTests {
    
    //    func testCreateConversation() {
    //        let expectationCreateConversation = expectation(description: "Expectation")
    //
    //        var model: MFConversation = MFConversation()
    //        model.dishRequestId?.id = "jbdsjk2332"
    //        //model.createdAt = Date()
    ////        DatabaseGateway.sharedInstance.createConversation(with: model, {newModel in
    ////            print("Conversation test passed")
    ////            expectationCreateConversation.fulfill()
    ////        })
    //
    //        waitForExpectations(timeout: 200) { (error) in
    //            print("Completed conversations")
    //        }
    //    }
}

// MARK: - Messages
extension DatabaseGatewayTests {
    
    //    func testCreateMessage() {
    //        let expectationCreateMessages = expectation(description: "Expectation")
    //
    //        var model: MFMessage = MFMessage(with: <#String#>, messagetext: <#String#>, senderId: <#String#>)
    ////        model.id = "789788tvbdgsajdgahf"
    //        model.messageText = "hai...!"
    //        model.conversationId = "233564747khjfdks"
    //        DatabaseGateway.sharedInstance.createMessage(with: model, {
    //            print("Conversation test passed")
    //            expectationCreateMessages.fulfill()
    //        })
    //        
    //        waitForExpectations(timeout: 200) { (error) in
    //            print("Completed conversations")
    //        }
    //    }
}

// MARK: - News Feed
extension DatabaseGatewayTests {
    func testNewsFeed() {
//        DatabaseGateway.sharedInstance.getNewsFeed(for: "", <#T##completion: (([MFNewsFeed]) -> Void)##(([MFNewsFeed]) -> Void)##([MFNewsFeed]) -> Void#>)
    }
}

// Media
extension DatabaseGatewayTests {
    func testLiveVideoList() {
        let e = expectation(description: "e")
        DatabaseGateway.sharedInstance.getLiveVideos { (dishes) in
            print(dishes)
            e.fulfill()
        }
        waitForExpectations(timeout: 100, handler: nil)
    }
}
