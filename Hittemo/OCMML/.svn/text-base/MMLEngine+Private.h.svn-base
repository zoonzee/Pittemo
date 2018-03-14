/*
 Copyright (c) 2009, hkrn All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer. Redistributions in binary
 form must reproduce the above copyright notice, this list of conditions and
 the following disclaimer in the documentation and/or other materials
 provided with the distribution. Neither the name of the hkrn nor
 the names of its contributors may be used to endorse or promote products
 derived from this software without specific prior written permission. 
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 DAMAGE.
 */

//
//  MMLEngine+Private.h
//  OCMML
//
//  Created by hkrn on 09/02/20.
//  Copyright 2009 hkrn. All rights reserved.
//
//  $Id$
//

#import "Oscillators.h"
#import "MMLSequencerAL.h"

@interface MMLEngine ()
- (MMLTrack *)newTrack;
- (void)setStringToParse:(NSString *)string;
- (void)compile:(NSString *)string;
- (int)tickFromLength:(int)length;
- (void)noteToken:(int)noteNumber;
- (void)restToken;
- (void)atmarkToken;
- (unichar)nextCharacterToken;
- (unichar)characterToken;
- (int)intTokenOrDefault:(int)aDefault;
- (unsigned int)uintTokenOrDefault:(unsigned int)aDefault;
- (int)tickFromDotToken:(int)tick;
- (int)keySignToken;
- (void)parse;
- (void)parseRepeat;
- (void)parseMacro;
- (void)parseComment;
- (NSArray *)dumpTracks;
@end
