//
//  3Des.m
//  test
//
//  Created by asiainfo-linkage on 11-3-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "3Des.h"
#import "GTMBase64.h"

#define FBENCRYPT_ALGORITHM     kCCAlgorithmAES128
#define FBENCRYPT_BLOCK_SIZE    kCCBlockSizeAES128
#define FBENCRYPT_KEY_SIZE      kCCKeySizeAES128


@implementation _Des

+ (NSString *)hexStringFromString:(NSData *)data{
    NSData *myD = data;
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

+ (NSString*)AES128Encrypt:(NSString *)plainText;
{
    NSData* result = nil;
    
    NSData * data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSData * key = [AESKey dataUsingEncoding:NSUTF8StringEncoding];
    NSData * iv = [AESIV dataUsingEncoding:NSUTF8StringEncoding];
    // setup key
    unsigned char cKey[FBENCRYPT_KEY_SIZE];
    bzero(cKey, sizeof(cKey));
    [key getBytes:cKey length:FBENCRYPT_KEY_SIZE];
    
    // setup iv
    char cIv[FBENCRYPT_BLOCK_SIZE];
    bzero(cIv, FBENCRYPT_BLOCK_SIZE);
    if (iv) {
        [iv getBytes:cIv length:FBENCRYPT_BLOCK_SIZE];
    }
    
    // setup output buffer
    size_t bufferSize = [data length] + FBENCRYPT_BLOCK_SIZE;
    void *buffer = malloc(bufferSize);
    
    // do encrypt
    size_t encryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          FBENCRYPT_ALGORITHM,
                                          kCCOptionPKCS7Padding,
                                          cKey,
                                          FBENCRYPT_KEY_SIZE,
                                          cIv,
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &encryptedSize);
    if (cryptStatus == kCCSuccess) {
        result = [NSData dataWithBytesNoCopy:buffer length:encryptedSize];
        //return [GTMBase64 stringByEncodingData:result];
        return  [self hexStringFromString:result];
    } else {
        free(buffer);
        NSLog(@"[ERROR] failed to encrypt|CCCryptoStatus: %d", cryptStatus);
    }
    
    return nil;
}


+ (NSString *)AES128Decrypt:(NSString *)encryptText;
{
    NSData * data = [GTMBase64 decodeData:[encryptText dataUsingEncoding:NSUTF8StringEncoding]];
    NSData * key = [AESKey dataUsingEncoding:NSUTF8StringEncoding];
    NSData * iv = [AESIV dataUsingEncoding:NSUTF8StringEncoding];
    
    // setup key
    unsigned char cKey[FBENCRYPT_KEY_SIZE];
    bzero(cKey, sizeof(cKey));
    [key getBytes:cKey length:FBENCRYPT_KEY_SIZE];
    
    // setup iv
    char cIv[FBENCRYPT_BLOCK_SIZE];
    bzero(cIv, FBENCRYPT_BLOCK_SIZE);
    if (iv) {
        [iv getBytes:cIv length:FBENCRYPT_BLOCK_SIZE];
    }
    
    // setup output buffer
    size_t bufferSize = [data length] + FBENCRYPT_BLOCK_SIZE;
    void *buffer = malloc(bufferSize);
    
    // do decrypt
    size_t decryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          FBENCRYPT_ALGORITHM,
                                          kCCOptionPKCS7Padding,
                                          cKey,
                                          FBENCRYPT_KEY_SIZE,
                                          cIv,
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &decryptedSize);
    
    if (cryptStatus == kCCSuccess) {
        NSString *decryptedText = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)buffer
                                                                                length:(NSUInteger)decryptedSize]
                                                        encoding:NSUTF8StringEncoding];
        return decryptedText;
    } else {
        free(buffer);
        NSLog(@"[ERROR] failed to decrypt| CCCryptoStatus: %d", cryptStatus);
    }
    
    return nil;
}


+(NSString*)TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString*)key andIV:(NSString*)initVec
{
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        NSData *EncryptData = [GTMBase64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else
    {
        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x00, bufferPtrSize);
    
    const void *vkey = (const void *)[key UTF8String];
    const void *vinitVec = (const void *)[initVec UTF8String];
    
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey, //"123456789012345678901234", //key
                       kCCKeySize3DES,
                       vinitVec, //"init Vec", //iv,
                       vplainText, //"Your Name", //plainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    if (ccStatus == kCCSuccess)
    {
        NSLog(@"SUCCESS");
    }
    else if (ccStatus == kCCParamError)
    {
        //内存释放
        free(bufferPtr);
        return @"PARAM ERROR";
    }
    else if (ccStatus == kCCBufferTooSmall)
    {
        //内存释放
        free(bufferPtr);
        //return @"BUFFER TOO SMALL";
        NSLog(@"BUFFER TOO SMALL");
        return @"";
    }
    else if (ccStatus == kCCMemoryFailure)
    {
        //内存释放
        free(bufferPtr);
        return @"MEMORY FAILURE";
    }
    else if (ccStatus == kCCAlignmentError)
    {
        //内存释放
        free(bufferPtr);
        return @"ALIGNMENT";
    }
    else if (ccStatus == kCCDecodeError)
    {
        //内存释放
        free(bufferPtr);
        return @"DECODE ERROR";
    }
    else if (ccStatus == kCCUnimplemented)
    {
        //内存释放
        free(bufferPtr);
        return @"UNIMPLEMENTED";
    }
    
    NSString *result;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [[[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                length:(NSUInteger)movedBytes]
                                        encoding:NSUTF8StringEncoding]
                  autorelease];
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [GTMBase64 stringByEncodingData:myData];
    }
    //内存释放
    free(bufferPtr);
    return result;
}

+(NSString*)DES:(NSString*)aPlainText encryptOrDecrypt:(CCOperation)aEncryptOrDecrypt key:(NSString*)aKey
{
	const void* vplainText;
    NSUInteger plainTextBufferSize;
	
	const char* key = [aKey UTF8String];
	size_t keySize = 8 < strlen(key) ? 8 : strlen(key);
	
	if (kCCDecrypt == aEncryptOrDecrypt) 
	{
		NSData* encryptData = [GTMBase64 decodeData:[aPlainText dataUsingEncoding:NSUTF8StringEncoding]];
		plainTextBufferSize = [encryptData length];
		vplainText = [encryptData bytes];
	}
	else
	{
		NSData* data = [aPlainText dataUsingEncoding:NSUTF8StringEncoding];
		plainTextBufferSize = [data length];
		vplainText = [data bytes];
	}
	
	NSString* result = nil;
	if (kCCDecrypt == aEncryptOrDecrypt)
	{
		char* decryptText = (char*)malloc(plainTextBufferSize + 1);
		memset(decryptText, 0x00, plainTextBufferSize + 1);
		
		size_t decryptedDataLength = 0;
		CCCryptorStatus status = CCCrypt(kCCDecrypt, kCCAlgorithmDES, kCCOptionPKCS7Padding | kCCOptionECBMode,
										 key, keySize,
										 NULL,
										 vplainText, plainTextBufferSize,
										 decryptText, plainTextBufferSize,
										 &decryptedDataLength);
		
		if (kCCSuccess == status) {
			result = [[[NSString alloc] initWithData:[NSData dataWithBytes:decryptText
																	length:decryptedDataLength] 
											encoding:NSUTF8StringEncoding] autorelease];
		}
		
		free(decryptText);
	}
	else
	{
		size_t encryptedBufferSize = 0;
		if (0 != plainTextBufferSize % 8) {
			encryptedBufferSize = ((plainTextBufferSize + 8) >> 3) << 3;
		}
		
		char* encryptText = (char*)malloc(encryptedBufferSize + 1);
		memset(encryptText, 0x00, encryptedBufferSize + 1);
		
		size_t encryptedDataLength = 0;
		CCCryptorStatus status = CCCrypt(kCCEncrypt, kCCAlgorithmDES, kCCOptionPKCS7Padding | kCCOptionECBMode,
										 key, keySize,
										 NULL,
										 vplainText, plainTextBufferSize,
										 encryptText, encryptedBufferSize,
										 &encryptedDataLength);
		
		if (kCCSuccess == status) {
			NSData* encryptedData = [NSData dataWithBytes:encryptText length:encryptedDataLength];
			result = [GTMBase64 stringByEncodingData:encryptedData];
		}
		
		free(encryptText);
	}
	
	return result;
}


+(NSString*)HexStringOfData:(NSString*)data encryptedWithKey:(NSString*)key usePadding:(BOOL)usePadding {
	NSString* hexString = nil;
	
	if (nil != data && nil != key) {
		const char* dataBuffer = [data UTF8String];
		size_t dataSize = strlen(dataBuffer);
		
		const char* keyBuffer = [key UTF8String];
		size_t keySize = 8 < strlen(keyBuffer) ? 8 : strlen(keyBuffer);
		
		size_t cryptedBufferSize = dataSize;
		if (0 != dataSize % 8) {
			cryptedBufferSize = ((dataSize + 8) >> 3) << 3;
		}
		
		size_t encryptDataSize = dataSize;
		BOOL needPadding = NO;
		if (YES == usePadding) {
			if (cryptedBufferSize != dataSize) {
				needPadding = YES;
			}
		} else {
			encryptDataSize = cryptedBufferSize;
		}
		
		char* encryptBuffer = (char*)malloc(encryptDataSize);
		memset(encryptBuffer, 0x00, encryptDataSize);
		memcpy(encryptBuffer, dataBuffer, dataSize);
		
		char* cryptedDataBuffer = (char*)malloc(cryptedBufferSize);
		memset(cryptedDataBuffer, 0x00, cryptedBufferSize);
		
		size_t cryptedDataSize = 0;
		if (kCCSuccess == CCCrypt(kCCEncrypt, kCCAlgorithmDES,
								  YES == needPadding ? (kCCOptionECBMode | kCCOptionPKCS7Padding) : kCCOptionECBMode,
								  keyBuffer, keySize,
								  NULL,
								  encryptBuffer, encryptDataSize,
								  cryptedDataBuffer, cryptedBufferSize,
								  &cryptedDataSize)) {
			
			size_t encodeBufferSize = cryptedDataSize * 2;
			char* encodeBuffer = (char*)malloc(encodeBufferSize + 1);
			memset(encodeBuffer, 0x00, encodeBufferSize + 1);
			
			char* p = encodeBuffer;
			for (int i=0; i<cryptedDataSize; i++) {
				char byte = cryptedDataBuffer[i];
				
				sprintf(p, "%02X", (unsigned char)byte);
				p += 2;
			}
			
			free(cryptedDataBuffer);
			
			hexString = [[[NSString alloc] initWithData:[NSData dataWithBytes:encodeBuffer length:encodeBufferSize]
											   encoding:NSASCIIStringEncoding] autorelease];
			
			free(encodeBuffer);
			
		}
		free(encryptBuffer);
	}	
	
	return hexString;
}


+(NSString*)DataOfHexString:(NSString*)hexString decryptedWithKey:(NSString*)key {
	NSString* dataString = nil;
	
	if (nil != hexString && nil != key) {
		const char* hexStringBuffer = [hexString cStringUsingEncoding:NSASCIIStringEncoding];
		size_t hexStringSize = strlen(hexStringBuffer);
		
		const char* keyBuffer = [key UTF8String];
		size_t keySize = 8 < strlen(keyBuffer) ? 8 : strlen(keyBuffer);
		
		size_t decodeBufferSize = hexStringSize / 2;
		char* decodeBuffer = (char*)malloc(decodeBufferSize + 1);
		memset(decodeBuffer, 0x00, decodeBufferSize + 1);
		
		const char* p = hexStringBuffer;
		for (int i=0; i<decodeBufferSize; i++) {
			unsigned int byte = 0;
			sscanf(p, "%02X", &byte);
			decodeBuffer[i] = (unsigned char)byte;
			
			p += 2;
		}
		
		size_t decryptBufferSize = decodeBufferSize;
		char* decryptBuffer = (char*)malloc(decryptBufferSize + 1);
		memset(decryptBuffer, 0x00, decryptBufferSize + 1);
		
		size_t decryptedDataSize = 0;
		if (kCCSuccess == CCCrypt(kCCDecrypt, kCCAlgorithmDES, kCCOptionECBMode,
								  keyBuffer, keySize,
								  NULL,
								  decodeBuffer, decodeBufferSize,
								  decryptBuffer, decryptBufferSize,
								  &decryptedDataSize)) {
			dataString = [[[NSString alloc] initWithData:[NSData dataWithBytes:decryptBuffer length:decryptedDataSize]
												encoding:NSUTF8StringEncoding] autorelease];
		}
		
		free(decryptBuffer);
		free(decodeBuffer);
	}
	
	return dataString;
}



+(NSString*)TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString*)key 
{
//    const void* vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        NSData *EncryptData = [GTMBase64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];
        plainTextBufferSize = [EncryptData length];
//        vplainText = [EncryptData bytes];
    }
    else
    {
        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
//        vplainText = (const void *)[data bytes];
    }
    
//    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
//    const void *vkey = (const void *) [key UTF8String];
    
//    ccStatus = CCCrypt(encryptOrDecrypt,
//                       kCCAlgorithmDES,
//                       kCCOptionPKCS7Padding,
//                       vkey,
//                       kCCKeySizeDES,
//                       vkey,
//                       vplainText,
//                       plainTextBufferSize,
//                       (void *)bufferPtr,
//                       bufferPtrSize,
//                       &movedBytes);
    
    NSString *result;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [[[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                length:(NSUInteger)movedBytes]
                                        encoding:NSUTF8StringEncoding] autorelease];
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [GTMBase64 stringByEncodingData:myData];
    }
    free(bufferPtr);
    return result;
}

@end
