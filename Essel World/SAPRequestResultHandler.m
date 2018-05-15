//----------------------------------------------------
//
// Generated by www.easywsdl.com
// Version: 5.0.0.5
//
// Created by Quasar Development at 29/11/2016
//
//---------------------------------------------------



#import "SAPAuthenticationRealm.h"
#import "SAPAuthenticateOperationBody.h"
#import "SAPOperationRealm.h"
#import "SAPOperationError.h"
#import "SAPAuthenticateOperationResponseBody.h"
#import "SAPQueryExcursionOperation.h"
#import "SAPQueryExcursionOperationBody.h"
#import "SAPMiscellaneousCategoryInfo.h"
#import "SAPExcursionTermsAndConditions.h"
#import "SAPExcursionCancellationPolicy.h"
#import "SAPPromoDetails.h"
#import "SAPExcursionPricing.h"
#import "SAPExcursionVarriationDetails.h"
#import "SAPAdditionalInformation.h"
#import "SAPExcursionCatagoryDetails.h"
#import "SAPExcursionOperationResponse.h"
#import "SAPExcursionOperationResponseBody.h"
#import "SAPReportQueryOperation.h"
#import "SAPReportRequestOperationBody.h"
#import "SAPReportItemDetail.h"
#import "SAPReportResponse.h"
#import "SAPReportOperationResponseBody.h"
#import "SAPExcursionConfirmBookingDetailsBody.h"
#import "SAPExcursionBookingResponse.h"
#import "SAPExcursionBookingResponseBody.h"
#import "SAPCancellationDetailsBody.h"
#import "SAPCancellationResponseDetailsBody.h"
#import "SAPCustomExcursionOperation.h"
#import "SAPCustomExcursionOperationBody.h"
#import "SAPExcursionCarPickupDetails.h"
#import "SAPExcursionPaxDetails.h"
#import "SAPExcursionCatagoryDetailsBody.h"
#import "SAPCustomExcursionBookingDetailsBody.h"
#import "SAPBookingStatusOperationBody.h"
#import "SAPAuthenticateOperationResponse.h"
#import "SAPSearchOperationResponse.h"
#import "SAPReportOperationResponse.h"
#import "SAPBookingOperationResponse.h"
#import "SAPCancelOperationResponse.h"
#import "SAPSearchCustomExcursionOperationResponse.h"
#import "SAPBookCustomExcursionOperationResponse.h"
#import "SAPBookingStatusOperationResponse.h"
#import "SAPArrayOfExcursionCatagoryDetails.h"
#import "SAPArrayOfReportItemDetail.h"
#import "SAPHelper.h"
#import "SAPRequestResultHandler.h"
#import "SAPSoapError.h"


@protocol SAPSoapServiceResponse < NSObject>
- (void) onSuccess: (id) value methodName:(NSString*)methodName;
- (void) onError: (NSError*) error;
@end
@implementation SAPRequestResultHandler

@synthesize Header,Body;
@synthesize OutputHeader,OutputBody,OutputFault;
@synthesize Callback;
@synthesize EnableLogging;
static NSDictionary* classNames;

- (id) init {
    if(self = [self init:SOAPVERSION_11])
    {
    }
    return self;
}

-(id)init:(int)version {
    if ((self=[super init])) {
        soapVersion=version;
        envNS=(soapVersion==SOAPVERSION_12?@"http://www.w3.org/2003/05/soap-envelope":@"http://schemas.xmlsoap.org/soap/envelope/");
        receivedBuffer=[NSMutableData data];
        namespaces=[NSMutableDictionary dictionary];
        [self createEnvelopeXml];

        if(!classNames)
        {
            classNames = [NSDictionary dictionaryWithObjectsAndKeys:    
            [SAPAuthenticationRealm class],@"http://excursion.ws.com/Excursion/^^AuthenticationRealm",
            [SAPAuthenticateOperationBody class],@"http://excursion.ws.com/Excursion/^^AuthenticateOperationBody",
            [SAPOperationRealm class],@"http://excursion.ws.com/Excursion/^^OperationRealm",
            [SAPOperationError class],@"http://excursion.ws.com/Excursion/^^OperationError",
            [SAPAuthenticateOperationResponseBody class],@"http://excursion.ws.com/Excursion/^^AuthenticateOperationResponseBody",
            [SAPQueryExcursionOperation class],@"http://excursion.ws.com/Excursion/^^QueryExcursionOperation",
            [SAPQueryExcursionOperationBody class],@"http://excursion.ws.com/Excursion/^^QueryExcursionOperationBody",
            [SAPMiscellaneousCategoryInfo class],@"http://excursion.ws.com/Excursion/^^MiscellaneousCategoryInfo",
            [SAPExcursionTermsAndConditions class],@"http://excursion.ws.com/Excursion/^^ExcursionTermsAndConditions",
            [SAPExcursionCancellationPolicy class],@"http://excursion.ws.com/Excursion/^^ExcursionCancellationPolicy",
            [SAPPromoDetails class],@"http://excursion.ws.com/Excursion/^^PromoDetails",
            [SAPExcursionPricing class],@"http://excursion.ws.com/Excursion/^^ExcursionPricing",
            [SAPExcursionVarriationDetails class],@"http://excursion.ws.com/Excursion/^^ExcursionVarriationDetails",
            [SAPAdditionalInformation class],@"http://excursion.ws.com/Excursion/^^AdditionalInformation",
            [SAPExcursionCatagoryDetails class],@"http://excursion.ws.com/Excursion/^^ExcursionCatagoryDetails",
            [SAPExcursionOperationResponse class],@"http://excursion.ws.com/Excursion/^^ExcursionOperationResponse",
            [SAPExcursionOperationResponseBody class],@"http://excursion.ws.com/Excursion/^^ExcursionOperationResponseBody",
            [SAPReportQueryOperation class],@"http://excursion.ws.com/Excursion/^^ReportQueryOperation",
            [SAPReportRequestOperationBody class],@"http://excursion.ws.com/Excursion/^^ReportRequestOperationBody",
            [SAPReportItemDetail class],@"http://excursion.ws.com/Excursion/^^ReportItemDetail",
            [SAPReportResponse class],@"http://excursion.ws.com/Excursion/^^ReportResponse",
            [SAPReportOperationResponseBody class],@"http://excursion.ws.com/Excursion/^^ReportOperationResponseBody",
            [SAPExcursionConfirmBookingDetailsBody class],@"http://excursion.ws.com/Excursion/^^ExcursionConfirmBookingDetailsBody",
            [SAPExcursionBookingResponse class],@"http://excursion.ws.com/Excursion/^^ExcursionBookingResponse",
            [SAPExcursionBookingResponseBody class],@"http://excursion.ws.com/Excursion/^^ExcursionBookingResponseBody",
            [SAPCancellationDetailsBody class],@"http://excursion.ws.com/Excursion/^^CancellationDetailsBody",
            [SAPCancellationResponseDetailsBody class],@"http://excursion.ws.com/Excursion/^^CancellationResponseDetailsBody",
            [SAPCustomExcursionOperation class],@"http://excursion.ws.com/Excursion/^^CustomExcursionOperation",
            [SAPCustomExcursionOperationBody class],@"http://excursion.ws.com/Excursion/^^CustomExcursionOperationBody",
            [SAPExcursionCarPickupDetails class],@"http://excursion.ws.com/Excursion/^^ExcursionCarPickupDetails",
            [SAPExcursionPaxDetails class],@"http://excursion.ws.com/Excursion/^^ExcursionPaxDetails",
            [SAPExcursionCatagoryDetailsBody class],@"http://excursion.ws.com/Excursion/^^ExcursionCatagoryDetailsBody",
            [SAPCustomExcursionBookingDetailsBody class],@"http://excursion.ws.com/Excursion/^^CustomExcursionBookingDetailsBody",
            [SAPBookingStatusOperationBody class],@"http://excursion.ws.com/Excursion/^^BookingStatusOperationBody",
            [SAPAuthenticateOperationResponse class],@"http://excursion.ws.com/Excursion/^^AuthenticateOperationResponse",
            [SAPSearchOperationResponse class],@"http://excursion.ws.com/Excursion/^^SearchOperationResponse",
            [SAPReportOperationResponse class],@"http://excursion.ws.com/Excursion/^^ReportOperationResponse",
            [SAPBookingOperationResponse class],@"http://excursion.ws.com/Excursion/^^BookingOperationResponse",
            [SAPCancelOperationResponse class],@"http://excursion.ws.com/Excursion/^^CancelOperationResponse",
            [SAPSearchCustomExcursionOperationResponse class],@"http://excursion.ws.com/Excursion/^^SearchCustomExcursionOperationResponse",
            [SAPBookCustomExcursionOperationResponse class],@"http://excursion.ws.com/Excursion/^^BookCustomExcursionOperationResponse",
            [SAPBookingStatusOperationResponse class],@"http://excursion.ws.com/Excursion/^^BookingStatusOperationResponse",
            [SAPArrayOfExcursionCatagoryDetails class],@"http://excursion.ws.com/Excursion/^^ArrayOfExcursionCatagoryDetails",
            [SAPArrayOfReportItemDetail class],@"http://excursion.ws.com/Excursion/^^ArrayOfReportItemDetail",
            nil]; 

        }
    }
    return self;
}

    
-(NSString*) getEnvelopeString
{
    return [[xml rootElement] XMLString];
}

-(DDXMLDocument*) createEnvelopeXml
{
    NSString *envelope=nil;
    if(soapVersion==SOAPVERSION_12)
    {
        envelope = [NSString stringWithFormat:@"<soap:Envelope xmlns:c=\"http://www.w3.org/2003/05/soap-encoding\" xmlns:soap=\"%@\"></soap:Envelope>",envNS];
    }
    else
    {
        envelope = [NSString stringWithFormat:@"<soap:Envelope xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:soap=\"%@\"></soap:Envelope>",envNS];
    }
    
    xml = [[DDXMLDocument alloc] initWithXMLString:envelope options:0 error:nil];
    
    DDXMLElement *root=[xml rootElement];
    Header=[[DDXMLElement alloc] initWithName:@"soap:Header"];
    Body=[[DDXMLElement alloc] initWithName:@"soap:Body"];
    [root addChild:Header];
    [root addChild:Body];
    return xml;
}

-(id)createObject: (DDXMLElement*) node type:(Class) type
{
    
    DDXMLNode* nilAttr=[SAPHelper getAttribute:node name:@"nil" url:XSI];
    if(nilAttr!=nil && [[nilAttr stringValue]boolValue])
    {
        return nil;
    }

    DDXMLNode* typeAttr=[SAPHelper getAttribute:node name:@"type" url:XSI];
    if(typeAttr !=nil)
    {
        NSString* attrValue=[typeAttr stringValue];
        NSArray* splitString=[attrValue componentsSeparatedByString:@":"];
        DDXMLNode* namespace=[node resolveNamespaceForName:attrValue];
        NSString* typeName=[splitString count]==2?[splitString objectAtIndex:1]:attrValue;
        if(namespace!=nil)
        {
            NSString* classType=[NSString stringWithFormat:@"%@^^%@",[namespace stringValue],typeName];
            Class temp=[classNames objectForKey: classType];
            if(temp!=nil)
            {
                type=temp;
            }
        }
    }

    DDXMLNode* hrefAttr=[SAPHelper getAttribute:node name:@"href" url:@""];
    if(hrefAttr==nil)
    {
        hrefAttr=[SAPHelper getAttribute:node name:@"ref" url:@""];
    }
    if(hrefAttr!=nil)
    {
        NSString* hrefId=[[hrefAttr stringValue] substringFromIndex:1];
        NSString* xpathQuery=[NSString stringWithFormat:@"//*[@id='%@']",hrefId];
        NSArray *nodes=[node.rootDocument nodesForXPath:xpathQuery error:nil];

        if([nodes count]>0)
        {
            node=[nodes objectAtIndex:0];
        }
    }

    id obj=[self createInstance:type node:node request:self];
   
    return obj;
}


-(id) createInstance:(Class) type node: (DDXMLElement*)node request :(SAPRequestResultHandler *)request
{
    SEL initSelector=@selector(loadWithXml:__request:);
    id allocObj=[[type alloc] init];


    IMP imp = [allocObj methodForSelector:initSelector];
    void (*func)(id, SEL, DDXMLNode*, SAPRequestResultHandler *) = (void *)imp;
    func(allocObj, initSelector, node, self);
    return allocObj;
}

-(NSString*) getNamespacePrefix:(NSString*) url propertyElement:(DDXMLElement*) propertyElement
{
    if([url length]==0)
    {
        return nil;
    }
    DDXMLElement* rootElement= [[propertyElement rootDocument] rootElement];
    NSString* prefix= [namespaces valueForKey:url];
    if(prefix==nil)
    {
        prefix=[NSString stringWithFormat:@"n%u",[namespaces count]+1];
        DDXMLNode* ns=[DDXMLNode namespaceWithName:prefix stringValue:url];
        [rootElement addNamespace:ns];
        [namespaces setValue:prefix forKey:url];
    }
    return prefix;
}
        
-(NSString*) getXmlFullName:(NSString*) name URI:(NSString*) URI propertyElement:(DDXMLElement*) propertyElement
{
    NSString *prefix=[self getNamespacePrefix:URI propertyElement:propertyElement];
    NSString *fullname=name;
    if(prefix!=nil)
    {
        fullname=[NSString stringWithFormat:@"%@:%@",prefix,name];
    }
    return fullname;
}
    
-(DDXMLNode*) addAttribute:(NSString*) name URI:(NSString*) URI stringValue:(NSString*) stringValue element:(DDXMLElement*) element
{
    NSString *fullname=[self getXmlFullName:name URI:URI propertyElement:element];
    DDXMLNode *refAttr=[DDXMLNode attributeWithName:fullname stringValue:stringValue];
    [element addAttribute:refAttr];
    return refAttr;
}

-(DDXMLElement*) writeElement:(NSString*)name URI: (NSString*) URI parent:(DDXMLElement*) parent
{
    NSString *fullname=[self getXmlFullName:name URI:URI propertyElement:parent];
    DDXMLElement* propertyElement=[[DDXMLElement alloc] initWithName:fullname];
    [parent addChild:propertyElement];
    return propertyElement;
}


-(DDXMLElement*) writeElement:(id)obj type:(Class)type name: (NSString*)name URI: (NSString*) URI parent:(DDXMLElement*) parent skipNullProperty:(BOOL)skipNullProperty
{
    if(obj==nil && skipNullProperty)
    {
        return nil;
    }
    DDXMLElement* propertyElement=[self writeElement:name URI:URI parent:parent];
    
    if(obj==nil)
    {
        [self addAttribute:@"nil" URI:XSI stringValue:@"true" element:propertyElement];
        return nil;
    }

    Class currentType=[obj class];
    if(currentType!=type)
    {
        NSString* xmlType=(NSString*)[[classNames allKeysForObject:currentType] lastObject];//add namespace?
        if(xmlType!=nil)
        {
            
            NSArray* splitType=[xmlType componentsSeparatedByString:@"^^"];
            NSString *fullname=[self getXmlFullName:[splitType objectAtIndex:1] URI:[splitType objectAtIndex:0] propertyElement:propertyElement];
            [self addAttribute:@"type" URI:XSI stringValue:fullname element:propertyElement];
        }
        
    }
    return propertyElement;
}


        
-(void)setResponse:(NSData *)responseData response:(NSURLResponse*) response
{
    if(self.EnableLogging) {
        NSString* strResponse = [[NSString alloc] initWithData: responseData encoding: NSUTF8StringEncoding];
        NSLog(@"%@\n", strResponse);
    }
    DDXMLDocument *__doc=[[DDXMLDocument alloc] initWithData:responseData options:0 error:nil];
    DDXMLElement *__root=[__doc rootElement];
    if(__root==nil)
    {
        NSString* errorMessage=[[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding ];
        OutputFault=[NSError  errorWithDomain:errorMessage code:0 userInfo:nil];
        return;
    }
    OutputBody=[SAPHelper getNode:__root  name:@"Body" URI:envNS];
    OutputHeader=[SAPHelper getNode:__root  name:@"Header" URI:envNS];
    DDXMLElement* fault=[SAPHelper getNode:OutputBody  name:@"Fault" URI:envNS];
    if(fault!=nil)
    {
        DDXMLElement* faultString=[SAPHelper getNode:fault name:@"faultstring"];
        if(faultString == nil)
        {
            faultString=[SAPHelper getNode:fault name:@"Reason"];
            if(faultString!=nil)
            {
                faultString = [SAPHelper getNode:faultString name:@"Text"];
            }
        }
        id faultObj=nil;
        DDXMLElement* faultDetail=[SAPHelper getNode:fault name:@"detail"];
        if(faultDetail!=nil)
        {
            DDXMLElement* faultClass=(DDXMLElement*)[faultDetail childAtIndex:0];
            if(faultClass!=nil)
            {
                NSString * typeName=[faultClass localName];
                DDXMLNode* namespaceNode=[faultClass resolveNamespaceForName:typeName];
                NSString* namespace=nil;
                if(namespaceNode==nil)
                {
                    namespace=[faultClass URI];
                }
                else
                {
                    namespace=[namespaceNode stringValue];
                }
                NSString* classType=[NSString stringWithFormat:@"%@^^%@",namespace,typeName];
                Class temp=[classNames objectForKey: classType];
                if(temp!=nil)
                {
                    faultObj= [self createInstance:temp node:faultClass request:self];
                }
            }
        }
        
        OutputFault=[[SAPSoapError alloc] initWithDetails:[faultString stringValue] details:faultObj];
    }
}

-(void) sendImplementation:(NSMutableURLRequest*) request
{
    if(self.EnableLogging) {
        NSString* strRequest = [[NSString alloc] initWithData: request.HTTPBody encoding: NSUTF8StringEncoding];
        NSLog(@"%@\n", strRequest);
    }
    
    NSURLResponse* response;
    NSError* innerError;

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&innerError];
#pragma GCC diagnostic pop

    if(data==nil)
    {
        OutputFault = innerError;
    }
    else
    {
        [self setResponse:data response:response];
    }
}

-(void) sendImplementation:(NSMutableURLRequest*) request callbackDelegate:(SAPCLB) callbackDelegate
{
    if(self.EnableLogging) {
        NSString* strRequest = [[NSString alloc] initWithData: request.HTTPBody encoding: NSUTF8StringEncoding];
        NSLog(@"%@\n", strRequest);
    }
    self.Callback=callbackDelegate;
    connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

- (void)connection:(NSURLConnection *)connectionParam didReceiveResponse:(NSURLResponse *)response {
    [receivedBuffer setLength:0];
    responseObj=response;
}

- (void)connection:(NSURLConnection *)connectionParam didReceiveData:(NSData *)value {
    [receivedBuffer appendData:value];
}

- (void)connection:(NSURLConnection *)connectionParam didFailWithError:(NSError *)error {
    OutputFault=error;
    self.Callback(self);
    connection = nil;
    self.Callback=nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connectionParam {
	connection = nil;
    [self setResponse:receivedBuffer response:responseObj];
    self.Callback(self);
    self.Callback=nil;
}

-(void)connection:(NSURLConnection *)connectionParam didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
}

-(void)Cancel
{
    if(connection!=nil)
    {
        [connection cancel];
        connection=nil;
        self.Callback=nil;
    }
}

-(void) prepareRequest:(NSMutableURLRequest*)__requestObj
{
    NSData *__soapMessageData=nil;
    {
        __soapMessageData=[[self getEnvelopeString] dataUsingEncoding:NSUTF8StringEncoding];
        [__requestObj addValue: soapVersion==SOAPVERSION_12?@"application/soap+xml; charset=utf-8":@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    }

    NSString *msgLength = [NSString stringWithFormat:@"%u", [__soapMessageData length]];
    [__requestObj addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [__requestObj setHTTPBody: __soapMessageData];
}
 



@end
