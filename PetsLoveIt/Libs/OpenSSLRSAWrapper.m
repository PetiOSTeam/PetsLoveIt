// OpenSSLRSAWrapper.m
//
// Copyright (c) 2012 scott ban (http://github.com/reference)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "OpenSSLRSAWrapper.h"
#import "NSString+Base64.h"
#import "NSData+Base64.h"

#define DocumentsDir [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define OpenSSLRSAKeyDir [DocumentsDir stringByAppendingPathComponent:@".openssl_rsa"]
#define OpenSSLRSAPublicKeyFile [OpenSSLRSAKeyDir stringByAppendingPathComponent:@"publicKey"]
#define OpenSSLRSAPrivateKeyFile [OpenSSLRSAKeyDir stringByAppendingPathComponent:@"privateKey"]

@implementation OpenSSLRSAWrapper
@synthesize publicKeyBase64,privateKeyBase64;

#pragma mark - getter

// Helper function for ASN.1 encoding

size_t encodeLength(unsigned char * buf, size_t length) {
    
    // encode length in ASN.1 DER format
    if (length < 128) {
        buf[0] = length;
        return 1;
    }
    
    size_t i = (length / 256) + 1;
    buf[0] = i + 0x80;
    for (size_t j = 0 ; j < i; ++j) {
        buf[i - j] = length & 0xFF;
        length = length >> 8;
    }
    
    return i + 1;
}


- (NSData*)publicKeyBitsWithString:(NSString*)str{
    
    static const unsigned char _encodedRSAEncryptionOID[15] = {
        
        /* Sequence of length 0xd made up of OID followed by NULL */
        0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
        0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00
        
    };
    
    NSData *publicKeyBits_ = [str base64DecodedData];
    
    // OK - that gives us the "BITSTRING component of a full DER
    // encoded RSA public key - we now need to build the rest
    
    unsigned char builder[15];
    NSMutableData * encKey = [NSMutableData dataWithCapacity:0];
    int bitstringEncLength;
    
    // When we get to the bitstring - how will we encode it?
    if ([publicKeyBits_ length] + 1 < 128)
        bitstringEncLength = 1;
    else
        bitstringEncLength = (([publicKeyBits_ length] +1) / 256) + 2;
    
    // Overall we have a sequence of a certain length
    builder[0] = 0x30;    // ASN.1 encoding representing a SEQUENCE
    // Build up overall size made up of -
    // size of OID + size of bitstring encoding + size of actual key
    size_t i = sizeof(_encodedRSAEncryptionOID) + 2 + bitstringEncLength +
    [publicKeyBits_ length];
    size_t j = encodeLength(&builder[1], i);
    [encKey appendBytes:builder length:j +1];
    
    // First part of the sequence is the OID
    [encKey appendBytes:_encodedRSAEncryptionOID
                 length:sizeof(_encodedRSAEncryptionOID)];
    
    // Now add the bitstring
    builder[0] = 0x03;
    j = encodeLength(&builder[1], [publicKeyBits_ length] + 1);
    builder[j+1] = 0x00;
    [encKey appendBytes:builder length:j + 2];
    
    // Now the actual key
    [encKey appendData:publicKeyBits_];
    
    return encKey;
}
//65 , 76
- (NSString *)formatPublicKey:(NSString *)publicKey {
	
	NSMutableString *result = [NSMutableString string];
	[result appendString:@"-----BEGIN PUBLIC KEY-----\n"];
	int count = 0;
	for (int i = 0; i < [publicKey length]; ++i) {
		
		unichar c = [publicKey characterAtIndex:i];
		if (c == '\n' || c == '\r') {
			continue;
		}
		[result appendFormat:@"%c", c];
		if (++count == 65) {
			[result appendString:@"\n"];
			count = 0;
		}
	}
	[result appendString:@"\n-----END PUBLIC KEY-----\n"];
	return result;
}
- (BOOL)saveRSAKeyPair:(NSString*)pubKey withPriKey:(NSString*)priKey
{
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:OpenSSLRSAPublicKeyFile])
    {
        [fm removeItemAtPath:OpenSSLRSAPublicKeyFile error:nil];
    }
    if ([fm fileExistsAtPath:OpenSSLRSAPrivateKeyFile])
    {
        [fm removeItemAtPath:OpenSSLRSAPrivateKeyFile error:nil];
    }
//    NSString *rsaPubKey = [self formatPublicKey:pubKey];
//    NSLog(@"formatPublicKey:%@",rsaPubKey);
    [pubKey writeToFile:OpenSSLRSAPublicKeyFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    [priKey writeToFile:OpenSSLRSAPrivateKeyFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
    return YES;
}

- (NSString*)publicKeyBase64{
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:OpenSSLRSAPublicKeyFile]) {
        NSString *str = [NSString stringWithContentsOfFile:OpenSSLRSAPublicKeyFile encoding:NSUTF8StringEncoding error:nil];
        
        /*
         This return value based on the key that generated by openssl.
         
         -----BEGIN RSA PUBLIC KEY-----
         MIGHAoGBAOp5TLclpWCaNDzHYPfB26SLmS8vlSXH4PyKopz5OS5Vx994FBQQLwv9
         2pIJQsBk09egrL0gbASK1VCwDt0MmaiyrNFl/xaEzB/VOvjoojBUzMMIca9fKmx5
         GAzSbSP7we64dhvrziuuNVTuM/e2XSa2skKFHMI0bCq4+pNYhvRhAgED
         -----END RSA PUBLIC KEY-----
         */
        //return str;
        NSData *data = [self publicKeyBitsWithString:[[str componentsSeparatedByString:@"-----"] objectAtIndex:2]];
        //NSLog(@"len %i,\n%@",[[data base64EncodedString] length],[data base64EncodedString]);
        return [data base64EncodedString];
    }
    return nil;
}

- (NSString*)privateKeyBase64{
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:OpenSSLRSAPrivateKeyFile]) {
        NSString *str = [NSString stringWithContentsOfFile:OpenSSLRSAPrivateKeyFile encoding:NSUTF8StringEncoding error:nil];
        
        /*
         This return value based on the key that generated by openssl.
         
         -----BEGIN RSA PRIVATE KEY-----
         MIICXAIBAAKBgQDqeUy3JaVgmjQ8x2D3wduki5kvL5Ulx+D8iqKc+TkuVcffeBQU
         EC8L/dqSCULAZNPXoKy9IGwEitVQsA7dDJmosqzRZf8WhMwf1Tr46KIwVMzDCHGv
         XypseRgM0m0j+8HuuHYb684rrjVU7jP3tl0mtrJChRzCNGwquPqTWIb0YQIBAwKB
         gQCcUN3Pbm5AZs192kClK+fDB7t0ymNuhUCoXGxopiYe49qU+rgNYB9dU+cMBiyA
         QzflFch+FZ1YXI41yrSTXbvEhcYQy7jdFVJiqNH4Cu767ETzLMFDiDXIv5/h72iN
         hfeRWTW/KbyZbEtq/HeTjIg7rP3h8Fveh/Fj3EY4bmlqgwJBAPbQFmacHXeO4xcP
         aLhFVX/lDrmL7o1TIFNAp8xH/Kqf+L4+uSzoqyvPzO3w2ATdge+VnLhrxzzU48eg
         Y3wHpY8CQQDzM6HNza1tQajA8Jwf9mJygEeLw9uFhp8GZ5IfCFMILpv0ZsQASppf
         9GeFj8Jes0tDn9LkJy0rrTEm8Ns24S8PAkEApIq5mb1o+l9CD1+bJYOOVUNfJl1J
         s4zAN4Bv3YVTHGql1CnQyJscx9/d8/XlWJOr9Q5oevKE0ziX2mrs/VpuXwJBAKIi
         a96JHkjWcICgaBVO7ExVhQfX565Zv1maYWoFjLAfEqLvLVWHEZVNmlkKgZR3h4Jq
         jJgaHh0eIMSgkiSWH18CQGsFhFEdBonmeIm1kY1YWjpM4WS0kUlXOC3sCYg8eXFe
         YEEr9pnY+hhDFegEItQd1hAvrqQhpxhX7HhNNxUoPp4=
         -----END RSA PRIVATE KEY-----
         */
        //return str;
        return [[str componentsSeparatedByString:@"-----"] objectAtIndex:2];
    }
    return nil;
}

- (id)init{
    if (self = [super init]) {
        //load RSA if it is exsit
        NSFileManager *fm = [NSFileManager defaultManager];
        if (![fm fileExistsAtPath:OpenSSLRSAKeyDir]) {
            [fm createDirectoryAtPath:OpenSSLRSAKeyDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }return self;
}

+ (id)shareInstance{
    static OpenSSLRSAWrapper *_opensslWrapper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _opensslWrapper = [[self alloc] init];
    });
    return _opensslWrapper;
}

- (BOOL)generateRSAKeyPairWithKeySize:(NSInteger)keySize {
    if (NULL != _rsa) {
        RSA_free(_rsa);
        _rsa = NULL;
    }
    _rsa = RSA_generate_key(keySize,RSA_F4,NULL,NULL);
    assert(_rsa != NULL);
    
    if (_rsa) {
        return YES;
    }return NO;
    
    //    PEM_write_RSAPrivateKey(stdout, _rsa, NULL, NULL, 0, NULL, NULL);
    //    PEM_write_RSAPublicKey(stdout, _rsa);
}

- (BOOL)exportRSAKeys{
    assert(_rsa != NULL);
    
    if (_rsa != NULL) {
        FILE *filepub,*filepri;
        filepri = fopen([OpenSSLRSAPrivateKeyFile cStringUsingEncoding:NSASCIIStringEncoding],"w");
        filepub = fopen([OpenSSLRSAPublicKeyFile cStringUsingEncoding:NSASCIIStringEncoding],"w");
        
        if (NULL != filepub && NULL != filepri) {
            int retpri = -1;
            int retpub = -1;
            
            RSA *_pribrsa = RSAPrivateKey_dup(_rsa);
            assert(_pribrsa != NULL);
            retpri = PEM_write_RSAPrivateKey(filepri, _pribrsa, NULL, NULL, 512, NULL, NULL);
            RSA_free(_pribrsa);
            
            RSA *_pubrsa = RSAPublicKey_dup(_rsa);
            assert(_pubrsa != NULL);
            retpub = PEM_write_RSAPublicKey(filepub, _pubrsa);
            RSA_free(_pubrsa);
            
            fclose(filepub);
            fclose(filepri);
            
            return (retpri+retpub>1)?YES:NO;
        }
    }return NO;
}



- (BOOL)importRSAKeyWithType:(KeyType)type{
    FILE *file;
    
    if (type == KeyTypePublic) {
        file = fopen([OpenSSLRSAPublicKeyFile cStringUsingEncoding:NSASCIIStringEncoding],"rb");
    }else{
        file = fopen([OpenSSLRSAPrivateKeyFile cStringUsingEncoding:NSASCIIStringEncoding],"rb");
    }
    NSLog(@"OpenSSLRSAPublicKeyFile:%@",OpenSSLRSAPublicKeyFile);
    if (NULL != file) {
        
        if (type == KeyTypePublic)
        {
            _rsa = PEM_read_RSAPublicKey(file,NULL, NULL, NULL);
            assert(_rsa != NULL);
            // PEM_write_RSAPublicKey(stdout, _rsa);
        }
        else
        {
            _rsa = PEM_read_RSAPrivateKey(file, NULL, NULL, NULL);
            assert(_rsa != NULL);
            PEM_write_RSAPrivateKey(stdout, _rsa, NULL, NULL, 0, NULL, NULL);
        }
        
        fclose(file);
        return (_rsa != NULL)?YES:NO;
    } return NO;
}


#pragma mark -

- (int)getBlockSizeWithRSA_PADDING_TYPE:(RSA_PADDING_TYPE)padding_type keyType:(KeyType)keyType{
    
    int len = RSA_size(_rsa);
    
    if (padding_type == RSA_PADDING_TYPE_PKCS1 || padding_type == RSA_PADDING_TYPE_SSLV23) {
        len -= 11;
    }
    
    return len;
}

NSString *base64StringFData(NSData *signature)
{
    int signatureLength = [signature length];
    unsigned char *outputBuffer = (unsigned char *)malloc(2 * 4 * (signatureLength / 3 + 1));
    int outputLength = EVP_EncodeBlock(outputBuffer, [signature bytes], signatureLength);
    outputBuffer[outputLength] = '\0';
    NSString *base64String = [NSString stringWithCString:(char *)outputBuffer encoding:NSASCIIStringEncoding];
    free(outputBuffer);
    return base64String;
}

NSData *dataFBase64String(NSString *base64String)
{
    int stringLength = [base64String length];
    
    const unsigned char *strBuffer = (const unsigned char *)[base64String UTF8String];
    unsigned char *outputBuffer = (unsigned char *)malloc(2 * 3 * (stringLength / 4 + 1));
    int outputLength = EVP_DecodeBlock(outputBuffer, strBuffer, stringLength);
    
    int zeroByteCounter = 0;
    for (int i = stringLength - 1; i >= 0; i--)
    {
        if (strBuffer[i] == '=')
        {
            zeroByteCounter++;
        }
        else
        {
            break;
        }
    }
    //length<0造成crash,判断并处理
    NSInteger length=outputLength - zeroByteCounter;
    if (length<0) {
        length=10;
        NSLog(@"dataFBase64String:%@ NSData init长度为负数",base64String);
    }

    NSData *data = [[[NSData alloc] initWithBytes:outputBuffer length:length] autorelease];
    free(outputBuffer);
    return data;
}

- (NSData*)encryptRSAKeyWithType:(KeyType)keyType plainText:(NSString*)text
{
    if (text && [text length])
    {
        
        NSLog(@"OpenSSLRSAPublicKeyFile:%@",OpenSSLRSAPublicKeyFile);
        _rsa = NULL;
        BIO *bio_private = NULL;
        bio_private = BIO_new(BIO_s_file());
        NSString *filePath = OpenSSLRSAPublicKeyFile;
        char *private_key_file_path = (char *)[filePath UTF8String];
        BIO_read_filename(bio_private, private_key_file_path);
        _rsa = PEM_read_bio_RSA_PUBKEY(bio_private, NULL, NULL, NULL);
        
        if (_rsa == nil)
        {
            NSLog(@"rsa_private read error : private key is NULL");
        }
        
        const char *message = [text UTF8String];
        int key_size = RSA_size(_rsa);
        unsigned char *encrypted = (unsigned char*)malloc(key_size);
        
        int bufSize = RSA_public_encrypt(strlen(message), (unsigned char*)message, encrypted, _rsa, RSA_PADDING_TYPE_PKCS1);
        if (bufSize == -1)
        {
            RSA_free(_rsa);
            return nil;
        }
        NSString * base64String = base64StringFData([NSData dataWithBytes:encrypted length:bufSize]);
        NSData * UTF8Data = [base64String dataUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"base64String:%@",base64String);
        //memory free
        BIO_free_all(bio_private);
        free(encrypted);
        RSA_free(_rsa);
        return UTF8Data;
    }
    return  nil;
}

- (NSString*)decryptRSAKeyWithType:(KeyType)keyType data:(NSString*)data
{
   
    if (data && [data length])
    {
        
        NSData *sData = dataFBase64String(data);
        unsigned char* message = (unsigned char*)[sData bytes];
        _rsa = NULL;
        BIO *bio_private = NULL;
        bio_private = BIO_new(BIO_s_file());
        NSString *filePath = OpenSSLRSAPublicKeyFile;
        char *private_key_file_path = (char *)[filePath UTF8String];
        BIO_read_filename(bio_private, private_key_file_path);
        _rsa = PEM_read_bio_RSA_PUBKEY(bio_private, NULL, NULL, NULL);
        
        if (_rsa == nil)
        {
            NSLog(@"rsa_private read error : private key is NULL");
        }
        int key_size = RSA_size(_rsa);
        char *ptext = (char*)malloc(key_size);
        bzero(ptext, key_size);
        
        int outlen = RSA_public_decrypt(key_size, (const unsigned char*)message, (unsigned char*)ptext, _rsa, RSA_PADDING_TYPE_PKCS1);
        if (outlen < 0)
        {
            return nil;
        }
        NSMutableString *decryptString = [[NSMutableString alloc] initWithBytes:ptext length:strlen(ptext) encoding:NSASCIIStringEncoding];
        // TODO: memory free
        free(ptext);
        ptext = NULL;
        RSA_free(_rsa);
       // BIO_free(bio_private);
        BIO_free_all(bio_private);
        return [decryptString autorelease];
    }
    return nil;
}

- (void)dealloc
{
    [super dealloc];
}
@end
