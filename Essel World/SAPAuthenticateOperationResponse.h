//----------------------------------------------------
//
// Generated by www.easywsdl.com
// Version: 5.0.0.5
//
// Created by Quasar Development at 29/11/2016
//
//---------------------------------------------------


#import <Foundation/Foundation.h>

@class SAPOperationRealm;
@class SAPAuthenticateOperationResponseBody;
#import "SAPRequestResultHandler.h"
#import "DDXML.h"



@interface SAPAuthenticateOperationResponse : NSObject <SAPISerializableObject>


@property (retain,nonatomic,getter=getHeader) SAPOperationRealm* Header;

@property (retain,nonatomic,getter=getBody) SAPAuthenticateOperationResponseBody* Body;
-(id)init;
-(void)loadWithXml: (DDXMLElement*)__node __request:(SAPRequestResultHandler*) __request;
+(SAPAuthenticateOperationResponse*) createWithXml:(DDXMLElement*)__node __request:(SAPRequestResultHandler*) __request;
-(void) serialize:(DDXMLElement*)__parent __request:(SAPRequestResultHandler*) __request;
@end