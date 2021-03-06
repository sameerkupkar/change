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



@interface SAPBookingStatusOperationBody : NSObject <SAPISerializableObject>


@property (retain,nonatomic,getter=getBookingReferenceId) NSString* BookingReferenceId;
-(id)init;
-(void)loadWithXml: (DDXMLElement*)__node __request:(SAPRequestResultHandler*) __request;
+(SAPBookingStatusOperationBody*) createWithXml:(DDXMLElement*)__node __request:(SAPRequestResultHandler*) __request;
-(void) serialize:(DDXMLElement*)__parent __request:(SAPRequestResultHandler*) __request;
@end