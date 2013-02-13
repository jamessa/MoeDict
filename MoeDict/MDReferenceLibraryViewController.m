//
//  MDReferenceLibraryViewController.m
//  MoeDict
//
//  Created by jamie on 2/12/13.
//  Copyright (c) 2013 jamie. All rights reserved.
//

#import "MDReferenceLibraryViewController.h"

@interface MDReferenceLibraryViewController () <UIWebViewDelegate, NSURLConnectionDataDelegate>{
  NSString *term;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation MDReferenceLibraryViewController

- (id)initWithTerm:(NSString *)aTerm {
  self = [super init];
  if (self) {
    term = aTerm;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  NSString *api = @"http://www.moedict.tw/uni/";
  NSString *encoded = [api stringByAppendingString:[term stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
  
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:encoded]];
  NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.webView.scrollView.bounces = NO;
  self.webView.backgroundColor = [UIColor clearColor]; // [UIColor colorWithRed:0.95 green:0.93 blue:0.89 alpha:1.0];
  self.webView.opaque = NO;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)handleDone:(id)sender {
  [self dismissViewControllerAnimated:YES completion:^{
    //no op
  }];
}

#pragma mark - NSURLConnectionDataDelegate

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  
  
  NSError *error;
  NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
  
  NSLog(@"%@", dictionary);
  
  NSString *path = [[NSBundle mainBundle] bundlePath];
  NSURL *baseURL = [NSURL fileURLWithPath:path];
  [self.webView loadHTMLString:[self renderWithDictionary:dictionary] baseURL:baseURL];
}

#pragma mark - Private

- (NSString *)renderWithDictionary:(NSDictionary *)entry {
  NSError *error;
  NSString *templatePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"header" ofType:@"html"];
  
  NSMutableString *result = [NSMutableString stringWithContentsOfFile:templatePath encoding:NSUTF8StringEncoding error:&error];
  
  NSMutableString *body = [[NSMutableString alloc] init];
  [body appendFormat:@"<d:entry d:title=\"%@\">", entry[@"title"]];
  for (NSDictionary *heteronyms in entry[@"heteronyms"]) {
    [body appendFormat:@"<span class=\"hw\">%@</span>", entry[@"title"]];
    [body appendFormat:@"<span class=\"pr\">&nbsp;%@</span>", heteronyms[@"bopomofo"]];
    [body appendString:@"<div><ol>"];
    
    for (NSDictionary *definition in heteronyms[@"definitions"]) {
      NSString *type = (definition[@"type"])?definition[@"type"]:@"";
      NSString *def = (definition[@"def"])?definition[@"def"]:@"";
      NSString *examples = (definition[@"example"])?[definition[@"example"] componentsJoinedByString:@"。"]:@"";
      NSString *quotes = (definition[@"quote"])?[definition[@"quote"] componentsJoinedByString:@"。"]:@"";
      NSString *links = (definition[@"link"])?[definition[@"link"] componentsJoinedByString:@"。"]:@"";
      
      [body appendFormat:@"<li><span class=\"part-of-speech\">%@</span><span class=\"definition\">%@%@%@%@</span></li>", type, def, examples, quotes, links];
    }
    
    [body appendString:@"</ol></div>"];
  }
  [body appendString:@"</d:entry>"];
  
  [result replaceOccurrencesOfString:@"%BODY%"
                          withString:body
                             options:NSLiteralSearch
                               range:NSMakeRange(0, [result length])];
  
  return result;
}
@end
