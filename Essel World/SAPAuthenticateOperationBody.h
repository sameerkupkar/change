//----------------------------------------------------
//
// Generated by www.easywsdl.com
// Version: 5.0.0.5
//
// Created by Quasar Development at 29/11/2016
//
//---------------------------------------------------


#import <Foundation/Foundation.h>

#import "SAPRequestResultHandler.h"
#import "DDXML.h"



@interface SAPAuthenticateOperationBody : NSObject <SAPISerializableObject>


@property (retain,nonatomic,getter=getUserName) NSString* userName;

@property (retain,nonatomic,getter=getPassword) NSString* password;

@property (retain,nonatomic,getter=getCID) NSString* CID;
-(id)init;
-(void)loadWithXml: (DDXMLElement*)__node __request:(SAPRequestResultHandler*) __request;
+(SAPAuthenticateOperationBody*) createWithXml:(DDXMLElement*)__node __request:(SAPRequestResultHandler*) __request;
-(void) serialize:(DDXMLElement*)__parent __request:(SAPRequestResultHandler*) __request;
@end