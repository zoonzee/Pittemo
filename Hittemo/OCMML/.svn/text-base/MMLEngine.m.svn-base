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
//  MMLEngine.m
//  OCMML
//
//  Created by hkrn on 09/02/06.
//  Copyright 2009 hkrn. All rights reserved.
//
//  $Id$
//

#import "MMLEngine.h"
#import "MMLEngine+Private.h"
#import "MMLTrack+Private.h"

@implementation MMLEngine

//static BOOL s_observed = NO;
NSString *const MMLEngineDidCompile = @"MMLEngineDidCompile";
NSString *const MMLEngineDidResume = @"MMLEngineDidResume";

@synthesize warnings;
@synthesize m_sequencer;
@synthesize m_string;
@synthesize m_compiling;

static void NextLine(NSScanner **aScanner, NSRange *range, NSRange subrange)
{
    [*aScanner release];
    *aScanner = nil;
    range->location = NSMaxRange(subrange);
    range->length -= subrange.length;
}

- (void)initValues
{
    m_trackNo = kFirstTrack;
    m_octave = 4;
    m_isRelativeDir = YES;
    m_velocity = 100;
    m_velocityDetail = YES;
    m_length = [self tickFromLength:4];
    m_tempo = 120;
    m_isKeyOff = YES;
    m_gate = 15;
    m_maxGate = 16;
    m_form = kMMLOscillatorPulse;
    m_noteShift = 0;
    m_maxPipe = 0;
    m_maxSyncSource = 0;
}

- (void)start
{
    [m_sequencer play];
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        [self initValues];
        m_compiling = NO;
		// todo multiple 1:フレームレートが万遍なく落ちる、32:数秒に１回フレームが止まる
        m_sequencer = [[MMLSequencerAL alloc] initWithMultiple:1];
        if (m_sequencer == nil)
            return nil;
        m_tracks = [[NSMutableArray alloc] initWithCapacity:3];
        m_warnings = [[NSMutableArray alloc] initWithCapacity:8];
        m_string = [[NSMutableString alloc] initWithString:@""];
        m_queue = [[NSOperationQueue alloc] init];
        [m_queue setMaxConcurrentOperationCount:1];
    }
    return self;
}

- (void)dealloc
{
    [m_sequencer release];
    [m_tracks release];
    [m_warnings release];
    [m_string release];
    [m_queue release];
    [super dealloc];
}

+ (NSString *)newTrimmedString:(NSString *)string
{
    NSCharacterSet *space = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSUInteger i = 0, stringLength = [string length];
    unichar *p, *s = malloc(stringLength * sizeof(unichar));
    for (p = s; i < stringLength; i++) {
        unichar c = [string characterAtIndex:i];
        if (![space characterIsMember:c]) {
            *p++ = c;
        }
    }
    NSString *newString = [[NSString alloc] initWithCharactersNoCopy:s
                                                              length:p - s
                                                        freeWhenDone:YES];
    return newString;
}

- (void)trimAndToLower
{
    NSString *newString = [[self class] newTrimmedString:m_string];
    [self setStringToParse:[newString lowercaseString]];
    [newString release];
}

- (void)setStringToParse:(NSString *)string
{
    /*
    [string setString:aString];
    */
    NSMutableString *newString = [[NSMutableString alloc] initWithString:string];
    [m_string release];
    m_string = [newString retain];
    [newString release];
}

- (void)addWarning:(enum MMLEngineWarningType)warnType
{
    NSNumber *type = [[NSNumber alloc] initWithInt:warnType];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:type, @"type", nil];
    [type release];
    [m_warnings addObject:dictionary];
    [dictionary release];
}

- (void)addWarning:(enum MMLEngineWarningType)warnType character:(int)c
{
    NSNumber *character = [[NSNumber alloc] initWithInt:c];
    NSNumber *type = [[NSNumber alloc] initWithInt:warnType];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:type, @"type",
                                character, @"character", nil];
    [type release];
    [character release];
    [m_warnings addObject:dictionary];
    [dictionary release];
}

- (NSArray *)warnings
{
    return m_warnings;
}

- (void)compile:(NSString *)string
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    // tempoTrack
    MMLTrack *track = [self newTrack];
    [m_tracks addObject:track];
    [track release];
    // firstTrack
    track = [self newTrack];
    [m_tracks addObject:track];
    [track release];
    [self setStringToParse:string];
    [self parseComment];
    [self parseMacro];
    [self trimAndToLower];
    [self parseRepeat];
    [self parse];
    NSUInteger trackCount = [m_tracks count];
    track = [m_tracks objectAtIndex:trackCount - 1];
    if ([track eventCount] == 0) {
        [m_tracks removeLastObject];
        --trackCount;
    }
    track = [m_tracks objectAtIndex:kTempoTrack];
    [track conductTracks:m_tracks];
    for (NSUInteger i = kTempoTrack; i < trackCount; i++) {
        track = [m_tracks objectAtIndex:i];
        if (i > kTempoTrack) {
            [track recordRestWithTimeSpan:2000];
            [track recordClose];
        }
        [m_sequencer connectTrack:track];
    }
    [m_sequencer createPipes:m_maxPipe + 1];
    [m_sequencer createSyncSource:m_maxSyncSource + 1];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:MMLEngineDidCompile
                          object:self
                        userInfo:nil];
    m_compiling = NO;
    [pool release];
}

- (void)play:(NSString *)string
{
    if (m_sequencer.isPlaying) {
        return;
    }
    else if (m_sequencer.isPaused) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center postNotificationName:MMLEngineDidResume
                              object:self
                            userInfo:nil];
        [pool release];
        return;
    }
    m_compiling = YES;
    [self initValues];
    [m_warnings removeAllObjects];
    [m_tracks removeAllObjects];
    [m_sequencer disconnectAllTracks];
//    if (!s_observed) {
//        s_observed = YES;
//        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//        [center addObserver:m_sequencer
//                   selector:@selector(play)
//                       name:MMLEngineDidCompile
//                     object:nil];
//        [center addObserver:m_sequencer
//                   selector:@selector(play)
//                       name:MMLEngineDidResume
//                     object:nil];
//    }
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                            selector:@selector(compile:)
                                                                              object:string];
    [m_queue addOperation:operation];
    [operation release];
}

- (void)stop
{
    [m_sequencer stop];
}

- (void)pause
{
    [m_sequencer pause];
}

- (void)resume
{
    [m_sequencer play];
}

- (int)masterVolume
{
    return m_sequencer.masterVolume;
}

- (void)setMasterVolume:(int)volume
{
    m_sequencer.masterVolume = volume;
}

- (NSUInteger)duration
{
    MMLTrack *track = [m_tracks objectAtIndex:kTempoTrack];
    return track.duration;
}

- (NSUInteger)timespan
{
    return m_sequencer.timespan;
}

- (unsigned int)globalTick
{
    return m_sequencer.globalTick;
}

- (BOOL)isPlaying
{
    return m_sequencer.isPlaying;
}

- (BOOL)isPaused
{
    return m_sequencer.isPaused;
}

- (int)tickFromLength:(int)length
{
    return length == 0 ? m_length : 384 / length;
}

- (MMLTrack *)newTrack
{
    m_octave = 4;
    m_velocity = 100;
    m_noteShift = 0;
    return [[MMLTrack alloc] init];
}

- (void)noteToken:(int)noteNumber
{
    noteNumber += m_noteShift + [self keySignToken];
    int length = [self uintTokenOrDefault:0];
    int tick = [self tickFromDotToken:[self tickFromLength:length]];
    BOOL keyOn = m_isKeyOff == NO ? NO : YES;
    m_isKeyOff = YES;
    if ([self characterToken] == '&') {
        ++m_stringLocation;
        m_isKeyOff = NO;
    }
    MMLTrack *track = [m_tracks objectAtIndex:m_trackNo];
    [track recordNoteAtNumber:noteNumber + m_octave * 12
                       length:tick
                     velocity:m_velocity
                        keyOn:keyOn
                       keyOff:m_isKeyOff];
}

- (void)restToken
{
    int length = [self uintTokenOrDefault:0];
    int tick = [self tickFromDotToken:[self tickFromLength:length]];
    MMLTrack *track = [m_tracks objectAtIndex:m_trackNo];
    [track recordRestWithLength:tick];
}

- (void)atmarkToken
{
    MMLTrack *track;
    NSRange range;
    unichar c = [self characterToken];
    int o = 1;
    int attack = 0;
    int decay = 64;
    int sustain = 32;
    int release = 0;
    int form = 0;
    int subform = 0;
    int delay = 0;
    int aTime = 0;
    int amount = 0;
    int frequency = 0;
    int resonance = 0;
    int expression = 0;
    int sens = 0;
    int mode = 0;
    BOOL reverse = NO;
    switch (c) {
        case 'v': // 音のボリューム
            m_velocityDetail = NO;
            ++m_stringLocation;
            m_velocity = [self uintTokenOrDefault:m_velocity];
            m_velocity = MIN(m_velocity, 127);
            break;
        case 'x':
            ++m_stringLocation;
            expression = [self uintTokenOrDefault:127];
            track = [m_tracks objectAtIndex:m_trackNo];
            [track recordExpression:expression];
            break;
        case 'e': // エンベロープ
            ++m_stringLocation;
            o = [self uintTokenOrDefault:o];
            if ([self characterToken] == ',') {
                ++m_stringLocation;
            }
            attack = [self uintTokenOrDefault:attack];
            if ([self characterToken] == ',') {
                ++m_stringLocation;
            }
            decay = [self uintTokenOrDefault:decay];
            if ([self characterToken] == ',') {
                ++m_stringLocation;
            }
            sustain = [self uintTokenOrDefault:sustain];
            if ([self characterToken] == ',') {
                ++m_stringLocation;
            }
            release = [self uintTokenOrDefault:release];
            track = [m_tracks objectAtIndex:m_trackNo];
            [track recordEnvelopeWithAttack:attack
                                      decay:decay
                                    sustain:sustain
                                    release:release
                                      isVCO:(BOOL)(o == 1)];
            break;
        case 'n': // ノイズの周波数
            ++m_stringLocation;
            o = [self uintTokenOrDefault:0];
            o = MIN(MAX(o, 0), 127);
            track = [m_tracks objectAtIndex:m_trackNo];
            [track recordNoiseFrequency:o];
            break;
        case 'w': // パルス幅変調(PWM)
            ++m_stringLocation;
            o = [self uintTokenOrDefault:50];
            o = MIN(MAX(o, 1), 99);
            track = [m_tracks objectAtIndex:m_trackNo];
            [track recordPWM:o];
            break;
        case 'p': // パン
            ++m_stringLocation;
            o = [self uintTokenOrDefault:64];
            o = MIN(MAX(o, 1), 127);
            track = [m_tracks objectAtIndex:m_trackNo];
            [track recordPan:o];
            break;
        case 39: // フォルマントフィルター
            ++m_stringLocation;
            range = NSMakeRange(m_stringLocation, [m_string length] - m_stringLocation);
            NSRange found = [m_string rangeOfString:@"'"
                                            options:0
                                              range:range];
            if (found.location >= 0) {
                range = NSMakeRange(m_stringLocation, found.location - m_stringLocation);
                NSString *vs = [m_string substringWithRange:range];
                enum MMLFormantVowelType vowel = kMMLFormantVowelUnknown;
                if ([vs length] > 0) {
                    int vc = [vs characterAtIndex:0];
                    switch (vc) {
                        case 'a':
                            vowel = kMMLFormantVowelA;
                            break;
                        case 'e':
                            vowel = kMMLFormantVowelE;
                            break;
                        case 'i':
                            vowel = kMMLFormantVowelI;
                            break;
                        case 'o':
                            vowel = kMMLFormantVowelO;
                            break;
                        case 'u':
                            vowel = kMMLFormantVowelU;
                            break;
                        default:
                            break;
                    }
                }
                track = [m_tracks objectAtIndex:m_trackNo];
                [track recordFormantVowel:vowel];
                m_stringLocation = found.location + 1;
            }
            break;
        case 'd': // デチューン
            ++m_stringLocation;
            o = [self intTokenOrDefault:0];
            track = [m_tracks objectAtIndex:m_trackNo];
            [track recordDetune:o];
            break;
        case 'l': // 低周波発振(LFO)
            ++m_stringLocation;
            reverse = NO;
            form = 1;
            subform = delay = aTime = 0;
            int depth = [self uintTokenOrDefault:0];
            if ([self characterToken] == ',') {
                ++m_stringLocation;
            }
            int width = [self uintTokenOrDefault:0];
            if ([self characterToken] == ',') {
                ++m_stringLocation;
                if ([self characterToken] == '-') {
                    reverse = YES;
                    ++m_stringLocation;
                }
                form = [self uintTokenOrDefault:form] + 1;
                if ([self characterToken] == '-') {
                    ++m_stringLocation;
                    subform = [self uintTokenOrDefault:subform];
                }
                if ([self characterToken] == ',') {
                    ++m_stringLocation;
                    delay = [self uintTokenOrDefault:delay];
                    if ([self characterToken] == ',') {
                        ++m_stringLocation;
                        aTime = [self uintTokenOrDefault:aTime];
                    }
                }
            }
            track = [m_tracks objectAtIndex:m_trackNo];
            [track recordLFOWithDepth:depth
                                width:width
                                 form:form
                              subForm:subform
                                delay:delay
                                 time:aTime
                              reverse:reverse];
            break;
        case 'f': // フィルター
            ++m_stringLocation;
            amount = frequency = resonance = 0;
            int aSwitch = [self intTokenOrDefault:0];
            if ([self characterToken] == ',') {
                ++m_stringLocation;
                amount = [self intTokenOrDefault:0];
                if ([self characterToken] == ',') {
                    ++m_stringLocation;
                    frequency = [self uintTokenOrDefault:0];
                    if ([self characterToken] == ',') {
                        ++m_stringLocation;
                        resonance = [self uintTokenOrDefault:0];
                    }
                }
            }
            track = [m_tracks objectAtIndex:m_trackNo];
            [track recordLFPWithSwitch:aSwitch
                                amount:amount
                             frequency:frequency
                             resonance:resonance];
            break;
        case 'q': // ゲートタイム2
            ++m_stringLocation;
            track = [m_tracks objectAtIndex:m_trackNo];
            [track recordGate2:[self uintTokenOrDefault:2] * 2];
            break;
        case 'i': // 入力
            ++m_stringLocation;
            sens = [self uintTokenOrDefault:0];
            if ([self characterToken] == ',') {
                ++m_stringLocation;
                attack = [self uintTokenOrDefault:attack];
                attack = MIN(attack, m_maxPipe);
            }
            track = [m_tracks objectAtIndex:m_trackNo];
            [track recordInputWithSens:sens
                                  pipe:attack];
            break;
        case 'o': // 出力
            ++m_stringLocation;
            mode = [self uintTokenOrDefault:0];
            if ([self characterToken] == ',') {
                ++m_stringLocation;
                attack = [self uintTokenOrDefault:attack];
                if (attack > m_maxPipe) {
                    m_maxPipe = attack;
                    if (m_maxPipe >= kEngineMaxPipe) {
                        m_maxPipe = attack = kEngineMaxPipe;
                    }
                }
            }
            track = [m_tracks objectAtIndex:m_trackNo];
            [track recordOutputWithMode:mode
                                   pipe:attack];
            break;
        case 'r': // 入力
            ++m_stringLocation;
            sens = [self uintTokenOrDefault:0];
            if ([self characterToken] == ',') {
                ++m_stringLocation;
                attack = [self uintTokenOrDefault:attack];
                attack = MIN(attack, m_maxPipe);
            }
            track = [m_tracks objectAtIndex:m_trackNo];
            [track recordRingWithSens:sens
                                 pipe:attack];
            break;
        case 's': // 出力
            ++m_stringLocation;
            mode = [self uintTokenOrDefault:0];
            if ([self characterToken] == ',') {
                ++m_stringLocation;
                attack = [self uintTokenOrDefault:attack];
                switch (mode) {
                    case kMMLChannelOutputOverwrite:
                        if (attack > m_maxSyncSource) {
                            m_maxSyncSource = attack;
                            if (m_maxSyncSource >= kEngineMaxPipe) {
                                m_maxSyncSource = attack = kEngineMaxPipe;
                            }
                        }
                        break;
                    case kMMLChannelOutputAdd:
                        attack = MIN(attack, m_maxSyncSource);
                        break;

                }
            }
            track = [m_tracks objectAtIndex:m_trackNo];
            [track recordSyncWithMode:mode
                                 pipe:attack];
            break;
        default:
            m_form = [self uintTokenOrDefault:m_form];
            attack = 0;
            if ([self characterToken] == '-') {
                ++m_stringLocation;
                attack = [self uintTokenOrDefault:0];
            }
            track = [m_tracks objectAtIndex:m_trackNo];
            [track recordForm:m_form
                      subform:attack];
            break;
    }
}

- (unichar)nextCharacterToken
{
    unichar c = [self characterToken];
    m_stringLocation++;
    return c;
}

- (unichar)characterToken
{
    if (m_stringLocation < [m_string length]) {
        return [m_string characterAtIndex:m_stringLocation];
    }
    else {
        return 0;
    }
}

- (int)intTokenOrDefault:(int)aDefault
{
    unichar c = [self characterToken];
    int sign = 1;
    switch (c) {
        case '+':
            ++m_stringLocation;
            break;
        case '-':
            sign = -1;
            ++m_stringLocation;
            break;
    }
    return [self uintTokenOrDefault:aDefault] * sign;
}

- (unsigned int)uintTokenOrDefault:(unsigned int)aDefault
{
    uint64_t ret = 0, sum = 0;
    NSUInteger i = m_stringLocation;
    while (YES) {
        unichar c = [self characterToken];
        if (isdigit(c)) {
            sum = sum * 10 + (c - '0');
            m_stringLocation++;
            if (sum < UINT32_MAX) {
                ret = sum;
            }
            else {
                break;
            }
        }
        else {
            break;
        }
    }
    return i == m_stringLocation ? aDefault : (unsigned int)ret;
}

- (void)firstLetterToken
{
    MMLTrack *track;
    unichar c0, c = [self nextCharacterToken];
    switch (c) {
        case 'c': // ド
            [self noteToken:0];
            break;
        case 'd': // レ
            [self noteToken:2];
            break;
        case 'e': // ミ
            [self noteToken:4];
            break;
        case 'f': // ファ
            [self noteToken:5];
            break;
        case 'g': // ソ
            [self noteToken:7];
            break;
        case 'a': // ラ
            [self noteToken:9];
            break;
        case 'b': // シ
            [self noteToken:11];
            break;
        case 'r': // 残り
            [self restToken];
            break;
        case 'o': // オクターブ
            m_octave = [self uintTokenOrDefault:m_octave];
            m_octave = MIN(MAX(m_octave, -2), 8);
            break;
        case 'v': // 音のボリューム
            m_velocityDetail = NO;
            m_velocity = [self uintTokenOrDefault:(m_velocity - 7) / 8] * 8 + 7;
            m_velocity = MIN(MAX(m_velocity, 0), 127);
            break;
        case 'l': // 長さ
            m_length = [self tickFromLength:[self uintTokenOrDefault:0]];
            m_length = [self tickFromDotToken:m_length];
            break;
        case '(': // ボリュームアップ
            m_velocity += m_velocityDetail ? 1 : 8;
            m_velocity = MIN(m_velocity, 127);
            break;
        case ')':
            m_velocity -= m_velocityDetail ? 1 : 8;
            m_velocity = MAX(m_velocity, 0);
            break;
        case 't': // テンポ
            m_tempo = [self uintTokenOrDefault:m_tempo];
            if (m_tempo == 0) {
                m_tempo = 1;
            }
            track = [m_tracks objectAtIndex:m_trackNo];
            MMLTrack *tempoTrack = [m_tracks objectAtIndex:kTempoTrack];
            [tempoTrack recordTempo:m_tempo
                         globalTick:track.globalTick];
            break;
        case 'q': // ゲートタイム(レート)
            m_gate = [self uintTokenOrDefault:m_gate];
            track = [m_tracks objectAtIndex:m_trackNo];
            [track recordGate:(m_gate *
#if CGFLOAT_IS_DOUBLE
                               1.0
#else
                               1.0f
#endif
             ) / m_maxGate];
            break;
        case '<': // オクターブの上シフト
            m_isRelativeDir ? ++m_octave : --m_octave;
            break;
        case '>': // オクターブの下シフト
            m_isRelativeDir ? --m_octave : ++m_octave;
            break;
        case ';': // トラックの終端
            m_isKeyOff = YES;
            track = [m_tracks objectAtIndex:m_trackNo];
            if (track.eventCount > 0) {
                track = [self newTrack];
                [m_tracks addObject:track];
                [track release];
                ++m_trackNo;
            }
            break;
        case '@': // 拡張
            [self atmarkToken];
            break;
        case 'x': // ボリューム
            track = [m_tracks objectAtIndex:m_trackNo];
            [track recordVolumeMode:[self uintTokenOrDefault:1]];
            break;
        case 'n': // ノート
            c0 = [self characterToken];
            if (c0 == 's') { // シフト
                ++m_stringLocation;
                m_noteShift = [self intTokenOrDefault:m_noteShift];
            }
            else {
                // warning: unknown command
                // c + c0
                NSLog(@"warning: UNKNOWN_COMMAND %c", c0);
                [self addWarning:kMMLEngineWarningUnknownCommand character:c];
            }
            break;
        default:
            if (!isspace(c) && c < 128) {
                // warning: unknown command
                NSLog(@"warning: UNKNOWN_COMMAND %c", c);
                [self addWarning:kMMLEngineWarningUnknownCommand character:c];
            }
            break;
    }
}

- (int)tickFromDotToken:(int)aTick
{
    unichar c = [self characterToken];
    int tick = aTick;
    while (c == '.') {
        ++m_stringLocation;
        tick /= 2;
        aTick += tick;
        c = [self characterToken];
    }
    return aTick;
}

- (int)keySignToken
{
    int key = 0;
    BOOL loop = YES;
    while (loop) {
        unichar c = [self characterToken];
        switch (c) {
            case '+':
            case '#':
                key++;
                ++m_stringLocation;
                break;
            case '-':
                key--;
                ++m_stringLocation;
                break;
            default:
                loop = NO;
                break;
        }
    }
    return key;
}

- (void)parse
{
    NSUInteger stringLength = [m_string length];
    m_stringLocation = 0;
    while (m_stringLocation < stringLength) {
        [self firstLetterToken];
    }
}

static inline void AddIntToArray(NSMutableArray *array, NSInteger i)
{
    NSNumber *number = [[NSNumber alloc] initWithInteger:i];
    [array addObject:number];
    [number release];
}

- (void)parseRepeat
{
    //[lowerString release];
    m_stringLocation = 0;
    NSMutableArray *repeats = [[NSMutableArray alloc] init];
    NSMutableArray *origins = [[NSMutableArray alloc] init];
    NSMutableArray *starts = [[NSMutableArray alloc] init];
    NSMutableArray *lasts = [[NSMutableArray alloc] init];
    NSUInteger stringLength = [m_string length];
    NSRange range;
    int nest = -1;
    m_stringLocation = 0;
    while (m_stringLocation < stringLength) {
        unichar c = [self nextCharacterToken];
        switch (c) {
            case '/':
                // リピート開始
                if ([self characterToken] == ':') {
                    ++m_stringLocation;
                    ++nest;
                    AddIntToArray(origins, m_stringLocation - 2);
                    AddIntToArray(repeats, [self uintTokenOrDefault:2]);
                    AddIntToArray(starts, m_stringLocation);
                    AddIntToArray(lasts, -1);
                }
                else if (nest >= 0) {
                    NSNumber *number = [[NSNumber alloc] initWithInteger:m_stringLocation - 1];
                    [lasts replaceObjectAtIndex:nest
                                     withObject:number];
                    [number release];
                    [m_string deleteCharactersInRange:NSMakeRange(m_stringLocation - 1, 1)];
                    m_stringLocation--;
                    stringLength = [m_string length];
                }
                break;
            case ':':
                // リピート終了
                if ([self characterToken] == '/' && nest >= 0) {
                    ++m_stringLocation;
                    NSNumber *start = [starts objectAtIndex:nest];
                    NSNumber *last = [lasts objectAtIndex:nest];
                    NSNumber *origin = [origins objectAtIndex:nest];
                    NSNumber *repeat = [repeats objectAtIndex:nest];
                    int startValue = [start intValue];
                    int lastValue = [last intValue];
                    range = NSMakeRange(startValue, m_stringLocation - 2 - startValue);
                    NSString *contents = [m_string substringWithRange:range];
                    range = NSMakeRange(0, [origin intValue]);
                    NSString *stringToCopy = [m_string substringWithRange:range];
                    NSMutableString *newString = [[NSMutableString alloc] initWithString:stringToCopy];
                    int repeatValue = [repeat intValue];
                    for (int i = 0; i < repeatValue; i++) {
                        if (i < repeatValue - 1 || lastValue < 0) {
                            [newString appendString:contents];
                        }
                        else {
                            range = NSMakeRange(startValue, lastValue - startValue);
                            NSString *stringToAdd = [m_string substringWithRange:range];
                            [newString appendString:stringToAdd];
                            //[stringToAdd release];
                        }
                    }
                    NSUInteger newStringLength = [newString length];
                    NSString *stringToAdd = [m_string substringFromIndex:m_stringLocation];
                    [newString appendString:stringToAdd];
                    [self setStringToParse:newString];
                    [newString release];
                    //[stringToAdd release];
                    //[stringToCopy release];
                    //[contents release];
                    m_stringLocation = newStringLength;
                    stringLength = [m_string length];
                    [repeats removeObjectAtIndex:nest];
                    [origins removeObjectAtIndex:nest];
                    [starts removeObjectAtIndex:nest];
                    [lasts removeObjectAtIndex:nest];
                    --nest;
                }
                break;
            default:
                break;
        }
    }
    [repeats release];
    [origins release];
    [starts release];
    [lasts release];
    if (nest >= 0) {
        // warning UNCLOSED_REPEAT
        NSLog(@"warning: UNCLOSED_REPEAT");
        [self addWarning:kMMLEngineWarningUnclosedRepeat];
    }
}

typedef struct _MMLMacroArgument {
    NSString *name;
    int index;
} MMLMacroArgument;

typedef struct _MMLMacroValue {
    NSMutableString *code;
    NSArray *arguments;
} MMLMacroValue;

static NSInteger CompareAllKeys(id x, id y, void *context)
{
    NSUInteger xl = [(NSString *)x length];
    NSUInteger yl = [(NSString *)y length];
    if (xl > yl) {
        return NSOrderedAscending;
    }
    else if (xl == yl) {
        return NSOrderedSame;
    }
    else {
        return NSOrderedDescending;
    }
}

+ (void)getArgumentsFromKey:(NSString *)aKey
                  arguments:(NSMutableArray *)anArguments
{
    NSRange start = [aKey rangeOfString:@"{"];
    NSRange end = [aKey rangeOfString:@"}"];
    if (start.location != NSNotFound && end.location != NSNotFound && start.location < end.location) {
        NSString *name = [aKey substringWithRange:NSMakeRange(start.location + 1, end.location - start.location - 1)];
        NSArray *args = [name componentsSeparatedByString:@","];
        int i = 0;
        for (NSString *arg in args) {
            MMLMacroArgument *argument = malloc(sizeof(MMLMacroArgument));
            argument->name = [[self class] newTrimmedString:arg];
            argument->index = i;
            NSValue *argumentValue = [[NSValue alloc] initWithBytes:argument
                                                           objCType:@encode(MMLMacroArgument)];
            [anArguments addObject:argumentValue];
            [argumentValue release];
            i++;
        }
    }
}

- (BOOL)replaceMacroFromDictionary:(NSDictionary *)aDictionary
{
    NSUInteger stringLength = [m_string length];
    NSCharacterSet *space = [NSCharacterSet whitespaceCharacterSet];
    NSArray *keys = [[aDictionary allKeys] sortedArrayUsingFunction:CompareAllKeys
                                                            context:nil];
    for (NSString *key in keys) {
        NSUInteger keyLength = [key length];
        NSRange range = NSMakeRange(m_stringLocation, keyLength);
        if (keyLength + m_stringLocation <= stringLength
            && [[m_string substringWithRange:range] isEqualToString:key]) {
            MMLMacroValue value;
            NSInteger start = m_stringLocation, last = start + keyLength;
            NSValue *valueValue = [aDictionary objectForKey:key];
            [valueValue getValue:&value];
            NSMutableString *code = [[NSMutableString alloc] initWithString:value.code];
            m_stringLocation += keyLength;
            unichar c = [self characterToken];
            while ([space characterIsMember:c]) {
                c = [self nextCharacterToken];
            }
            NSArray *argumentValues = [NSArray array];
            if (c == '{') {
                c = [self nextCharacterToken];
                while (c != '}' && c != 0) {
                    if (c == '$')
                        [self replaceMacroFromDictionary:aDictionary];
                    c = [self nextCharacterToken];
                }
                last = m_stringLocation;
                NSInteger from = start + keyLength + 1, length = last - 1 - from;
                argumentValues = [[m_string substringWithRange:NSMakeRange(from, length)] componentsSeparatedByString:@","];
            }
            NSArray *arguments = value.arguments;
            NSInteger codeLength = [code length], argsLength = [argumentValues count], macroArgumentCount = [arguments count];
            for (NSInteger i = 0; i < codeLength; i++) {
                for (NSInteger j = 0; j < argsLength; j++) {
                    if (j >= macroArgumentCount)
                        break;
                    MMLMacroArgument argument, argumentAtJ;
                    NSValue *argumentValue = [arguments objectAtIndex:j], *argumentValueAtJ;
                    [argumentValue getValue:&argument];
                    NSString *argumentKey = argument.name, *subs = [NSString stringWithFormat:@"%%%@", argumentKey];
                    NSInteger subsLength = [subs length];
                    range = NSMakeRange(i, subsLength);
                    if (codeLength >= i + subsLength && [[code substringWithRange:range] isEqualToString:subs]) {
                        [code replaceCharactersInRange:range
                                            withString:[argumentValues objectAtIndex:argument.index]];
                        codeLength = [code length];
                        argumentValueAtJ = [arguments objectAtIndex:j];
                        [argumentValueAtJ getValue:&argumentAtJ];
                        NSString *arg = [argumentValues objectAtIndex:argumentAtJ.index];
                        i += [arg length] - 1;
                        break;
                    }
                }
            }
            NSString *front = [m_string substringWithRange:NSMakeRange(0, start - 1)];
            NSString *back = [m_string substringFromIndex:last];
            m_stringLocation = start - 1;
            NSMutableString *newString = [[NSMutableString alloc] init];
            [newString appendString:front];
            [newString appendString:code];
            [newString appendString:back];
            [self setStringToParse:newString];
            [code release];
            [newString release];
            return YES;
        }
    }
    return NO;
}

- (void)parseMacro
{
    NSUInteger stringLength = [m_string length];
    NSMutableString *newString = [[NSMutableString alloc] initWithCapacity:stringLength];
    NSCharacterSet *space = [NSCharacterSet whitespaceCharacterSet];
    NSCharacterSet *newline = [NSCharacterSet newlineCharacterSet];
    NSCharacterSet *comma = [NSCharacterSet characterSetWithCharactersInString:@","];
    NSCharacterSet *waveCharset = [NSCharacterSet characterSetWithCharactersInString:@" "
                                   "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"];
    NSCharacterSet *waveCharset2 = [NSCharacterSet characterSetWithCharactersInString:@"+/="
                                    "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"];
    NSRange range = NSMakeRange(0, stringLength);
    
    while (range.length > 0) {
        NSRange rangeFrom = NSMakeRange(range.location, 0);
        NSRange subrange = [m_string lineRangeForRange:rangeFrom];
        NSString *aLine = [m_string substringWithRange:subrange];
        // #OCTAVE REVERSE / オクターブの意味を反転させる
        NSScanner *aScanner = [[NSScanner alloc] initWithString:aLine];
        [aScanner setCharactersToBeSkipped:space];
        if ([aScanner scanString:@"#OCTAVE" intoString:nil]) {
            if ([aScanner scanString:@"REVERSE" intoString:nil]) {
                m_isRelativeDir = NO;
                NextLine(&aScanner, &range, subrange);
                continue;
            }
        }
        else if ([aScanner scanString:@"#WAV9" intoString:nil]) {
            int waveIndex = 0, intVol = 0, loopFlag = 0;
            NSString *waveString = nil;
            if ([aScanner scanInt:&waveIndex] &&
                [aScanner scanCharactersFromSet:comma intoString:nil] &&
                [aScanner scanInt:&intVol] &&
                [aScanner scanCharactersFromSet:comma intoString:nil] &&
                [aScanner scanInt:&loopFlag] &&
                [aScanner scanCharactersFromSet:comma intoString:nil] &&
                [aScanner scanCharactersFromSet:waveCharset2 intoString:&waveString]) {
                [FCDPCM setWaveWithIndex:waveIndex
                                  intVol:intVol
                                loopFlag:loopFlag
                              waveString:waveString];
                NextLine(&aScanner, &range, subrange);
                continue;
            }
        }
        // #WAV10
        else if ([aScanner scanString:@"#WAV10" intoString:nil]) {
            int waveNumber = 0;
            NSString *waveString = nil;
            [aScanner scanInt:&waveNumber];
            if ([aScanner scanCharactersFromSet:comma intoString:nil] &&
                [aScanner scanCharactersFromSet:waveCharset intoString:&waveString]) {
                NSString *waveLowered = [waveString lowercaseString];
                NSMutableString *finalWaveString = [[NSMutableString alloc] initWithString:waveLowered];
                [finalWaveString appendString:@"00000000000000000000000000000000"];
                [GBWave setWaveString:finalWaveString no:waveNumber];
                [finalWaveString release];
                //[mutableWaveString release];
                //[waveLowered release];
                //[waveString release];
                NextLine(&aScanner, &range, subrange);
                continue;
            }
        }
        [newString appendString:aLine];
        //[aLine release];
        NextLine(&aScanner, &range, subrange);
    }
    [self setStringToParse:newString];
    [newString release];
    
    // macro
    m_stringLocation = 0;
    BOOL top = YES;
    NSUInteger last = 0;
    NSMutableDictionary *aDictionary = [[NSMutableDictionary alloc] init];
    NSCharacterSet *variantCharset = [NSCharacterSet characterSetWithCharactersInString:@"#+()"
                                      "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789"];
    stringLength = [m_string length];
    while (m_stringLocation < stringLength) {
        unichar c = [self nextCharacterToken];
        switch (c) {
            case '$': // マクロ記号
                if (top) {
                    range = NSMakeRange(m_stringLocation, [m_string length] - m_stringLocation);
                    last = [m_string rangeOfString:@";"
                                         options:0
                                           range:range].location;
                    // 変数の終着点が見つかった
                    if (last != NSNotFound && last > m_stringLocation) {
                        range = NSMakeRange(m_stringLocation, last - m_stringLocation);
                        NSString *macro = [m_string substringWithRange:range];
                        NSArray *variant = [macro componentsSeparatedByString:@"="];
                        NSString *aId = [variant objectAtIndex:0];
                        // 値の名前と値が両方存在し、かつ値の名前が1byte以上であること
                        if ([variant count] == 2 && [aId length] >= 1) {
                            // 変数名を検証する。一文字目は英字かアンダースコアであることが条件
                            NSInteger macroStartAt = m_stringLocation;
                            NSInteger keyEndAt = [m_string rangeOfString:@"="].location;
                            int variantLetter = [aId characterAtIndex:0];
                            if (isalnum(variantLetter) || variantLetter == '_') {
                                NSMutableArray *arguments = [[NSMutableArray alloc] init];
                                NSScanner *aScanner = [[NSScanner alloc] initWithString:aId];
                                NSString *aKey;
                                if ([aScanner scanCharactersFromSet:variantCharset
                                                         intoString:&aKey]) {
                                    [[self class] getArgumentsFromKey:aId
                                                            arguments:arguments];
                                    m_stringLocation = keyEndAt + 1;
                                    c = [self nextCharacterToken];
                                    while (m_stringLocation < last) {
                                        if (c == '$') {
                                            if (![self replaceMacroFromDictionary:aDictionary]) {
                                                range = NSMakeRange(m_stringLocation, [aId length]);
                                                if ([[m_string substringWithRange:range] isEqualToString:aId]) {
                                                    m_stringLocation--;
                                                    range = NSMakeRange(m_stringLocation, [aId length]);
                                                    [m_string deleteCharactersInRange:range];
                                                }
                                            }
                                            range = NSMakeRange(m_stringLocation, [m_string length] - m_stringLocation);
                                            last = [m_string rangeOfString:@";"
                                                                   options:0
                                                                     range:range].location;
                                        }
                                        c = [self nextCharacterToken];
                                    }
                                }
                                [aScanner release];
                                NSInteger codeLength = last - keyEndAt - 1;
                                MMLMacroValue *value = malloc(sizeof(MMLMacroValue));
                                range = NSMakeRange(keyEndAt + 1, codeLength);
                                value->code = [NSMutableString stringWithString:[m_string substringWithRange:range]];
                                value->arguments = arguments;
                                NSValue *valueValue = [[NSValue alloc] initWithBytes:value
                                                                            objCType:@encode(MMLMacroValue)];
                                [aDictionary setObject:valueValue
                                                forKey:aKey];
                                [valueValue release];
                                NSInteger from = macroStartAt - 1, to = last - from;
                                [m_string deleteCharactersInRange:NSMakeRange(from, to)];
                                m_stringLocation = macroStartAt - 1;
                                stringLength = [m_string length];
                            }
                        }
                        else {
                            [self replaceMacroFromDictionary:aDictionary];
                            stringLength = [m_string length];
                            top = NO;
                        }
                        //[variant release];
                        //[macro release];
                    }
                    else {
                        [self replaceMacroFromDictionary:aDictionary];
                        stringLength = [m_string length];
                        top = NO;
                    }
                }
                else {
                    [self replaceMacroFromDictionary:aDictionary];
                    stringLength = [m_string length];
                    top = NO;
                }
                break;
            case ';':
                top = YES;
                break;
            default:
                if (![space characterIsMember:c] && ![newline characterIsMember:c]) {
                    top = NO;
                }
                break;
        }
    }
    /*
    for (NSString *key in aDictionary) {
        NSValue *valueValue = [aDictionary objectForKey:key];
        MMLMacroValue value;
        [valueValue getValue:&value];
        for (NSValue *argumentValue in value.arguments) {
            MMLMacroArgument argument;
            [argumentValue getValue:&argument];
            free(argument);
        }
        free(value);
    }
     */
    [aDictionary release];
}

- (void)parseComment
{
    m_stringLocation = 0;
    NSInteger commentStart = -1;
    NSUInteger stringLength = [m_string length];
    while (m_stringLocation < stringLength) {
        unichar c = [self nextCharacterToken];
        switch (c) {
            case '/':
                if ([self characterToken] == '*') {
                    if (commentStart < 0) {
                        commentStart = m_stringLocation - 1;
                    }
                    ++m_stringLocation;
                }
                break;
            case '*':
                if ([self characterToken] == '/') {
                    if (commentStart >= 0) {
                        NSRange range = NSMakeRange(commentStart, m_stringLocation + 1 - commentStart);
                        [m_string deleteCharactersInRange:range];
                        m_stringLocation = commentStart;
                        stringLength = [m_string length];
                        commentStart = -1;
                    }
                    else {
                        // warning UNOPENEDCOMMENT
                        NSLog(@"warning: UNOPENED_COMMENT");
                        [self addWarning:kMMLEngineWarningUnopenedComment];
                    }
                }
                break;
            default:
                break;
        }
    }
    if (commentStart >= 0) {
        // warning UNCLOSED_COMMET
        NSLog(@"warning: UNCLOSED_COMMENT");
        [self addWarning:kMMLEngineWarningUnclosedComment];
    }
}

- (NSArray *)dumpTracks
{
    NSMutableArray *r = [NSMutableArray array];
    for (MMLTrack *track in m_tracks) {
        [r addObject:[track dumpTrackEvents]];
    }
    return r;
}

@end
