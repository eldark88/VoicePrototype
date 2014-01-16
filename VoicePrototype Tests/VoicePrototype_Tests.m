//
//  VoicePrototype_Tests.m
//  VoicePrototype Tests
//
//  Created by Eldar Khalyknazarov on 1/16/14.
//  Copyright (c) 2014 FlowTelligent. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface VoicePrototype_Tests : XCTestCase

@end

@implementation VoicePrototype_Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testTrue
{
    XCTAssertTrue(true, @"true is true");
}

- (void)testFalse
{
    XCTAssertFalse(false, @"false is false");
}

@end
