
#import "TestHelpers.h"

NSData *(^LoadDataFromXML)(NSString *, Class) = ^NSData *(NSString *fileName, Class class)
{
    NSBundle *bundle = [NSBundle bundleForClass:class];
    NSString *filePath = [bundle pathForResource:fileName ofType:@"xml"];
    return [NSData dataWithContentsOfFile:filePath];
};
