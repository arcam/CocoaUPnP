
#import <Foundation/Foundation.h>

/**
 *  Load test XML data files
 *
 *  @param NSString Filename without file extension
 *  @param Class    The current class
 *
 *  @return Returns `NSData` with contents of file
 */
NSData *(^LoadDataFromXML)(NSString *, Class);
