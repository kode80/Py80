//
//  KDEPyTokenizer.h
//  Py80
//
//  Created by Benjamin S Hopkins on 6/8/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDETokenizer.h"

typedef NS_ENUM( KDETokenType, KDEPyTokenType)
{
    KDEPyTokenTypeComment,
    KDEPyTokenTypeDocString,
    KDEPyTokenTypeString,
    KDEPyTokenTypeOpenDocString,
    KDEPyTokenTypeOpenString,
    KDEPyTokenTypeNumber,
    KDEPyTokenTypeName,
    KDEPyTokenTypeKeyword,
    KDEPyTokenTypeOperator,
    KDEPyTokenTypeBracket,
    KDEPyTokenTypeSpecial,
    KDEPyTokenTypeTokenCount
};

extern NSString *NSStringFromPyTokenType( KDEPyTokenType type);


@interface KDEPyTokenizer : KDETokenizer

@end
