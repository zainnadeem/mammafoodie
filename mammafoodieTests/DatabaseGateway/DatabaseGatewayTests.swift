import XCTest
@testable import mammafoodie

class DatabaseGatewayTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}

// MARK: - Live streams
extension DatabaseGatewayTests {
    
    func testGetStreamWithId() {
        let expectationGetLiveStreamList = expectation(description: "Live stream list")
        DatabaseGateway.sharedInstance.getLiveStream(with: "stream1", { (liveStream) in
            print(liveStream?.name ?? "Akshit")
            expectationGetLiveStreamList.fulfill()
        })
        waitForExpectations(timeout: 20) { (error) in
            print("Completed")
        }
    }
    
    func testLiveStreamsList() {
        let expectationLiveStreamList = expectation(description: "Live stream list")
        DatabaseGateway.sharedInstance.getLiveStreams { (liveStreams) in
            print(liveStreams.first?.name ?? "Name")
            expectationLiveStreamList.fulfill()
        }
        waitForExpectations(timeout: 20) { (error) in
            print("Completed")
        }
    }
    
    func testCreateLiveStreamModel() {
        let streamName: String = "streamTest"
        let streamId: String = "testId"
        let liveStream: MFLiveStream? = DatabaseGateway.sharedInstance.createLiveStreamModel(from: streamName, id: streamId)
        XCTAssertEqual(streamName, liveStream?.name)
        XCTAssertEqual(streamId, liveStream?.id)
    }
    
    func testPublishLiveStream() {
        let expectationPublishLiveStreamList = expectation(description: "Live stream list")
        DatabaseGateway.sharedInstance.publishNewLiveStream(with: "Test stream 2") { (newLiveStream) in
            expectationPublishLiveStreamList.fulfill()
        }
        waitForExpectations(timeout: 20) { (error) in
            print("Completed")
        }
    }
    
    func testUnpublishLiveStream() {
        let expectationUnpublishLiveStreamList = expectation(description: "Live stream list")
        
        var stream = MFLiveStream()
        stream.id = "stream2"
        
        DatabaseGateway.sharedInstance.unpublishLiveStream(stream) {
            expectationUnpublishLiveStreamList.fulfill()
        }
        waitForExpectations(timeout: 20) { (error) in
            print("Completed")
        }
    }
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
    
    func testCreateLiveVideoGatewayAccountDetailsModel() {
        let rawData: [String:AnyObject] = [
            "hostIPAddress": "192.192.192.192" as AnyObject,
            "port": 100 as AnyObject,
            "sdkKey": "some key here" as AnyObject,
            "name": "name of the provider" as AnyObject
        ]
        let accountDetails: MFLiveVideoGatewayAccountDetails? = DatabaseGateway.sharedInstance.createLiveVideoGatewayAccountDetailsModel(from: rawData)
        XCTAssertNotNil(accountDetails)
        XCTAssertEqual(accountDetails!.host, rawData["hostIPAddress"] as! String)
        XCTAssertEqual(accountDetails!.port, rawData["port"] as! Int)
        XCTAssertEqual(accountDetails!.sdkKey, rawData["sdkKey"] as! String)
        XCTAssertEqual(accountDetails!.serviceProviderName, rawData["name"] as! String)
    }
}

// MARK: -
extension DatabaseGatewayTests {
    
}
