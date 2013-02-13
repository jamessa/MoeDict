//
//  MoeDictTests.m
//  MoeDictTests
//
//  Created by jamie on 2/12/13.
//  Copyright (c) 2013 jamie. All rights reserved.
//

#import "MoeDictTests.h"
#import "MDReferenceLibraryViewController.h"

@interface MDReferenceLibraryViewController (UnitTesting)

-(NSString *)renderWithDictionary:(NSDictionary *)entry;

@end

@implementation MoeDictTests

- (id)loadDataFile: (NSString *)fileString {
  NSString *filePath = [[NSBundle bundleForClass:[self class]]
                        pathForResource:fileString
                        ofType:@"json"];
  
  NSData *inputData = [NSData dataWithContentsOfFile:filePath];
  return [NSJSONSerialization
          JSONObjectWithData:inputData
          options:(NSJSONReadingOptions)0
          error:nil];
}

- (void)setUp
{
  [super setUp];
  
  // Set-up code here.
}

- (void)tearDown
{
  // Tear-down code here.
  
  [super tearDown];
}

- (void)testRenderHTMLfromJSON
{
  NSDictionary *dict = [self loadDataFile:@"Response"];
  
  MDReferenceLibraryViewController *referenceViewControler = [[MDReferenceLibraryViewController alloc] init];
  NSString *html = [referenceViewControler renderWithDictionary:dict];
  
  STAssertEquals(html, @"<html></htm>", nil);
}

@end
