//----------------------------------------------------
//
// Generated by www.easywsdl.com
// Version: 5.0.0.5
//
// Created by Quasar Development at 29/11/2016
//
//---------------------------------------------------


#import "SAPExcursionOperationResponse.h"
#import "SAPOperationError.h"
#import "SAPHelper.h"
#import "SAPExcursionOperationResponseBody.h"


@implementation SAPExcursionOperationResponseBody
@synthesize ExcursionItemResponse;
@synthesize StatusCode;
@synthesize StatusText;
@synthesize Error;

+ (SAPExcursionOperationResponseBody *)createWithXml:(DDXMLElement *)__node __request:(SAPRequestResultHandler*) __request
{
    if(__node == nil) { return nil; }
    SAPExcursionOperationResponseBody* obj = [[self alloc] init];
    [obj loadWithXml: __node __request:__request];
    return obj;
}

-(id)init {
    if ((self=[super init])) {
    }
    return self;
}

- (void) loadWithXml: (DDXMLElement*) __node __request:(SAPRequestResultHandler*) __request{
    DDXMLNode* node=__node;
    for(int i=0;i< node.childCount;i++)
    {
        DDXMLNode* node=[__node childAtIndex:i];
        if(node.kind==DDXMLElementKind)
        {
            DDXMLElement* __node=(DDXMLElement*)node;
             if([__node.localName isEqualToString:@"ExcursionItemResponse"])
             {
                if([SAPHelper isValue:__node name:@"ExcursionItemResponse"])
                {
                    self.ExcursionItemResponse = (SAPExcursionOperationResponse*)[__request createObject:__node type:[SAPExcursionOperationResponse class]];
                }
                continue;
             }
             if([__node.localName isEqualToString:@"StatusCode"])
             {
                if([SAPHelper isValue:__node name:@"StatusCode"])
                {
                    self.StatusCode = [__node stringValue];
                }
                continue;
             }
             if([__node.localName isEqualToString:@"StatusText"])
             {
                if([SAPHelper isValue:__node name:@"StatusText"])
                {
                    self.StatusText = [__node stringValue];
                }
                continue;
             }
             if([__node.localName isEqualToString:@"Error"])
             {
                if([SAPHelper isValue:__node name:@"Error"])
                {
                    self.Error = (SAPOperationError*)[__request createObject:__node type:[SAPOperationError class]];
                }
                continue;
             }
        }
     }
}

-(void) serialize:(DDXMLElement*)__parent __request:(SAPRequestResultHandler*) __request
{

            
    DDXMLElement* __ExcursionItemResponseItemElement=[__request writeElement:ExcursionItemResponse type:[SAPExcursionOperationResponse class] name:@"ExcursionItemResponse" URI:@"" parent:__parent skipNullProperty:YES];
    if(__ExcursionItemResponseItemElement!=nil)
    {
        [self.ExcursionItemResponse serialize:__ExcursionItemResponseItemElement __request: __request];
    }
            
    DDXMLElement* __StatusCodeItemElement=[__request writeElement:StatusCode type:[NSString class] name:@"StatusCode" URI:@"" parent:__parent skipNullProperty:NO];
    if(__StatusCodeItemElement!=nil)
    {
        [__StatusCodeItemElement setStringValue:self.StatusCode];
    }
            
    DDXMLElement* __StatusTextItemElement=[__request writeElement:StatusText type:[NSString class] name:@"StatusText" URI:@"" parent:__parent skipNullProperty:NO];
    if(__StatusTextItemElement!=nil)
    {
        [__StatusTextItemElement setStringValue:self.StatusText];
    }
            
    DDXMLElement* __ErrorItemElement=[__request writeElement:Error type:[SAPOperationError class] name:@"Error" URI:@"" parent:__parent skipNullProperty:YES];
    if(__ErrorItemElement!=nil)
    {
        [self.Error serialize:__ErrorItemElement __request: __request];
    }


}
@end
