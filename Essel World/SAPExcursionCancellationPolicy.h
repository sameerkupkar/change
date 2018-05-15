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



@interface SAPExcursionCancellationPolicy : NSObject <SAPISerializableObject>


@property (retain,nonatomic,getter=getHours) NSString* Hours;

@property (retain,nonatomic,getter=getCharges) NSString* Charges;

@property (retain,nonatomic,getter=getPolicy) NSString* Policy;
-(id)init;
-(void)loadWithXml: (DDXMLElement*)__node __request:(SAPRequestResultHandler*) __request;
+(SAPExcursionCancellationPolicy*) createWithXml:(DDXMLElement*)__node __request:(SAPRequestResultHandler*) __request;
-(void) serialize:(DDXMLElement*)__parent __request:(SAPRequestResultHandler*) __request;
@end