//
//  MigrationChainTests.swift
//  CoreStore
//
//  Copyright © 2016 John Rommel Estropia
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import XCTest

@testable
import CoreStore

class MigrationChainTests: XCTestCase {
    
    @objc dynamic func testEmptyChain() {
        
        let chain: MigrationChain = nil
        XCTAssertTrue(chain.valid)
        XCTAssertTrue(chain.empty)
        
        XCTAssertFalse(chain.contains("version1"))
        XCTAssertNil(chain.nextVersionFrom("version1"))
    }
    
    @objc dynamic func testSingleChain() {
        
        let chain: MigrationChain = "version1"
        XCTAssertTrue(chain.valid)
        XCTAssertTrue(chain.empty)
        
        XCTAssertTrue(chain.contains("version1"))
        XCTAssertFalse(chain.contains("version2"))
        
        XCTAssertNil(chain.nextVersionFrom("version1"))
        XCTAssertNil(chain.nextVersionFrom("version2"))
    }
    
    @objc dynamic func testLinearChain() {
        
        let chain: MigrationChain = ["version1", "version2", "version3", "version4"]
        XCTAssertTrue(chain.valid)
        XCTAssertFalse(chain.empty)
        
        XCTAssertTrue(chain.contains("version1"))
        XCTAssertTrue(chain.contains("version2"))
        XCTAssertTrue(chain.contains("version3"))
        XCTAssertTrue(chain.contains("version4"))
        XCTAssertFalse(chain.contains("version5"))
        
        XCTAssertEqual(chain.nextVersionFrom("version1"), "version2")
        XCTAssertEqual(chain.nextVersionFrom("version2"), "version3")
        XCTAssertEqual(chain.nextVersionFrom("version3"), "version4")
        XCTAssertNil(chain.nextVersionFrom("version4"))
        XCTAssertNil(chain.nextVersionFrom("version5"))
    }
    
    @objc dynamic func testTreeChain() {
        
        let chain: MigrationChain = [
            "version1": "version4",
            "version2": "version3",
            "version3": "version4"
        ]
        XCTAssertTrue(chain.valid)
        XCTAssertFalse(chain.empty)
        
        XCTAssertTrue(chain.contains("version1"))
        XCTAssertTrue(chain.contains("version2"))
        XCTAssertTrue(chain.contains("version3"))
        XCTAssertTrue(chain.contains("version4"))
        XCTAssertFalse(chain.contains("version5"))
        
        XCTAssertEqual(chain.nextVersionFrom("version1"), "version4")
        XCTAssertEqual(chain.nextVersionFrom("version2"), "version3")
        XCTAssertEqual(chain.nextVersionFrom("version3"), "version4")
        XCTAssertNil(chain.nextVersionFrom("version4"))
        XCTAssertNil(chain.nextVersionFrom("version5"))
        
        // The cases below will trigger assertion failures internally
        
        //        let linearLoopChain: MigrationChain = ["version1", "version2", "version1", "version3", "version4"]
        //        XCTAssertFalse(linearLoopChain.valid, "linearLoopChain.valid")
        //
        //        let treeAmbiguousChain: MigrationChain = [
        //            "version1": "version4",
        //            "version2": "version3",
        //            "version1": "version2",
        //            "version3": "version4"
        //        ]
        //        XCTAssertFalse(treeAmbiguousChain.valid, "treeAmbiguousChain.valid")
    }
}