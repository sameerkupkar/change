//----------------------------------------------------
//
// Generated by www.easywsdl.com
// Version: 5.0.0.5
//
// Created by Quasar Development at 29/11/2016
//
//---------------------------------------------------


#import "SAPReportQueryOperation.h"
#import "SAPHelper.h"
#import "SAPReportRequestOperationBody.h"


@implementation SAPReportRequestOperationBody
@synthesize ReportQuery;

+ (SAPReportRequestOperationBody *)createWithXml:(DDXMLElement *)__node __request:(SAPRequestResultHandler*) __request
{
    if(__node == nil) { return nil; }
    SAPReportRequestOperationBody* obj = [[self alloc] init];
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
             if([__node.localName isEqualToString:@"ReportQuery"])
             {
                if([SAPHelper isValue:__node name:@"ReportQuery"])
                {
                    self.ReportQuery = (SAPReportQueryOperation*)[__request createObject:__node type:[SAPReportQueryOperation class]];
                }
                continue;
             }
        }
     }
}

-(void) serialize:(DDXMLElement*)__parent __request:(SAPRequestResultHandler*) __request
{

            
    DDXMLElement* __ReportQueryItemElement=[__request writeElement:ReportQuery type:[SAPReportQueryOperation class] name:@"ReportQuery" URI:@"" parent:__parent skipNullProperty:NO];
    if(__ReportQueryItemElement!=nil)
    {
        [self.ReportQuery serialize:__ReportQueryItemElement __request: __request];
    }


}
@end
