//----------------------------------------------------
//
// Generated by www.easywsdl.com
// Version: 5.0.0.5
//
// Created by Quasar Development at 29/11/2016
//
//---------------------------------------------------


#import <Foundation/Foundation.h>
#import "DDXML.h"
@protocol SAPIReferenceObject
@end
    
@class SAPRequestResultHandler;
typedef void (^SAPCLB)(SAPRequestResultHandler *);

#define SOAPVERSION_10      1
#define SOAPVERSION_11      2
#define SOAPVERSION_12      3

@interface SAPRequestResultHandler : NSObject
{
    NSMutableData* receivedBuffer;
    NSURLConnection* connection;
    NSURLResponse* responseObj;
    NSMutableDictionary* namespaces;
    DDXMLDocument *xml;
    int soapVersion;
    NSString* envNS;
}
@property BOOL EnableLogging;
@property (retain, nonatomic) DDXMLElement* Body;
@property (retain, nonatomic) DDXMLElement* Header;    
@property (retain, nonatomic) DDXMLElement* OutputHeader;
@property (retain, nonatomic) DDXMLElement* OutputBody;
@property (retain, nonatomic) NSError* OutputFault;
@property (nonatomic,copy) SAPCLB Callback;

-(id) init;
-(id)init:(int) version;
-(id)createObject: (DDXMLElement*) node type:(Class) type;
-(NSString*) getEnvelopeString;
-(DDXMLDocument*) createEnvelopeXml;
-(id) createInstance:(Class) type node: (DDXMLElement*)node request :(SAPRequestResultHandler *)request;
-(DDXMLElement*) writeElement:(NSString*)name URI: (NSString*) URI parent:(DDXMLElement*) parent;
-(DDXMLElement*) writeElement:(id)obj type:(Class)type name: (NSString*)name URI: (NSString*) URI parent:(DDXMLElement*) parent skipNullProperty:(BOOL)skipNullProperty;
-(DDXMLNode*) addAttribute:(NSString*) name URI:(NSString*) URI stringValue:(NSString*) stringValue element:(DDXMLElement*) element;
-(void)setResponse:(NSData *)responseData response:(NSURLResponse*) response;
-(void) sendImplementation:(NSMutableURLRequest*) request callbackDelegate:(SAPCLB) callbackDelegate;
-(void)Cancel;    
-(void) sendImplementation:(NSMutableURLRequest*) request;

-(void) prepareRequest:(NSMutableURLRequest*)request;
@end

@protocol SAPISerializableObject
-(void) serialize:(DDXMLElement*)__parent __request:(SAPRequestResultHandler*) __request;
@end

@protocol SAPSoapServiceResponse < NSObject>
- (void) onSuccess: (id) value methodName:(NSString*)methodName;
- (void) onError: (NSError*) error;
@end
