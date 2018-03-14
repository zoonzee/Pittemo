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
//  MMLFormant.m
//  OCMML
//
//  Created by hkrn on 09/02/05.
//  Copyright 2009 hkrn. All rights reserved.
//
//  $Id$
//

#import "MMLFormant.h"

@implementation MMLFormant

#if CGFLOAT_IS_DOUBLE
static CGFloat s_coeff[5][11] = {
{
8.11044e-06, 8.943665402, -36.83889529, 92.01697887, -154.337906, 181.6233289,
-151.8651235, 89.09614114, -35.10298511, 8.388101016, -0.923313471 
},
{
4.36215e-06, 8.90438318, -36.55179099, 91.05750846, -152.422234, 179.1170248,
-149.6496211, 87.78352223, -34.60687431, 8.282228154, -0.914150747
},
{
3.33819e-06, 8.893102966, -36.49532826, 90.96543286, -152.4545478, 179.4835618,
-150.315433, 88.43409371, -34.98612086, 8.407803364, -0.932568035
},
{
1.13572e-06, 8.994734087, -37.2084849, 93.22900521, -156.6929844, 184.596544,
-154.3755513, 90.49663749, -35.58964535, 8.478996281, -0.929252233
},
{
4.09431e-07, 8.997322763, -37.20218544, 93.11385476, -156.2530937, 183.7080141,
-153.2631681, 89.59539726, -35.12454591, 8.338655623, -0.910251753
}
};
#else
static CGFloat s_coeff[5][11] = {
{
8.11044e-06f, 8.943665402f, -36.83889529f, 92.01697887f, -154.337906f, 181.6233289f,
-151.8651235f, 89.09614114f, -35.10298511f, 8.388101016f, -0.923313471f 
},
{
4.36215e-06f, 8.90438318f, -36.55179099f, 91.05750846f, -152.422234f, 179.1170248f,
-149.6496211f, 87.78352223f, -34.60687431f, 8.282228154f, -0.914150747f
},
{
3.33819e-06f, 8.893102966f, -36.49532826f, 90.96543286f, -152.4545478f, 179.4835618f,
-150.315433f, 88.43409371f, -34.98612086f, 8.407803364f, -0.932568035f
},
{
1.13572e-06f, 8.994734087f, -37.2084849f, 93.22900521f, -156.6929844f, 184.596544f,
-154.3755513f, 90.49663749f, -35.58964535f, 8.478996281f, -0.929252233f
},
{
4.09431e-07f, 8.997322763f, -37.20218544f, 93.11385476f, -156.2530937f, 183.7080141f,
-153.2631681f, 89.59539726f, -35.12454591f, 8.338655623f, -0.910251753f
}
};
#endif

- (id)init
{
    self = [super init];
    if (self != nil) {
        for (int i = 0; i < 10; i++) {
            m_leftMemory[i] = 0;
            m_rightMemory[i] = 0;
        }
        m_vowel = kMMLFormantVowelA;
        m_point = 0;
        m_power = NO;
        m_length = 10;
    }
    return self;
}

- (void)setVowel:(enum MMLFormantVowelType)vowel
{
    m_power = YES;
    m_vowel = vowel;
}

- (void)disable
{
    m_power = NO;
    [self reset];
}

- (void)reset
{
    for (int i = m_length - 1; i >= 0; i--) {
        m_leftMemory[i] = m_rightMemory[i] = 0;
    }
}

- (enum MMLFormantVowelType)vowel
{
    return m_vowel;
}

- (void)runWithSamples:(CGFloat *)samples
                 start:(int)start
                   end:(int)end
{
    if (!m_power)
        return;
    CGFloat *coeff = s_coeff[m_vowel];
    for (int i = start; i < end; i++) {
        CGFloat sample = samples[i];
        CGFloat value = (
                         coeff[0] * sample +
                         coeff[1] * m_leftMemory[0] +
                         coeff[2] * m_leftMemory[1] +
                         coeff[3] * m_leftMemory[2] +
                         coeff[4] * m_leftMemory[3] +
                         coeff[5] * m_leftMemory[4] +
                         coeff[6] * m_leftMemory[5] +
                         coeff[7] * m_leftMemory[6] +
                         coeff[8] * m_leftMemory[7] +
                         coeff[9] * m_leftMemory[8] +
                         coeff[10] * m_leftMemory[9]
                         );
        samples[i] = value;
        m_leftMemory[9] = m_leftMemory[8];
        m_leftMemory[8] = m_leftMemory[7];
        m_leftMemory[7] = m_leftMemory[6];
        m_leftMemory[6] = m_leftMemory[5];
        m_leftMemory[5] = m_leftMemory[4];
        m_leftMemory[4] = m_leftMemory[3];
        m_leftMemory[3] = m_leftMemory[2];
        m_leftMemory[2] = m_leftMemory[1];
        m_leftMemory[1] = m_leftMemory[0];
        m_leftMemory[0] = value;
    }
}

@end
